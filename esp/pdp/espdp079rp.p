/**********************************************************************************
** Programa: esp/pdp/espdp079rp.p
** Vers∆o..: 1.00
** Data....: 16/12/2013
** Autor...: Estevan KrÅger - Sensus
** Obs.....: Criaá∆o do pedido de venda conforme planilha importada
             01/09/2014 - Alterado para adaptar ao template relat¢rio.
**********************************************************************************
** Vers∆o..: 1.01
** Data....: 22/09/2022
** Autor...: Mauricio C. - iDBA
** Obs.....: Inclus∆o do Repres na linha do item; int-ped-item-pci   
**********************************************************************************
** Vers∆o..: 1.02
** Data....: 20/08/2023
** Autor...: Bruno Joaquim - iDBA
** Obs.....: Inclus∆o regras receita recorrente conforme chamado C2307-0983   
**********************************************************************************/

{include/i-prgvrs.i espdp079rp 2.00.00.001}  
{esp/esb/esesb000.i}.
{esp/es0018.i}.

DEF BUFFER b-emitente FOR emitente.
def buffer b-repres   for repres.
define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
    field raw-digita       as raw.

define temp-table tt-param no-undo
    field destino              as integer
    field arquivo              as char format "x(35)"
    field usuario              as char format "x(12)"
    field data-exec            as date
    field hora-exec            as integer
    field classifica           as integer
    field desc-classifica      as char format "x(40)"
    field modelo-rtf           as char format "x(35)"
    field l-habilitaRtf        as LOG
    FIELD tp-execucao          AS INTEGER
    FIELD c-arq-import         AS CHARACTER
    FIELD l-efetiva-pedido     AS LOGICAL
    FIELD l-import-preco       AS LOGICAL
    FIELD l-mantem-data        AS LOG
    FIELD l-contrato           AS LOG
    FIELD l-receita-recorrente AS LOG .

DEFINE TEMP-TABLE ProdutoItemR NO-UNDO XML-NODE-NAME 'ProdutoItem'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoProduto               AS CHAR
    FIELD PrecoBase                   AS DEC
    FIELD ValorProduto                AS DEC
    FIELD NomePoliticaComercial       AS CHAR
    FIELD TemCache                    AS LOGICAL
    FIELD DataValidade                AS DATE
    FIELD QuantidadeMaxima            AS DEC
    FIELD RebateAntecipado            AS LOGICAL
    FIELD CalcularRebate              AS LOGICAL
    FIELD PrecoAlterado               AS LOGICAL
    FIELD ValorComDesconto            AS DEC
    FIELD PercentualDescontoVerde     AS DEC
    FIELD PercentualDescontoTopMilhao AS DEC
    FIELD PercentualRebateAntecipado  AS DEC.

DEFINE TEMP-TABLE ProdutoItem NO-UNDO XML-NODE-NAME 'ProdutoItem'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoProduto            AS CHAR
    FIELD Bloqueado                AS LOG
    FIELD Cached                   AS LOG
    FIELD TipoPortfolio            AS INT.  /* 993520000: Box Mover
                                                993520001: VAD
                                                993520002: Exclusivo
                                                993520003: Cross-Selling
                                                993520004: Soluá∆o */


DEFINE TEMP-TABLE tt-itens NO-UNDO
    FIELD it-codigo              AS CHAR
    FIELD de-quantidade          AS DEC
    FIELD TipoPortfolio          AS INTEGER
    FIELD CodigoUnidadeNegocio   AS CHAR
    FIELD CodigoFamiliaComercial AS CHAR
    FIELD CodigoEstabelecimento  AS CHAR.

    
DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

    FIND LAST param-global NO-LOCK NO-ERROR.

create tt-param.
raw-transfer raw-param to tt-param.

DEFINE TEMP-TABLE tt-erro-local NO-UNDO
    FIELD mensagem  AS CHARACTER FORMAT "x(250)".

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem  AS CHARACTER FORMAT "x(250)".

/*--- Definiá∆o dos ParÉmetros ---*/

/*--- Definiá∆o das Temp-Tables ---*/
DEFINE TEMP-TABLE tt-ped-venda-arq NO-UNDO
    FIELD cod-estabel                       AS CHARACTER
    FIELD cod-cliente                       AS INTEGER
    FIELD nr-tabpre                         AS CHARACTER
    FIELD nr-proposta                       AS CHARACTER
    FIELD atendente                         AS CHARACTER
    FIELD destino                           AS CHARACTER /* Uso Pr¢prio ou Revenda */
    FIELD rota                              AS CHARACTER
    FIELD nat-operacao                      AS CHARACTER
    FIELD unid-comerc                       AS CHARACTER
    FIELD cod-priori                        AS CHARACTER
    FIELD dt-entrega                        AS DATE
    FIELD cod-cond-pag                      AS INTEGER
    FIELD nm-abrev-transp                   AS CHARACTER
    FIELD obs-pedido                        AS CHARACTER
    FIELD obs-nota                          AS CHARACTER
    FIELD cod-repres                        AS CHARACTER
    FIELD nome-abrev-tri                    AS CHARACTER
    FIELD l-proposta-vazio                  AS LOGICAL
    FIELD po-cliente                        AS CHARACTER
    FIELD l-troca-nota                      AS CHARACTER
    FIELD pedido-servico                    AS CHARACTER                             /*Pedido*/                     
    FIELD item-servico                      AS CHARACTER                             /*Item*/                       
    FIELD folha-registro                    AS CHARACTER                             /*Folha de Registro*/          
    FIELD tp-servico                        LIKE int-ped-item-adic.tp-servico        /*Tipo de Serviáo*/            
    FIELD cidade-servico                    LIKE int-ped-item-adic.cidade-servico    /*Cidade prestaá∆o de Serviáo*/
    FIELD uf-servico                        AS CHAR                                  /*UF prestaá∆o de Serviáo*/ 
    FIELD pais-servico                      AS CHAR                                  /*Pa°s prestaá∆o de Serviáo*/
    FIELD mes-competencia                   LIKE int-ped-item-adic.mes-competencia   /*Màs de competància*/         
    FIELD circuito-cliente                  LIKE int-ped-item-adic.circuito-cliente  /*Circuito do Cliente*/        
    FIELD nome-cliente                      LIKE int-ped-item-adic.nome-cliente      /*Nome do Cliente*/            
    FIELD email-gestor                      LIKE int-ped-item-adic.email-gestor      /*Gestor e e-mail gestor*/   
    FIELD nome-tr-red                       LIKE ped-venda.nome-tr-red
    FIELD dt-cond-espec                     AS DATE INITIAL ?
    FIELD pc-desc-pedido                    AS CHAR
    FIELD cod-projeto                       AS CHAR
    FIELD cod-canal-venda                   AS CHAR
    FIELD num-dias-parc                     AS CHAR
    FIELD nr-contrato                       AS CHAR FORMAT "x(12)" 
    FIELD linha                             AS CHAR FORMAT "x(6)"
    FIELD receita-rec-parcela-ini           AS INT 
    FIELD receita-rec-nr-parcelas           AS INT 
    FIELD receita-rec-data-vcto-parecela    AS DATE .

DEFINE TEMP-TABLE tt-ped-item-arq NO-UNDO
    FIELD nr-proposta      AS CHARACTER
    FIELD it-codigo        AS CHARACTER
    FIELD qtd              AS DECIMAL
    FIELD preco            AS DECIMAL
    FIELD pc-desc          AS CHAR
    FIELD cod-repres       AS CHARACTER
    FIELD nr-tabpre        AS CHAR
    FIELD linha            AS CHAR FORMAT "x(6)".
    .

DEFINE TEMP-TABLE tt-ped-venda     NO-UNDO LIKE ped-venda
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-ped-item      NO-UNDO LIKE ped-item
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-ped-ent       NO-UNDO LIKE ped-ent
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-ped-repre     NO-UNDO LIKE ped-repre
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-int-ped-venda NO-UNDO LIKE int-ped-venda
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-int-ped-item  NO-UNDO LIKE int-ped-item
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-int-ped-item-pci  NO-UNDO LIKE mgesp.int-ped-item-pci
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-ped-venda-aux NO-UNDO LIKE tt-ped-venda.

DEFINE TEMP-TABLE tt-prog-ponto2 NO-UNDO LIKE tt-prog-ponto.
DEFINE TEMP-TABLE tt-prog-ponto3 NO-UNDO LIKE tt-prog-ponto.

DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD errorSequence     AS INT
    FIELD errorNumber       AS INT
    FIELD errorDescription  AS CHAR FORMAT "x(150)"
    FIELD errorParameters   AS CHAR
    FIELD errorType         AS CHAR
    FIELD errorHelp         AS CHAR FORMAT "x(150)"
    FIELD errorSubtype      AS CHAR.


DEFINE TEMP-TABLE tt-ped-item-seq-parcela
    FIELD nr-pedcli     LIKE ped-item.nr-pedcli 
    FIELD nome-abrev    LIKE ped-item.nome-abrev
    FIELD it-codigo     LIKE ped-item.it-codigo 
    FIELD nr-sequencia  LIKE ped-item.nr-sequencia 
    FIELD parcela       AS   INT FORMAT 999
    FIELD dt-entrega    AS   DATE .


DEFINE TEMP-TABLE tt-ped-parcela
    FIELD nr-pedcli        LIKE int-ped-item.nr-pedcli        
    FIELD it-codigo        LIKE int-ped-item.it-codigo        
    FIELD nr-sequencia     LIKE int-ped-item.nr-sequencia     
    FIELD nr-parcela-recor LIKE int-ped-item.nr-parcela-recor .

/*--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE l-return                AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE l-erro                  AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE de-vl-pre-liq-filho     AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE i-sequencia             AS INTEGER                     NO-UNDO.
DEFINE VARIABLE i-cont                  AS INTEGER                     NO-UNDO.
DEFINE VARIABLE i-linha                 AS INTEGER                     NO-UNDO.
DEFINE VARIABLE h-acomp                 AS HANDLE                      NO-UNDO.
DEFINE VARIABLE h-bodi154sdf            AS HANDLE                      NO-UNDO.
DEFINE VARIABLE h-bodi154               AS HANDLE                      NO-UNDO.
DEFINE VARIABLE h-bodi157               AS HANDLE                      NO-UNDO.
DEFINE VARIABLE h-bodi159               AS HANDLE                      NO-UNDO.
DEFINE VARIABLE h-bodi159com            AS HANDLE                      NO-UNDO.
DEFINE VARIABLE h-bodi159cal            AS HANDLE                      NO-UNDO.
DEFINE VARIABLE h-bodi159sus            AS HANDLE                      NO-UNDO.
DEFINE VARIABLE h-boes505               AS HANDLE                      NO-UNDO.
DEFINE VARIABLE c-desc-suspend          AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-linha                 AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-nat-oper              LIKE natur-oper.nat-operacao   NO-UNDO.
DEFINE VARIABLE d-vl-liq-abe            LIKE tt-ped-item.vl-liq-abe    NO-UNDO.
DEFINE VARIABLE d-vl-liq-it             LIKE tt-ped-item.vl-liq-abe    NO-UNDO.
DEFINE VARIABLE h-msg138a               AS HANDLE                      NO-UNDO.
DEFINE VARIABLE c-cod-transp            AS INTEGER                     NO-UNDO.
DEFINE VARIABLE c-sigla-transp          AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-nome-transp           AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-lista-pedidos         AS CHARACTER                   NO-UNDO.
DEFINE variable c-nr-pedido             AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE p-indice-financiamento  AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE de-perc-icms            AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE de-perc-desc-icms       AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE l-regra-vencto-ok       AS LOG INIT YES. 
DEFINE VARIABLE de-valor-item           AS DEC                         NO-UNDO.
DEFINE VARIABLE i-parcela               AS INT                         NO-UNDO.
DEFINE VARIABLE d-perc-parcela          AS DEC                         NO-UNDO.
DEFINE VARIABLE d-resto-parcela         AS DEC                         NO-UNDO.
DEFINE VARIABLE d-data-parcela          AS DATE                        NO-UNDO.
DEFINE VARIABLE d-dias-parcela          AS INT                         NO-UNDO.
DEFINE VARIABLE i-nr-parc               AS INT                         NO-UNDO.
DEFINE VARIABLE i-num-dias              AS INT                         NO-UNDO.
DEFINE VARIABLE de-fator-cli            AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE nr-contrato             LIKE ped-venda.nr-contrato     NO-UNDO.
DEFINE VARIABLE l-incrementa-parcela    AS LOG                         NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE i-ep-codigo-usuario AS CHARACTER   NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE l-mantem-data-espdp079 AS LOG   NO-UNDO.

DEFINE VARIABLE l-log                AS LOGICAL     NO-UNDO.
ASSIGN l-log = NO.

ASSIGN l-mantem-data-espdp079  = NO.

IF tt-param.l-mantem-data THEN
    ASSIGN l-mantem-data-espdp079 = YES.

/*------------------------*/
/*     I N C L U D E S    */
/*------------------------*/
/* include padr∆o para vari†veis de relat¢rio  */
{include/i-rpvar.i}
{include/i-rpout.i}
{include/i-rpcab.i}
{utp/ut-glob.i}


/* bloco principal do programa */
ASSIGN c-programa     = "espdp079"
       c-versao       = "2.00"
       c-revisao      = ".00.001"
       c-empresa      = "Intelbras"
       c-sistema      = "Pedidos"
       c-titulo-relat = "Importaá∆o de Pedidos".

/*--- Processamento Principal ---*/
IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Importando Pedido").

FIND FIRST para-ped     NO-LOCK NO-ERROR.
FIND FIRST para-fat     NO-LOCK NO-ERROR.
FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST mgcad.empresa      NO-LOCK
     WHERE mgcad.empresa.ep-codigo = i-ep-codigo-usuario NO-ERROR.


IF  NOT VALID-HANDLE(h-boes505) THEN
    RUN esbo/boes505.p PERSISTENT SET h-boes505.

EMPTY TEMP-TABLE tt-prog-ponto3.
RUN esp/es0018p.p (INPUT "espdp079":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto3).


RUN CriaPedido.

    IF l-log = YES THEN
        PUT "antes LOG " CAN-FIND( FIRST tt-erro-local) " " l-erro SKIP.


FOR EACH tt-erro-local:
    PUT tt-erro-local.mensagem FORMAT "x(200)" SKIP.
END.
RETURN "OK":U.

PROCEDURE CriaPedido:
DO TRANSACTION:
    IF l-log = YES THEN
        PUT "1" SKIP.
    
    RUN pi-cria-tt-arquivo.

    ASSIGN c-lista-pedidos = "".


    /*************** PEDIDO *******************/
    blk_pedido:
    FOR EACH tt-ped-venda-arq NO-LOCK:

        RUN pi-acompanhar IN h-acomp (INPUT "Gerando pedido: " + tt-ped-venda-arq.nr-proposta).
        
        EMPTY TEMP-TABLE tt-ped-venda.
        EMPTY TEMP-TABLE tt-ped-item.
        EMPTY TEMP-TABLE tt-ped-repre.
        EMPTY TEMP-TABLE tt-ped-ent.
        EMPTY TEMP-TABLE tt-int-ped-venda.
        EMPTY TEMP-TABLE tt-int-ped-item.
        empty temp-table tt-int-ped-item-pci.

        ASSIGN l-erro = NO.

        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p (INPUT  "espdp079":U,
                           INPUT  5,
                           INPUT  0,
                           INPUT  "":U,
                           OUTPUT TABLE tt-prog-ponto).
        FIND FIRST tt-prog-ponto  NO-ERROR.

        IF  tt-ped-venda-arq.dt-entrega > (TODAY + (365 * int(tt-prog-ponto.conteudo))) /* se for maior que 3 anos, ent∆o emitir mensagem*/ THEN DO:
            CREATE tt-erro-local.
            ASSIGN l-erro  =  YES.
                   tt-erro-local.mensagem = tt-ped-venda-arq.linha + "Cliente: " + string(tt-ped-venda-arq.cod-cliente) + 
                                            " ; Data de entrega informada: " + string(tt-ped-venda-arq.dt-entrega, "99/99/9999") + 
                                            " ; Data excede " + tt-prog-ponto.conteudo + " anos, verifique se a data est† correta".
            NEXT blk_pedido.
        END.

        FIND FIRST repres NO-LOCK
            WHERE  repres.cod-rep = integer(tt-ped-venda-arq.cod-repres) NO-ERROR.

        IF l-log = YES THEN
            PUT "2" SKIP.
        IF NOT AVAIL repres THEN DO:
            CREATE tt-erro-local.
            ASSIGN tt-erro-local.mensagem = tt-ped-venda-arq.linha + "C¢digo representante pedido n∆o foi encontrado. " + string(tt-ped-venda-arq.cod-repres)
                   l-erro            =  YES.

            NEXT blk_pedido.
        END.

        FIND FIRST cond-pagto NO-LOCK
             WHERE cond-pagto.cod-cond-pag = 1 /* Ö vista */ NO-ERROR.


        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.ep-codigo   = mgcad.empresa.ep-codigo
               AND estabelec.cod-estabel = tt-ped-venda-arq.cod-estabel NO-ERROR.
        IF  NOT AVAIL estabelec THEN DO:
            CREATE tt-erro-local.
            ASSIGN tt-erro-local.mensagem = tt-ped-venda-arq.linha + "Estabelecimento " + tt-ped-venda-arq.cod-estabel + " n∆o cadastrado para a Empresa " + STRING(mgcad.empresa.ep-codigo) + "."
                   l-erro           = YES.

            NEXT blk_pedido.
        END.

        
        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = tt-ped-venda-arq.cod-cliente NO-ERROR.
        IF AVAIL emitente THEN
            FIND FIRST int-emitente NO-LOCK
                 WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
            
            IF int-emitente.ind-participa-canais = 993520001  /* Participa canais */  THEN DO:

                FIND FIRST ponto-programa NO-LOCK
                    WHERE  ponto-programa.nome-programa = "ESPDP079":U
                    AND    ponto-programa.ponto         = 1 NO-ERROR.
                IF  AVAIL  ponto-programa THEN DO:
                    IF NOT CAN-FIND(FIRST conteudo-programa NO-LOCK
                                    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                                      AND conteudo-programa.conteudo     = c-seg-usuario) THEN DO:
                        CREATE tt-erro-local.
                        ASSIGN tt-erro-local.mensagem = tt-ped-venda-arq.linha + "Cliente " + STRING(tt-ped-venda-arq.cod-cliente) + " faz parte do programa de canais, n∆o pode utilizar este programa. Usuario sem premissao de inclusao neste programa."
                               l-erro           = YES.
                       NEXT blk_pedido.
                    END. /* IF NOT CAN-FIND(FIRST conteudo-programa NO-LOCK */
                END. /* IF  AVAIL  ponto-programa THEN DO: */

                RUN esp/esb/out/msg0100.p (INPUT  int-emitente.cod-guid,
                                           OUTPUT TABLE ProdutoItem,                    
                                           OUTPUT TABLE Resultado).
        

            END. /* IF int-emitente.ind-participa-canais = 993520001  /* Participa canais */  THEN DO: */
            IF l-log = YES THEN
                PUT "3" SKIP.

        IF NOT AVAIL emitente THEN DO:
           CREATE tt-erro-local.
           ASSIGN tt-erro-local.mensagem = tt-ped-venda-arq.linha + "Cliente " + STRING(tt-ped-venda-arq.cod-cliente) + " n∆o cadastrado."
                  l-erro           = YES.

           NEXT blk_pedido.
        END.

        /* Validar regras de vencimento conforme esacr079 */
        RUN esp/acr/esacrapi001.p (INPUT emitente.nome-abrev,
                                   INPUT tt-ped-venda-arq.cod-cond-pag,
                                   INPUT tt-ped-venda-arq.nat-operacao,
                                   OUTPUT l-regra-vencto-ok).
        IF  NOT l-regra-vencto-ok THEN DO:
            CREATE tt-erro-local.
            ASSIGN l-erro  =  YES.
                   tt-erro-local.mensagem = tt-ped-venda-arq.linha + "Cliente: " + string(tt-ped-venda-arq.cod-cliente) +
                                            "Condiá∆o de pagamento " + string(tt-ped-venda-arq.cod-cond-pag) +
                                            " n∆o Ç canais ou B2B nem possui regras de vencimento cadastradas no ESACR070".
                   
            NEXT blk_pedido.
        END.

        /*Buscar transportadora para ser utilizada caso
        o usu†rio n∆o informe uma transportadora na planilha.***************/
        FIND FIRST loc-entr NO-LOCK USE-INDEX ch-entrega
            WHERE  loc-entr.cod-entrega = "padrao"
            AND    loc-entr.nome-abrev  = IF tt-ped-venda-arq.nome-abrev-tri = "" THEN emitente.nome-abrev ELSE tt-ped-venda-arq.nome-abrev-tri NO-ERROR.
        IF  NOT AVAIL loc-entr THEN DO:
            CREATE tt-erro-local.
            ASSIGN tt-erro-local.mensagem = tt-ped-venda-arq.linha + "Local de entrega do cliente " + STRING(emitente.cod-emitente) + " n∆o cadastrado."
                   l-erro           = YES.

            NEXT blk_pedido.
        END. 
        IF tt-ped-venda-arq.nm-abrev-transp = "" THEN DO:

            IF tt-ped-venda-arq.nome-abrev-tri <> "" THEN 
                FIND b-emitente
                     WHERE b-emitente.nome-abrev = tt-ped-venda-arq.nome-abrev-tri NO-LOCK NO-ERROR.
            ELSE
                FIND b-emitente
                     WHERE b-emitente.nome-abrev = emitente.nome-abrev NO-LOCK NO-ERROR.
            RUN esp/crm/escrm107.p (INPUT tt-ped-venda-arq.cod-estabel,
                                    INPUT STRING(b-emitente.cod-emitente),
                                    INPUT loc-entr.cidade,
                                    INPUT loc-entr.estado,
                                    INPUT tt-ped-venda-arq.unid-comerc,
                                    INPUT loc-entr.cep,
                                    OUTPUT c-cod-transp,
                                    OUTPUT c-sigla-transp).
    
            FOR FIRST transporte 
                WHERE transporte.cod-transp = c-cod-transp NO-LOCK:
                    ASSIGN c-nome-transp = transporte.nome-abrev.
            END.

            IF NOT AVAIL transporte THEN DO:
               CREATE tt-erro-local.
               ASSIGN tt-erro-local.mensagem = tt-ped-venda-arq.linha + "Transportadora n∆o encontrada."
                      l-erro           = YES.

               NEXT blk_pedido.
            END.
            IF l-log = YES THEN
                PUT "4" SKIP.


        END.
        ELSE DO:
           FIND FIRST transporte 
                WHERE transporte.nome-abrev = tt-ped-venda-arq.nm-abrev-transp NO-LOCK NO-ERROR.
           IF NOT AVAIL transporte THEN DO:
               FIND FIRST transporte NO-LOCK
                    WHERE transporte.cod-transp = int(tt-ped-venda-arq.nm-abrev-transp) NO-ERROR.
               IF NOT AVAIL transporte THEN DO:
                  CREATE tt-erro-local.
                  ASSIGN tt-erro-local.mensagem = tt-ped-venda-arq.linha + "Nome abreviado de transportadora: "  + tt-ped-venda-arq.nm-abrev-transp + " est† incorreto ou n∆o cadastrado."
                         l-erro           = YES.
                 
                  NEXT blk_pedido.
               END.                
               ELSE
                   ASSIGN c-nome-transp = transporte.nome-abrev. //nome transp novo
           END.
           ELSE
               ASSIGN c-nome-transp = transporte.nome-abrev. //nome transp novo
        END.
        IF l-log = YES THEN
            PUT "5" SKIP.

        IF tt-ped-venda-arq.nome-tr-red <> "" THEN DO:
            FIND FIRST transporte NO-LOCK
                 WHERE transporte.nome-abrev = tt-ped-venda-arq.nome-tr-red NO-ERROR.

            IF NOT AVAIL transporte THEN DO:
                CREATE tt-erro-local.
                ASSIGN tt-erro-local.mensagem = tt-ped-venda-arq.linha + "Nome abreviado de transportadora de redespacho: "  + tt-ped-venda-arq.nome-tr-red + " est† incorreto ou n∆o cadastrado."
                       l-erro           = YES.
                       
                NEXT blk_pedido.
            END.
        END.

        /*******************************************************************/
        IF tt-ped-venda-arq.rota <> "" THEN DO:
            FIND FIRST rota NO-LOCK
                WHERE  rota.cod-rota = tt-ped-venda-arq.rota NO-ERROR.
            IF  NOT AVAIL rota THEN DO:
                CREATE tt-erro-local.
                ASSIGN tt-erro-local.mensagem = tt-ped-venda-arq.linha + "Rota " + STRING(tt-ped-venda-arq.rota) + " n∆o Encontrado."
                       l-erro                 = YES.

                NEXT blk_pedido.
            END.
        END.

        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p (INPUT "espdp079":U,
                           INPUT 2,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).

        IF  tt-ped-venda-arq.nat-operacao <> ""
        AND tt-ped-venda-arq.nat-operacao <> ? THEN DO:
        
            /*Chamado 102518, s¢ importa do arquivo as naturezas cadastradas no es0018*/
            IF  CAN-FIND (FIRST tt-prog-ponto
                          WHERE tt-prog-ponto.conteudo = tt-ped-venda-arq.nat-operacao
                             OR tt-ped-venda-arq.nat-operacao BEGINS "8"
                             OR (tt-ped-venda-arq.cod-estabel = "105" AND emitente.estado <> "RS")) THEN DO: // natureza locacao
                FIND FIRST natur-oper NO-LOCK
                     WHERE natur-oper.nat-operacao  = tt-ped-venda-arq.nat-operacao 
                       AND natur-oper.nat-operacao >= "500000" NO-ERROR.
           
                IF  AVAIL natur-oper THEN
                    ASSIGN c-nat-oper = tt-ped-venda-arq.nat-operacao.
                
            END.
            ELSE DO:
                RUN defineNatOperacao IN h-boes505 (INPUT  estabelec.cod-estabel,
                                                    INPUT  emitente.cod-emitente,
                                                    INPUT  "padrao",
                                                    INPUT  "",
                                                    INPUT  IF  tt-ped-venda-arq.destino = "Revenda" THEN NO ELSE YES,
                                                    OUTPUT c-nat-oper,
                                                    OUTPUT l-return).
        
                IF  NOT l-return THEN DO:
                    CREATE tt-erro-local.
                    ASSIGN tt-erro-local.mensagem = tt-ped-venda-arq.linha + "Natureza de operaá∆o n∆o encontrada para o cliente/estabelecimento " + STRING(emitente.cod-emitente) + " Estabelec " + estabelec.cod-estabel
                           l-erro           = YES.
        
                    NEXT blk_pedido.
                END.
            END.
        END.
        ELSE DO:
            RUN defineNatOperacao IN h-boes505 (INPUT  estabelec.cod-estabel,
                                                INPUT  emitente.cod-emitente,
                                                INPUT  "padrao",
                                                INPUT  "",
                                                INPUT  IF  tt-ped-venda-arq.destino = "Revenda" THEN NO ELSE YES,
                                                OUTPUT c-nat-oper,
                                                OUTPUT l-return).
            IF  NOT l-return THEN DO:
                CREATE tt-erro-local.
                ASSIGN tt-erro-local.mensagem = tt-ped-venda-arq.linha + "Natureza de operaá∆o n∆o encontrada para o cliente/estabelecimento " + STRING(emitente.cod-emitente) + " Estabelec " + estabelec.cod-estabel
                       l-erro           = YES.
        
                NEXT blk_pedido.
            END.
        
        END.
        
        IF l-log = YES THEN
            PUT "6" SKIP.

        FIND FIRST natur-oper NO-LOCK
            WHERE  natur-oper.nat-operacao = c-nat-oper NO-ERROR.
        IF  NOT AVAIL natur-oper THEN DO:

            CREATE tt-erro-local.
            ASSIGN tt-erro-local.mensagem = tt-ped-venda-arq.linha + "Natureza de Operaá∆o " + emitente.nat-operacao + " inv†lida no cadastro do Cliente " + STRING(emitente.cod-emitente)
                   l-erro           = YES.

            NEXT blk_pedido.
        END.

        if  tt-ped-venda-arq.nome-abrev-tri = "" and
            natur-oper.log-oper-triang THEN DO:
            CREATE tt-erro-local.
            ASSIGN tt-erro-local.mensagem = tt-ped-venda-arq.linha + 'Natureza Ç de operacao Triangular, sem cliente de operaá∆o Triangular informado: Cliente: ' + emitente.nome-abrev + 
                               ' Natureza de Operaªío: ' + natur-oper.nat-operacao +
                               ' Cliente Operacao Triangular ' + tt-ped-venda-arq.nome-abrev-tri.
            NEXT blk_pedido.

        END.

        if  tt-ped-venda-arq.nome-abrev-tri <> "":U then do:
            if  not natur-oper.log-oper-triang THEN DO:
                 CREATE tt-erro-local.
                 ASSIGN tt-erro-local.mensagem = tt-ped-venda-arq.linha + 'Natureza n∆o Ç de operacao Triangular, com cliente de operaá∆o Triangular informado: Cliente: ' + emitente.nome-abrev + 
                                              ' Natureza de Operaªío: ' + natur-oper.nat-operacao +
                                              ' Cliente Operacao Triangular ' + tt-ped-venda-arq.nome-abrev-tri.
                  NEXT blk_pedido.
            END.
        END.

        IF l-log = YES THEN
            PUT "7" SKIP.


        FIND FIRST int-emitente NO-LOCK
            WHERE  int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
        IF  AVAIL  int-emitente           AND
            int-emitente.id-ativo   = NO  AND
            natur-oper.emite-duplic = YES THEN DO:
            CREATE tt-erro-local.
            ASSIGN tt-erro-local.mensagem = tt-ped-venda-arq.linha + "Cliente n∆o esta ativo, n∆o Ç possivel integrar pedidos. Cliente " + STRING(emitente.cod-emitente) + " - " + emitente.nome-emit
                   l-erro           = YES.

           NEXT blk_pedido.
        END.
        
        EMPTY TEMP-TABLE tt-prog-ponto2.
        RUN esp/es0018p.p (INPUT "espdp079":U,
                           INPUT 7,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto2).

        FIND FIRST tt-prog-ponto2
             WHERE tt-prog-ponto2.conteudo = emitente.nome-matriz NO-LOCK NO-ERROR.

        CREATE tt-ped-venda.
        ASSIGN tt-ped-venda.nr-pedido  = NEXT-VALUE(seq-nr-pedido)
               tt-ped-venda.nome-abrev = emitente.nome-abrev
               i-sequencia             = 0.

        /*Se o numero da proposta estiver vazio na planilha faz o tratamento abaixo.*/
        IF tt-ped-venda-arq.l-proposta-vazio = YES THEN DO:
           FOR EACH tt-ped-item-arq
               WHERE tt-ped-item-arq.nr-proposta = tt-ped-venda-arq.nr-proposta EXCLUSIVE-LOCK:
                   ASSIGN tt-ped-item-arq.nr-proposta  = string(tt-ped-venda.nr-pedido).
           END.
           ASSIGN tt-ped-venda-arq.nr-proposta = string(tt-ped-venda.nr-pedido).
        END.
        
        ASSIGN tt-ped-venda.nr-pedcli = tt-ped-venda-arq.nr-proposta.
        
        ASSIGN c-lista-pedidos = c-lista-pedidos + string(tt-ped-venda.nr-pedido) + ", ".

        ASSIGN tt-ped-venda.cod-estabel             = estabelec.cod-estabel
               tt-ped-venda.dt-emissao              = TODAY
               tt-ped-venda.no-ab-reppri            = repres.nome-abrev 
               tt-ped-venda.dt-implant              = TODAY
               tt-ped-venda.cod-emitente            = emitente.cod-emitente
               tt-ped-venda.nat-operacao            = natur-oper.nat-operacao
               tt-ped-venda.tp-pedido               = tt-ped-venda-arq.atendente
               tt-ped-venda.cod-mensagem            = natur-oper.cod-mensagem
               tt-ped-venda.cod-cond-pag            = IF string(tt-ped-venda-arq.cod-cond-pag) <> "" THEN integer(tt-ped-venda-arq.cod-cond-pag) ELSE cond-pagto.cod-cond-pag
               tt-ped-venda.nr-tab-fin              = cond-pagto.nr-tab-finan
               tt-ped-venda.nr-ind-finan            = cond-pagto.nr-ind-finan
               tt-ped-venda.e-mail                  = emitente.e-mail
               tt-ped-venda.cod-sit-aval            = 1 /* Credito N∆o Avaliado */
               tt-ped-venda.mo-codigo               = 0 /* Real */
               tt-ped-venda.cod-gr-cli              = emitente.cod-gr-cli
               tt-ped-venda.tp-faturam              = 1
               tt-ped-venda.origem                  = 6
               tt-ped-venda.atendido                = NO
               tt-ped-venda.cd-origem               = 2
               tt-ped-venda.user-impl               = "adm"
               tt-ped-venda.dt-userimp              = TODAY
               tt-ped-venda.tip-cob-desp            = para-fat.tip-cob-desp
               tt-ped-venda.esp-ped                 = 1
               tt-ped-venda.cod-rota                = loc-entr.cod-rota
               //tt-ped-venda.cod-canal-venda         = IF natur-oper.cod-canal-venda <> 0 THEN natur-oper.cod-canal-venda ELSE emitente.cod-canal-venda
               tt-ped-venda.ind-ent-completa        = YES
               tt-ped-venda.dsp-pre-fat             = YES
               tt-ped-venda.log-usa-tabela-desconto = NO
               tt-ped-venda.cod-des-merc            = 1
               tt-ped-venda.ind-lib-nota            = para-ped.ind-lib-nota WHEN AVAIL para-ped
               tt-ped-venda.dt-entrega              = tt-ped-venda-arq.dt-entrega
               tt-ped-venda.dt-entorig              = tt-ped-venda-arq.dt-entrega
               tt-ped-venda.nome-transp             = c-nome-transp //IF tt-ped-venda-arq.nm-abrev-transp <> "" THEN tt-ped-venda-arq.nm-abrev-transp ELSE c-nome-transp
               tt-ped-venda.observacoes             = tt-ped-venda-arq.obs-pedido
               tt-ped-venda.cond-espec              = tt-ped-venda-arq.obs-nota
               tt-ped-venda.nome-abrev-tri          = tt-ped-venda-arq.nome-abrev-tri
               tt-ped-venda.nome-tr-red             = tt-ped-venda-arq.nome-tr-red
               OVERLAY(tt-ped-venda.char-2,109,8)   = "0"
               tt-ped-venda.des-pct-desconto-inform = tt-ped-venda-arq.pc-desc-pedido
               tt-ped-venda.cond-redespa            = tt-ped-venda-arq.cod-projeto
               tt-ped-venda.ind-fat-par             = IF AVAIL tt-prog-ponto2 THEN NO ELSE YES.

       IF tt-ped-venda-arq.cod-canal-venda <> "" THEN
           ASSIGN tt-ped-venda.cod-canal-venda = int(tt-ped-venda-arq.cod-canal-venda).
       ELSE
           ASSIGN tt-ped-venda.cod-canal-venda = IF natur-oper.cod-canal-venda <> 0 THEN natur-oper.cod-canal-venda ELSE emitente.cod-canal-venda.

       IF tt-ped-venda-arq.rota <> "" THEN
          ASSIGN tt-ped-venda.cod-rota = tt-ped-venda-arq.rota.

       IF tt-ped-venda-arq.cod-priori = "" THEN
           IF tt-ped-venda.tp-pedido = "74" THEN
              ASSIGN tt-ped-venda.cod-priori            = 44.
           ELSE
              ASSIGN tt-ped-venda.cod-priori            = 01.
        ELSE
            ASSIGN tt-ped-venda.cod-priori              = int(tt-ped-venda-arq.cod-priori).

        IF  tt-ped-venda-arq.destino = "Revenda" THEN
            ASSIGN tt-ped-venda.cod-des-merc = 1.
        ELSE
            ASSIGN tt-ped-venda.cod-des-merc = 2.

            IF l-log = YES THEN
                PUT "8" SKIP
                "troca nf " tt-ped-venda-arq.l-troca-nota SKIP.

        //????
        CREATE tt-int-ped-venda.
        ASSIGN tt-int-ped-venda.cod-estabel             = tt-ped-venda.cod-estabel 
               tt-int-ped-venda.nr-pedido               = tt-ped-venda.nr-pedido
               tt-int-ped-venda.nr-contrato             = IF tt-param.l-contrato = YES THEN tt-ped-venda-arq.nr-contrato ELSE "" 
               OVERLAY(tt-int-ped-venda.char-1,1,8)     = STRING(TIME,"HH:MM:SS")
               OVERLAY(tt-int-ped-venda.char-1, 16, 3)  = tt-ped-venda-arq.unid-comerc
               OVERLAY(tt-int-ped-venda.char-1, 53, 12) = tt-ped-venda-arq.po-cliente
               OVERLAY(tt-int-ped-venda.char-1, 11, 1)  = IF tt-ped-venda-arq.l-troca-nota = "Sim" THEN "S" ELSE "N"
               OVERLAY(tt-int-ped-venda.char-1,80,12)   = IF tt-param.l-contrato = YES THEN tt-ped-venda-arq.nr-contrato ELSE "" .
        //Valida se as parcelas informadas para receita recorrente j† existem em algum pedido 
        
        //BHJ 04/09/2023
        IF tt-param.l-receita-recorrente THEN DO:

            RUN pi-valida-receita-recorrente(INPUT tt-ped-venda-arq.nr-contrato, 
                                             INPUT-OUTPUT tt-ped-venda-arq.receita-rec-parcela-ini,
                                             INPUT l-incrementa-parcela ). 

            IF RETURN-VALUE = "NOK":U THEN DO:
                
                CREATE tt-erro-local.
                ASSIGN tt-erro-local.mensagem = "Numero de parcela informado j† existente para o contrato referenciado ou numero do contrato em branco".
                       l-erro           = YES.
                
                NEXT blk_pedido.
            END.
        END.
       

        /* chamado Nß 80317 foi incluso a transportadora de redespacho no layout
        IF  emitente.nome-tr-red <> "" THEN DO:
            FIND FIRST transporte NO-LOCK
                WHERE  transporte.nome-abrev = emitente.nome-tr-red NO-ERROR.
            IF  NOT AVAIL transporte THEN DO:
                CREATE tt-erro-local.
                ASSIGN tt-erro-local.mensagem = "Transportador Redespacho " + emitente.nome-tr-red + " do cliente " + STRING(emitente.cod-emitente) + " n∆o cadastrado."
                       l-erro           = YES.

                RUN pi-destroi-handles.
                RETURN "NOK":U.
            END.
            ELSE
                ASSIGN tt-ped-venda.nome-tr-red = emitente.nome-tr-red.
        END.*/

        IF  AVAIL loc-entr THEN
            ASSIGN tt-ped-venda.local-entreg = loc-entr.endereco
                   tt-ped-venda.bairro       = loc-entr.bairro
                   tt-ped-venda.cidade       = loc-entr.cidade
                   tt-ped-venda.pais         = loc-entr.pais
                   tt-ped-venda.estado       = loc-entr.estado
                   tt-ped-venda.cep          = loc-entr.cep
                   tt-ped-venda.caixa-postal = loc-entr.caixa-postal
                   tt-ped-venda.cgc          = loc-entr.cgc
                   tt-ped-venda.ins-estadual = loc-entr.ins-estadual
                   tt-ped-venda.cod-entrega  = loc-entr.cod-entrega
                   tt-ped-venda.cidade-cif   = loc-entr.nom-cidad-cif.
        ELSE DO:
            IF  AVAIL emitente THEN
                ASSIGN tt-ped-venda.local-entreg = emitente.endereco
                       tt-ped-venda.bairro       = emitente.bairro
                       tt-ped-venda.cidade       = emitente.cidade
                       tt-ped-venda.pais         = emitente.pais
                       tt-ped-venda.estado       = emitente.estado
                       tt-ped-venda.cep          = emitente.cep
                       tt-ped-venda.caixa-postal = emitente.caixa-postal
                       tt-ped-venda.cgc          = emitente.cgc
                       tt-ped-venda.ins-estadual = emitente.ins-estadual
                       tt-ped-venda.cidade-cif   = emitente.cidade.
        END.

        
        /* Atribuir Portador conforme o cadastro do cliente */
        IF  emitente.portador <> 0 THEN DO:
            ASSIGN tt-ped-venda.cod-portador = emitente.portador
                   tt-ped-venda.modalidade   = emitente.modalidade.

            FIND FIRST mgcad.portador NO-LOCK
                 WHERE portador.cod-portador = tt-ped-venda.cod-portador NO-ERROR.
            IF AVAIL portador AND portador.mo-codigo <> 0 THEN
                ASSIGN tt-ped-venda.mo-codigo = portador.mo-codigo.
        END.
        ELSE
            ASSIGN tt-ped-venda.cod-portador = 999
                   tt-ped-venda.modalidade   = 6.

        CREATE tt-ped-repre.
        ASSIGN tt-ped-repre.nr-pedido   = tt-ped-venda.nr-pedido
               tt-ped-repre.ind-repbase = YES
               tt-ped-repre.perc-comis  = 0 /* O % de comiss∆o Ç calculado por relat¢rio */
               tt-ped-repre.nome-ab-rep = repres.nome-abrev.

        IF l-log = YES THEN
            PUT "9" SKIP.

        /*************** ITENS DO PEDIDO   ****************** */
        /**BHJ*/
        IF tt-param.l-receita-recorrente = NO THEN DO:
            FOR EACH tt-ped-item-arq
                WHERE tt-ped-item-arq.nr-proposta = tt-ped-venda-arq.nr-proposta:
                RUN pi-acompanhar IN h-acomp (INPUT "Gerando itens: " + tt-ped-item-arq.it-codigo).
    
                /*IF l-log = YES THEN
                   PUT "4 " tt-ped-venda.nr-pedcli tt-ped-venda-arq.nr-proposta " " tt-ped-item-arq.nr-proposta SKIP.*/
    
                FIND FIRST item NO-LOCK
                    WHERE  item.it-codigo = tt-ped-item-arq.it-codigo NO-ERROR.
    
                FIND FIRST tt-ped-item NO-LOCK
                    WHERE  tt-ped-item.nr-pedcli  = tt-ped-venda.nr-pedcli
                    AND    tt-ped-item.nome-abrev = tt-ped-venda.nome-abrev
                    AND    tt-ped-item.it-codigo  = tt-ped-item-arq.it-codigo NO-ERROR.
                IF  AVAIL  tt-ped-item THEN DO:
    
                    ASSIGN de-vl-pre-liq-filho       = ROUND((tt-ped-item-arq.preco * tt-ped-item-arq.qtd) + (tt-ped-item.vl-preori * tt-ped-item.qt-pedida),2)
                           tt-ped-item.vl-preori     = ROUND(de-vl-pre-liq-filho / (tt-ped-item.qt-pedida + tt-ped-item-arq.qtd),2)
                           tt-ped-item.vl-pretab     = tt-ped-item.vl-preori 
                           tt-ped-item-arq.preco     = tt-ped-item.vl-preori
                           tt-ped-item.qt-pedida     = tt-ped-item.qt-pedida + tt-ped-item-arq.qtd
                           tt-ped-item.qt-un-fat     = tt-ped-item.qt-pedida
                           OVERLAY(tt-ped-item.char-2,56,5) = string(ITEM.cod-servico).
                    
                END.
                ELSE
                    RUN CriaItem.
    
            END.
        END.
        ELSE DO:

            DEFINE VAR iCont      AS INT .
            DEFINE VAR iParcela   AS INT INIT 1 FORMAT 999.
            DEFINE VAR dt-entrega AS DATE.

            ASSIGN dt-entrega = tt-ped-venda-arq.receita-rec-data-vcto-parecela .
            ASSIGN iParcela = tt-ped-venda-arq.receita-rec-parcela-ini.
            
            DO WHILE iCont <> tt-ped-venda-arq.receita-rec-nr-parcelas:
                FOR EACH tt-ped-item-arq
                    WHERE tt-ped-item-arq.nr-proposta = tt-ped-venda-arq.nr-proposta:
                    
                    RUN pi-acompanhar IN h-acomp (INPUT "Gerando itens: " + tt-ped-item-arq.it-codigo).
    
                    FIND FIRST item NO-LOCK
                        WHERE  item.it-codigo = tt-ped-item-arq.it-codigo NO-ERROR.
    
                    RUN CriaItemReceitaRecorrente(INPUT iCont,
                                                  INPUT iParcela,
                                                  INPUT dt-entrega).
                         
                END.
                ASSIGN iCont = iCont + 1 .
                ASSIGN iParcela = iParcela + 1 . 
                ASSIGN dt-entrega = dt-entrega + 30.

            END.
        END.
            /*********************/
                /*
                ASSIGN iCont = 0.
                ASSIGN dt-entrega = tt-ped-venda-arq.receita-rec-data-vcto-parecela .
                ASSIGN iParcela = tt-ped-venda-arq.receita-rec-parcela-ini.  */
           
        IF l-log = YES THEN
            PUT "10" SKIP.
        
        /* Caso encontre algum erro, retorna os erros */
        IF  l-erro THEN DO:
            NEXT blk_pedido.
        END.
    
        RELEASE tt-ped-item.
    
        /* Tratativa NFServico */
        FIND FIRST natur-oper
            WHERE natur-oper.nat-operacao = tt-ped-venda.nat-operacao NO-LOCK NO-ERROR.
        IF AVAIL natur-oper AND natur-oper.tipo = 3 THEN DO: /* NF Servicos*/

            FOR EACH tt-ped-item-arq
                WHERE tt-ped-item-arq.nr-proposta = tt-ped-venda-arq.nr-proposta:

                FIND FIRST tt-ped-item NO-LOCK
                    WHERE  tt-ped-item.nr-pedcli  = tt-ped-venda.nr-pedcli
                    AND    tt-ped-item.nome-abrev = tt-ped-venda.nome-abrev
                    AND    tt-ped-item.it-codigo  = tt-ped-item-arq.it-codigo NO-ERROR.
                IF  AVAIL  tt-ped-item THEN DO:

                    FIND FIRST int-ped-item-adic
                        WHERE int-ped-item-adic.nome-abrev         = tt-ped-item.nome-abrev   
                          AND int-ped-item-adic.nr-pedcli          = tt-ped-item.nr-pedcli    
                          AND int-ped-item-adic.nr-sequencia       = tt-ped-item.nr-sequencia 
                          AND int-ped-item-adic.it-codigo          = tt-ped-item.it-codigo    
                          AND int-ped-item-adic.cod-refer          = tt-ped-item.cod-refer    
                          AND int-ped-item-adic.pedido-servico     = tt-ped-venda-arq.pedido-servico
                          AND int-ped-item-adic.item-servico       = tt-ped-venda-arq.item-servico  
                          AND int-ped-item-adic.folha-registro     = tt-ped-venda-arq.folha-registro  NO-LOCK NO-ERROR.
                    IF AVAIL int-ped-item-adic THEN DO:       
                        CREATE tt-erro-local.
                        ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "Dados da NF Servico j† usados no pedido TOTVS " + tt-ped-item.nr-pedcli.
                               l-erro           = YES.
                        NEXT blk_pedido.
                    END. /* IF AVAIL int-ped-item-adic THEN DO: */

                END. /* IF  AVAIL  tt-ped-item THEN DO: */

            END. /* FOR EACH tt-ped-item-arq */

        END. /* IF AVAIL natur-oper AND natur-oper.tipo = 3 THEN DO: /* NF Servicos*/ */

        FOR EACH tt-ped-venda NO-LOCK:
            /*IF l-log = YES THEN
                PUT "7 "  tt-ped-venda.nr-pedcli SKIP.*/
            FIND FIRST tt-ped-item NO-LOCK
                WHERE  tt-ped-item.nr-pedcli = tt-ped-venda.nr-pedcli NO-ERROR.
            IF  NOT AVAIL tt-ped-item THEN DO:
                FOR EACH  tt-ped-repre NO-LOCK
                    WHERE tt-ped-repre.nr-pedido   = tt-ped-venda.nr-pedido:
                    DELETE tt-ped-repre.
                END.
    
                CREATE tt-erro-local.
                ASSIGN tt-erro-local.mensagem = tt-ped-venda-arq.linha + "Pedido sem itens favor reavaliar o pedido."
                       l-erro           = YES.
    
                NEXT blk_pedido.
            END.
    
            FOR EACH tt-ped-item 
                WHERE tt-ped-item.nr-pedcli = tt-ped-venda.nr-pedcli,
                FIRST item NO-LOCK
                WHERE item.it-codigo = tt-ped-item.it-codigo:
    
                IF l-log = YES THEN
                    PUT "11 " tt-ped-item.it-codigo SKIP.
    
                FIND FIRST item-uni-estab NO-LOCK
                    WHERE  item-uni-estab.cod-estabel = tt-ped-venda.cod-estabel
                      AND  item-uni-estab.it-codigo   = tt-ped-item.it-codigo NO-ERROR.
                IF  AVAIL  item-uni-estab THEN
                    ASSIGN tt-ped-item.cod-unid-negoc = item-uni-estab.cod-unid-negoc.
                ELSE
                    ASSIGN tt-ped-item.cod-unid-negoc = ITEM.cod-unid-negoc.
    
                /* conta aplicacao */
                if  item.tipo-contr = 4 and SUBSTR(tt-ped-item.char-2,09,02) = "  " then
                    assign substr(tt-ped-item.char-2,09,02) = item.un.
            
                if  item.tipo-contr <> 4 then
                    assign substr(tt-ped-item.char-2,09,02) = "  ":U.
            
                FOR FIRST natur-oper
                    WHERE natur-oper.nat-operacao = tt-ped-item.nat-operacao NO-LOCK USE-INDEX natureza:
                END.
            
                if  ((item.tipo-contr = 4 or (item.aliquota-iss > 0 and item.tipo-contr <> 2)) and
                     (item.baixa-estoq and natur-oper.baixa-estoq)) 
                   or
                    ((item.tipo-contr = 1 or item.tipo-contr = 4) and
                     (natur-oper.terceiros or natur-oper.transf)) 
            
                   or
                     (item.tipo-contr = 2 or item.tipo-contr = 3) and
                      natur-oper.terceiros and
                     (not item.baixa-estoq or not natur-oper.baixa-estoq) then do:
            
                     if item.ct-codigo = "":U then do:
                        find first para-fat no-lock NO-ERROR .
                        assign tt-ped-item.ct-codigo = para-fat.ct-cuscon.
                     end.   
                     else 
                        assign tt-ped-item.ct-codigo = item.ct-codigo.
            
                end. 
                else 
                     assign tt-ped-item.ct-codigo = "".
             /* Fim Conta Aplicacao */
    
    
                FIND FIRST cliente-astec NO-LOCK
                    WHERE  cliente-astec.cod-emitente   = tt-ped-venda.cod-emitente
                      AND  cliente-astec.cod_unid_negoc = item.cod-unid-negoc NO-ERROR.
                IF  AVAIL  cliente-astec THEN DO:
                    IF  cliente-astec.ind-assistencia THEN DO:
                        FIND FIRST ponto-programa NO-LOCK
                            WHERE  ponto-programa.nome-programa = "ES0573":U
                            AND    ponto-programa.ponto         = 3 NO-ERROR.
                        IF  AVAIL  ponto-programa THEN DO:
                            FIND FIRST conteudo-programa NO-LOCK
                                WHERE  conteudo-programa.cod-programa = ponto-programa.cod-programa
                                AND    conteudo-programa.sequencia    = 1 NO-ERROR.
                            IF  AVAIL  conteudo-programa THEN DO:
                                IF  INDEX(tt-ped-venda.observacoes,TRIM(conteudo-programa.conteudo)) = 0  THEN DO:
                                    ASSIGN tt-ped-venda.observacoes = TRIM(tt-ped-venda.observacoes) + " " + TRIM(conteudo-programa.conteudo).
                                END.
                            END.
                        END.
                    END.
    
                    IF  cliente-astec.ind-suporte THEN DO:
                        FIND FIRST ponto-programa NO-LOCK
                            WHERE  ponto-programa.nome-programa = "ES0573":U
                            AND    ponto-programa.ponto         = 3 NO-ERROR.
                        IF  AVAIL  ponto-programa THEN DO:
                            FIND FIRST conteudo-programa NO-LOCK
                                WHERE  conteudo-programa.cod-programa = ponto-programa.cod-programa
                                AND    conteudo-programa.sequencia    = 2 NO-ERROR.
                            IF  AVAIL  conteudo-programa THEN DO:
                                IF  INDEX(tt-ped-venda.observacoes,TRIM(conteudo-programa.conteudo)) = 0  THEN DO:
                                    ASSIGN tt-ped-venda.observacoes = TRIM(tt-ped-venda.observacoes) + " " + TRIM(conteudo-programa.conteudo).
                                END.
                            END.
                        END.
                    END.
                END.
    
    
                FIND FIRST classif-fisc NO-LOCK
                    WHERE  classif-fisc.class-fiscal = item.class-fisc NO-ERROR.
                IF  NOT AVAIL classif-fisc OR item.class-fisc = "" THEN DO:
                    CREATE tt-erro-local.
                    ASSIGN tt-erro-local.mensagem = tt-ped-venda-arq.linha + "Item " + tt-ped-item.it-codigo + " sem classificaá∆o fiscal cadastrada."
                           l-erro           = YES.
    
                    NEXT blk_pedido.
                END.
                
                ASSIGN c-nat-oper = tt-ped-item.nat-operacao.
            END.
    
            ASSIGN tt-ped-venda.vl-tot-ped = d-vl-liq-abe
                   tt-ped-venda.vl-liq-abe = d-vl-liq-abe
                   tt-ped-venda.vl-mer-abe = d-vl-liq-it
                   tt-ped-venda.vl-liq-ped = d-vl-liq-it.

            IF l-log = YES THEN
                PUT "12" SKIP
                tt-ped-venda.vl-tot-ped SKIP
                tt-ped-venda.vl-liq-abe SKIP
                tt-ped-venda.vl-mer-abe SKIP
                tt-ped-venda.vl-liq-ped SKIP.
            
            /* Regra Nova */
            IF (emitente.estado = "AL"  OR
                emitente.estado = "AM"  OR
                emitente.estado = "AP"  OR
                emitente.estado = "BA"  OR
                emitente.estado = "CE"  OR
                emitente.estado = "PE"  OR
                emitente.estado = "SE"  OR
                emitente.estado = "PI"  OR
                emitente.estado = "MA"  OR
                emitente.estado = "RN"  OR
                emitente.estado = "PB"  OR
                emitente.estado = "RR"  OR
                emitente.estado = "PA") THEN DO:
                IF  emitente.cod-gr-cli = 24 THEN DO:
                    IF tt-ped-venda.vl-tot-ped > 7000 THEN
                        ASSIGN tt-ped-venda.cidade-cif = tt-ped-venda.cidade.
                    ELSE
                        ASSIGN tt-ped-venda.cidade-cif = "".
                END.
                ELSE DO:
                    IF (emitente.cod-gr-cli = 22  OR
                        emitente.cod-gr-cli = 23  OR
                        emitente.cod-gr-cli = 26  OR
                        emitente.cod-gr-cli = 34  OR
                        emitente.cod-gr-cli = 36  OR
                        emitente.cod-gr-cli = 37  OR
                        emitente.cod-gr-cli = 38) THEN DO:
    
                        IF  tt-ped-venda.vl-tot-ped > 3000 THEN
                            ASSIGN tt-ped-venda.cidade-cif = tt-ped-venda.cidade.
                        ELSE
                            ASSIGN tt-ped-venda.cidade-cif = "".
                    END.
                END.
            END.
            ELSE DO:
                /* Regra antiga */
                IF  emitente.cod-gr-cli = 24 THEN DO:
                    IF tt-ped-venda.vl-tot-ped > 10000 THEN
                        ASSIGN tt-ped-venda.cidade-cif = tt-ped-venda.cidade.
                    ELSE
                        ASSIGN tt-ped-venda.cidade-cif = "".
                END.
                ELSE DO:
                    IF (emitente.cod-gr-cli = 22  OR
                        emitente.cod-gr-cli = 23  OR
                        emitente.cod-gr-cli = 26  OR
                        emitente.cod-gr-cli = 34  OR
                        emitente.cod-gr-cli = 36  OR
                        emitente.cod-gr-cli = 37  OR
                        emitente.cod-gr-cli = 38) THEN DO:
                        IF  tt-ped-venda.vl-tot-ped > 3000 THEN
                            ASSIGN tt-ped-venda.cidade-cif = tt-ped-venda.cidade.
                        ELSE
                            ASSIGN tt-ped-venda.cidade-cif = "".
                    END.
                END.
            END.
            /*
            IF  tt-ped-venda.observacoes <> "" THEN
                //IDBA BRUNO - REVISAR
                ASSIGN c-desc-suspend = c-desc-suspend + tt-ped-venda.observacoes.
    
            IF  tt-ped-venda.cond-espec <> "" THEN
                ASSIGN c-desc-suspend = c-desc-suspend + tt-ped-venda.cond-espec. */
    
            /* Se tiver data ou dias de negociaá∆o, o pedido dever† ser Suspenso */
            FIND FIRST tt-int-ped-venda NO-LOCK
                WHERE  tt-int-ped-venda.nr-pedido   = tt-ped-venda.nr-pedido NO-ERROR.
            IF  AVAIL  tt-int-ped-venda THEN DO:
                IF  tt-int-ped-venda.dt-negociacao   <> ? THEN
                    ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " - Data Base: " + STRING(tt-int-ped-venda.dt-negociacao).
                           //c-desc-suspend           = c-desc-suspend + " - Data Base: " + STRING(tt-int-ped-venda.dt-negociacao).
    
                IF  tt-int-ped-venda.dias-negociacao <> 0 THEN
                    ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " - Dias de Negociaá∆o: " + STRING(tt-int-ped-venda.dias-negociacao).
                           //c-desc-suspend           = c-desc-suspend + " - Dias de Negociaá∆o: " + STRING(tt-int-ped-venda.dias-negociacao).
            END.

            FIND FIRST natur-oper
                WHERE natur-oper.nat-operacao = tt-ped-venda.nat-operacao NO-LOCK NO-ERROR.
            IF AVAIL natur-oper AND natur-oper.tipo = 3 THEN DO: /* NF Servicos*/

                FOR EACH tt-ped-item-arq
                    WHERE tt-ped-item-arq.nr-proposta = tt-ped-venda-arq.nr-proposta:
    
                    FIND FIRST tt-ped-item NO-LOCK
                        WHERE  tt-ped-item.nr-pedcli  = tt-ped-venda.nr-pedcli
                        AND    tt-ped-item.nome-abrev = tt-ped-venda.nome-abrev
                        AND    tt-ped-item.it-codigo  = tt-ped-item-arq.it-codigo NO-ERROR.
                    IF  AVAIL  tt-ped-item THEN DO:

                        IF tt-ped-venda-arq.pedido-servico   <> "" THEN ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " - REFERENTE PEDIDO "                    + tt-ped-venda-arq.pedido-servico  . 
                        IF tt-ped-venda-arq.item-servico     <> "" THEN ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " ITEM "                                  + tt-ped-venda-arq.item-servico    . 
                        IF tt-ped-venda-arq.folha-registro   <> "" THEN ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " FOLHA DE REGISTRO "                     + tt-ped-venda-arq.folha-registro  . 
                        IF tt-ped-venda-arq.tp-servico       <> "" THEN ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " TIPO SERVICO "                          + tt-ped-venda-arq.tp-servico      . 
                        IF tt-ped-venda-arq.cidade-servico   <> "" THEN ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " MUNICIPIO/LOCAL PRESTACAO DE SERVICO: " + tt-ped-venda-arq.cidade-servico  . 
                        IF tt-ped-venda-arq.uf-servico       <> "" THEN ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " ESTADO PRESTACAO SERVICO: "             + tt-ped-venda-arq.uf-servico      . 
                        IF tt-ped-venda-arq.pais-servico     <> "" THEN ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " PAIS PRESTACAO SERVICO:"                + tt-ped-venda-arq.pais-servico    . 
                        IF tt-ped-venda-arq.mes-competencia  <> "" THEN ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " MES DE COMPETENCIA "                    + tt-ped-venda-arq.mes-competencia . 
                        IF tt-ped-venda-arq.circuito-cliente <> "" THEN ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " CIRCUITO: "                             + tt-ped-venda-arq.circuito-cliente. 
                        IF tt-ped-venda-arq.nome-cliente     <> "" THEN ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " CLIENTE: "                              + tt-ped-venda-arq.nome-cliente    . 
                        IF tt-ped-venda-arq.email-gestor     <> "" THEN ASSIGN tt-ped-venda.observacoes = tt-ped-venda.observacoes + " GESTOR: "                               + tt-ped-venda-arq.email-gestor    .

                        /*ASSIGN tt-ped-venda.observacoes   = tt-ped-venda.observacoes + " - REFERENTE PEDIDO " + tt-ped-venda-arq.pedido-servico  +
                                                          " ITEM "                                      + tt-ped-venda-arq.item-servico          +
                                                          " FOLHA DE REGISTRO "                         + tt-ped-venda-arq.folha-registro        + 
                                                          " TIPO SERVICO "                              + tt-ped-venda-arq.tp-servico            + 
                                                          " MUNICIPIO/LOCAL PRESTACAO DE SERVICO: "     + tt-ped-venda-arq.cidade-servico        + 
                                                          " ESTADO PRESTACAO SERVICO: "                 + tt-ped-venda-arq.uf-servico            + 
                                                          " PAIS PRESTACAO SERVICO:"                    + tt-ped-venda-arq.pais-servico          + 
                                                          " MES DE COMPETENCIA "                        + tt-ped-venda-arq.mes-competencia       +
                                                          " CIRCUITO: "                                 + tt-ped-venda-arq.circuito-cliente      +
                                                          " CLIENTE: "                                  + tt-ped-venda-arq.nome-cliente          +
                                                          " GESTOR: "                                   + tt-ped-venda-arq.email-gestor */

                        ASSIGN tt-ped-venda.cond-espec    = tt-ped-venda.observacoes.
    
                        FIND FIRST int-ped-item-adic
                            WHERE int-ped-item-adic.nome-abrev         = tt-ped-item.nome-abrev   
                              AND int-ped-item-adic.nr-pedcli          = tt-ped-item.nr-pedcli    
                              AND int-ped-item-adic.nr-sequencia       = tt-ped-item.nr-sequencia 
                              AND int-ped-item-adic.it-codigo          = tt-ped-item.it-codigo    
                              AND int-ped-item-adic.cod-refer          = tt-ped-item.cod-refer    
                              AND int-ped-item-adic.pedido-servico     = tt-ped-venda-arq.pedido-servico
                              AND int-ped-item-adic.item-servico       = tt-ped-venda-arq.item-servico  
                              AND int-ped-item-adic.folha-registro     = tt-ped-venda-arq.folha-registro  NO-LOCK NO-ERROR.
                        IF NOT AVAIL int-ped-item-adic THEN DO:       
                            CREATE int-ped-item-adic.
                            ASSIGN int-ped-item-adic.nome-abrev        = tt-ped-item.nome-abrev  
                                   int-ped-item-adic.nr-pedcli         = tt-ped-item.nr-pedcli   
                                   int-ped-item-adic.nr-sequencia      = tt-ped-item.nr-sequencia
                                   int-ped-item-adic.it-codigo         = tt-ped-item.it-codigo   
                                   int-ped-item-adic.cod-refer         = tt-ped-item.cod-refer   
    
                                   int-ped-item-adic.pedido-servico    = tt-ped-venda-arq.pedido-servico
                                   int-ped-item-adic.item-servico      = tt-ped-venda-arq.item-servico     
                                   int-ped-item-adic.folha-registro    = tt-ped-venda-arq.folha-registro   
                                   int-ped-item-adic.tp-servico        = tt-ped-venda-arq.tp-servico       
                                   int-ped-item-adic.cidade-servico    = tt-ped-venda-arq.cidade-servico   
                                   int-ped-item-adic.uf-servico        = tt-ped-venda-arq.uf-servico   
                                   int-ped-item-adic.pais-servico      = tt-ped-venda-arq.pais-servico   
                                   int-ped-item-adic.mes-competencia   = tt-ped-venda-arq.mes-competencia  
                                   int-ped-item-adic.local-servico     = tt-ped-venda-arq.cidade-servico     
                                   int-ped-item-adic.circuito-cliente  = tt-ped-venda-arq.circuito-cliente 
                                   int-ped-item-adic.nome-cliente      = tt-ped-venda-arq.nome-cliente     
                                   int-ped-item-adic.email-gestor      = tt-ped-venda-arq.email-gestor     
                                .
                        END. /* IF NOT AVAIL int-ped-item-adic THEN DO: */
    
                    END. /* IF  AVAIL  tt-ped-item THEN DO: */
    
                END. /* FOR EACH tt-ped-item-arq */
    
            END. /* IF AVAIL natur-oper AND natur-oper.tipo = 3 THEN DO: /* NF Servicos*/ */
            
            ASSIGN l-erro = NO.
    
            RUN pi-executar-bos (INPUT  c-desc-suspend,
                                 OUTPUT l-erro).

            IF  NOT VALID-HANDLE(h-bodi159com) THEN
                RUN dibo/bodi159com.p PERSISTENT SET h-bodi159com.
    
            FIND ped-venda
                WHERE ped-venda.nr-pedcli = tt-ped-venda.nr-pedcli 
                  AND ped-venda.nome-abrev = tt-ped-venda.nome-abrev
                EXCLUSIVE-LOCK NO-ERROR.

            IF  NOT CAN-FIND (FIRST tt-erro-local) 
            AND AVAIL ped-venda THEN DO:
                PUT tt-ped-venda-arq.linha + "Pedido Importado - Estab " ped-venda.cod-estabel " Cliente " ped-venda.cod-emitente " Prev. Fatur " ped-venda.dt-entrega SKIP.
                PUT tt-ped-venda-arq.linha + "Efetivado Pedido: " ped-venda.nr-pedcli SKIP.
            END.

            RELEASE ped-venda.
            
    
            IF  l-erro THEN DO:
                FOR EACH tt-erro-local:
                    ASSIGN tt-erro-local.mensagem = REPLACE(tt-erro-local.mensagem,"Pedido:","").
                END.
    
                NEXT blk_pedido.
            END.
        END.

    END. /**** FIND FIRST tt-ped-venda-arq ****/   
END.  /****** DO TRANSACTION **********/


/*OUTPUT CLOSE.*/


/* FOR EACH tt-ped-venda NO-LOCK:                                                                                                              */
/*     FIND ped-venda                                                                                                                          */
/*             WHERE ped-venda.nr-pedcli = tt-ped-venda.nr-pedcli                                                                              */
/*               AND ped-venda.nome-abrev = tt-ped-venda.nome-abrev                                                                            */
/*             EXCLUSIVE-LOCK NO-ERROR.                                                                                                        */
/*                                                                                                                                             */
/*     IF AVAIL ped-venda THEN DO:                                                                                                             */
/*         ASSIGN ped-venda.completo = NO.                                                                                                     */
/*                                                                                                                                             */
/*         RUN completeOrder IN h-bodi159com (INPUT  ROWID(ped-venda),                                                                         */
/*                                            OUTPUT TABLE rowErrors).                                                                         */
/*         FOR EACH  rowErrors NO-LOCK                                                                                                         */
/*             WHERE rowErrors.errornumber <> 8259:  /* credito n∆o aprovado */                                                                */
/*             CREATE tt-erro-local.                                                                                                                 */
/*             ASSIGN tt-erro-local.mensagem = RowErrors.errorDescription + " Cliente: " + ped-venda.nome-abrev + " Pedido: " + ped-venda.nr-pedcli. */
/*                                                                                                                                             */
/*             IF  rowErrors.errorSubType <> "Warning":U THEN                                                                                  */
/*                 ASSIGN l-erro = YES.                                                                                                        */
/*         END.                                                                                                                                */
/*                                                                                                                                             */
/*     END.                                                                                                                                    */
/* END.           
                                                                                                                 
                                                                                                                             */

/*PUT "10" SKIP.*/
RUN pi-destroi-handles.

{include/i-rpclo.i}

RETURN "OK":U.
END PROCEDURE.

/*--- Procedures Internas ---*/
PROCEDURE pi-cria-tt-arquivo:
    
    ASSIGN i-cont  = 0
           i-linha = 0.

    RUN pi-acompanhar IN h-acomp (INPUT "Importando arquivo...").

    INPUT FROM VALUE(tt-param.c-arq-import) CONVERT SOURCE "iso8859-1".
    REPEAT:
        IMPORT UNFORMATTED c-linha.
        /*PUT c-linha FORMAT "x(200)" SKIP.*/

        IF  c-linha = "" THEN
            LEAVE.

        
        /* Criaá∆o do Pedido */
        IF  ENTRY(1, c-linha, ";") = "pedido" THEN DO:
            ASSIGN i-cont = i-cont + 1.
                   i-linha = i-linha + 1.

            CREATE tt-ped-venda-arq.
            ASSIGN tt-ped-venda-arq.cod-estabel      =     TRIM(ENTRY(2, c-linha, ";"))
                   tt-ped-venda-arq.cod-cliente      = INT(TRIM(ENTRY(3, c-linha, ";")))
                   tt-ped-venda-arq.nr-tabpre        =     TRIM(ENTRY(4, c-linha, ";"))
                   tt-ped-venda-arq.nr-proposta      =     TRIM(ENTRY(5, c-linha, ";"))
                   tt-ped-venda-arq.atendente        =     TRIM(ENTRY(6, c-linha, ";"))
                   tt-ped-venda-arq.cod-repres       =     TRIM(ENTRY(7, c-linha, ";"))    
                   tt-ped-venda-arq.destino          =     TRIM(ENTRY(8, c-linha, ";"))
                   tt-ped-venda-arq.rota             =     TRIM(ENTRY(9, c-linha, ";"))
                   tt-ped-venda-arq.nat-operacao     =     TRIM(ENTRY(10, c-linha, ";"))
                   tt-ped-venda-arq.unid-comerc      =     TRIM(ENTRY(11, c-linha, ";"))
                   tt-ped-venda-arq.cod-priori       =     TRIM(ENTRY(12, c-linha, ";"))
                   tt-ped-venda-arq.dt-entrega       = DATE(TRIM(ENTRY(13, c-linha, ";")))
                   tt-ped-venda-arq.cod-cond-pag     = INTEGER(TRIM(ENTRY(14, c-linha, ";")))
                   tt-ped-venda-arq.nm-abrev-transp  =     TRIM(ENTRY(15, c-linha, ";"))
                   tt-ped-venda-arq.obs-pedido       =     TRIM(ENTRY(16, c-linha, ";"))
                   tt-ped-venda-arq.obs-nota         =     TRIM(ENTRY(17, c-linha, ";"))
                   tt-ped-venda-arq.nome-abrev-tri   =     TRIM(ENTRY(18, c-linha, ";"))
                   tt-ped-venda-arq.po-cliente       =     TRIM(ENTRY(19, c-linha, ";"))
                   tt-ped-venda-arq.l-troca-nota     =     TRIM(ENTRY(20, c-linha, ";"))
                    
                   tt-ped-venda-arq.pedido-servico   = TRIM(ENTRY(21, c-linha, ";"))
                   tt-ped-venda-arq.item-servico     = TRIM(ENTRY(22, c-linha, ";"))
                   tt-ped-venda-arq.folha-registro   = TRIM(ENTRY(23, c-linha, ";"))
                   tt-ped-venda-arq.tp-servico       = TRIM(ENTRY(24, c-linha, ";"))
                   tt-ped-venda-arq.cidade-servico   = TRIM(ENTRY(25, c-linha, ";"))
                   tt-ped-venda-arq.uf-servico       = TRIM(ENTRY(26, c-linha, ";"))
                   tt-ped-venda-arq.pais-servico     = TRIM(ENTRY(27, c-linha, ";"))
                   tt-ped-venda-arq.mes-competencia  = TRIM(ENTRY(28, c-linha, ";"))
                   tt-ped-venda-arq.circuito-cliente = TRIM(ENTRY(29, c-linha, ";"))
                   tt-ped-venda-arq.nome-cliente     = TRIM(ENTRY(30, c-linha, ";"))
                   tt-ped-venda-arq.email-gestor     = TRIM(ENTRY(31, c-linha, ";"))
                   tt-ped-venda-arq.nome-tr-red      = TRIM(ENTRY(32, c-linha, ";"))
                   tt-ped-venda-arq.dt-cond-espec    = date(TRIM(ENTRY(33, c-linha, ";")))
                   tt-ped-venda-arq.pc-desc-pedido   = STRING(TRIM(ENTRY(34, c-linha, ";"))) //novo
                   tt-ped-venda-arq.cod-projeto      = STRING(TRIM(ENTRY(35, c-linha, ";"))) //novo
                   tt-ped-venda-arq.cod-canal-venda  = STRING(TRIM(ENTRY(36, c-linha, ";"))) //novo
                   tt-ped-venda-arq.num-dias-parc    = STRING(TRIM(ENTRY(37, c-linha, ";"))) //novo
                   tt-ped-venda-arq.linha            = "Linha " + string(i-linha) + ": ".
            //IDBA Bruno 20/08/2023
            //Cria controle dos registros que ser∆o usados para vincular as sequencias as parcelas de receita recorrente 
            IF tt-param.l-contrato = YES THEN DO:
                ASSIGN tt-ped-venda-arq.nr-contrato = STRING(TRIM(ENTRY(38, c-linha, ";"))) .
            END.
            IF tt-param.l-receita-recorrente = YES THEN DO:
                ASSIGN tt-ped-venda-arq.receita-rec-parcela-ini          = INT(TRIM(ENTRY(39, c-linha, ";"))) .
                ASSIGN tt-ped-venda-arq.receita-rec-nr-parcelas          = INT(TRIM(ENTRY(40, c-linha, ";"))) .
                ASSIGN tt-ped-venda-arq.receita-rec-data-vcto-parecela   = DATE(TRIM(ENTRY(41, c-linha, ";"))) .
                //Caso nao seja informado o numero da parcela, vamos buscar o numero da ultima parcela importada e seguir do sequencial
                
                IF tt-ped-venda-arq.receita-rec-parcela-ini = 0 OR tt-ped-venda-arq.receita-rec-parcela-ini = ? THEN DO :
                   ASSIGN l-incrementa-parcela = YES.
                END.
                /**
                    MESSAGE "tt-ped-venda-arq.receita-rec-parcela-ini:" tt-ped-venda-arq.receita-rec-parcela-ini
                        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

               // IF length(ENTRY(39, c-linha, ";")) > 0  THEN DO:
                    FIND LAST int-ped-venda WHERE int-ped-venda.nr-contrato = tt-ped-venda-arq.nr-contrato NO-ERROR.
                    IF NOT AVAIL int-ped-venda THEN DO:
                        MESSAGE "OK1"
                        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

                        ASSIGN tt-ped-venda-arq.receita-rec-parcela-ini = 1 .
                    END.
                    ELSE DO:

                    END.
                END.
                ***/

            END.

            IF tt-ped-venda-arq.nr-proposta = "" THEN DO:
               ASSIGN tt-ped-venda-arq.nr-proposta = string(i-cont)
                      tt-ped-venda-arq.l-proposta-vazio = YES.
            END.

            FIND FIRST int-emitente NO-LOCK
                 WHERE int-emitente.cod-emitente =  tt-ped-venda-arq.cod-cliente NO-ERROR.

        END.
        ELSE DO: /* Criaá∆o dos Itens do Pedido */

             IF  ENTRY(1, c-linha, ";") = "item" THEN DO:
                 i-linha = i-linha + 1.
                 CREATE tt-ped-item-arq.
                 ASSIGN tt-ped-item-arq.nr-proposta      =     TRIM(ENTRY(2, c-linha, ";"))
                        tt-ped-item-arq.it-codigo        =     TRIM(ENTRY(3, c-linha, ";"))
                        tt-ped-item-arq.qtd              = DEC(TRIM(ENTRY(4, c-linha, ";")))
                        tt-ped-item-arq.pc-desc          = STRING(TRIM(ENTRY(5, c-linha, ";")))
                        tt-ped-item-arq.cod-repres       = trim(entry(7, c-linha, ";"))
                        tt-ped-item-arq.nr-tabpre        = TRIM(ENTRY(8, c-linha, ";"))
                        tt-ped-item-arq.linha           = "Linha " + string(i-linha) + ": ".

                 IF AVAIL int-emitente AND int-emitente.log-sales THEN DO:
                     IF DEC(TRIM(ENTRY(6, c-linha, ";"))) > 0 AND tt-param.l-import-preco THEN
                         ASSIGN tt-ped-item-arq.preco = DEC(TRIM(ENTRY(6, c-linha, ";"))).
                     ELSE DO:
                         ASSIGN tt-ped-item-arq.preco = 0.

                         FIND LAST preco-item NO-LOCK
                             WHERE preco-item.it-codigo  = tt-ped-item-arq.it-codigo
                               AND preco-item.nr-tabpre  = tt-ped-item-arq.nr-tabpre
                               AND preco-item.situacao   = 1
                               AND preco-item.dt-inival <= TODAY NO-ERROR.
                         IF  AVAIL preco-item THEN DO:
                             ASSIGN tt-ped-item-arq.preco = preco-item.preco-venda.
                         END.
                     END.
                 END.
                 ELSE DO:
                    IF tt-param.l-import-preco THEN
                        ASSIGN tt-ped-item-arq.preco = DEC(TRIM(ENTRY(6, c-linha, ";"))).
                    ELSE
                        ASSIGN tt-ped-item-arq.preco = 0.
                 END.
                   

                 IF tt-ped-item-arq.nr-proposta = "" AND 
                    tt-ped-venda-arq.nr-proposta = string(i-cont) THEN DO:
                    assign tt-ped-item-arq.nr-proposta = string(i-cont).
                 END.
                 ELSE DO:
                     IF tt-ped-item-arq.nr-proposta = "" AND
                        tt-ped-venda-arq.nr-proposta <> STRING(i-cont) AND 
                        tt-ped-venda-arq.nr-proposta <> "" THEN DO:
                        assign tt-ped-item-arq.nr-proposta = tt-ped-venda-arq.nr-proposta.
                     END.
                 END.



             END.
        END.
    END.

    INPUT CLOSE.
 /*   
    IF tt-param.l-receita-recorrente THEN DO:

        FIND FIRST tt-ped-venda-arq NO-ERROR.

        RUN pi-valida-receita-recorrente(INPUT tt-ped-venda-arq.nr-contrato, 
                                          INPUT tt-ped-venda-arq.receita-rec-parcela-ini ). 
        IF RETURN-VALUE = "NOK":U THEN DO:
            
            CREATE tt-erro-local.
            ASSIGN tt-erro-local.mensagem = "Numero de parcela informado j† existente para o contrato referenciado ou numero do contrato em branco".
                   l-erro           = YES.


        END.
    END.
*/
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-valida-receita-recorrente:

    DEFINE INPUT        PARAM nr-contrato        AS CHAR FORMAT "X(12)".
    DEFINE INPUT-OUTPUT PARAM parcela-ini        AS INT.
    DEFINE INPUT        PARAM incrementa-parcela AS LOG.

    EMPTY TEMP-TABLE tt-ped-parcela.

    IF length(nr-contrato) = 0 THEN DO:

       CREATE tt-erro-local.
       ASSIGN tt-erro-local.mensagem = "Numero do contrato em branco".
               l-erro           = YES.

       RETURN "NOK":U.
    END.

    // Sempre inicia a temp-table com o registro 0 pra caso n∆o encontre a parcela se inicie do 1
    CREATE tt-ped-parcela.
    ASSIGN tt-ped-parcela.nr-parcela-recor = 0 .

    //Varre todos os pedidos filtrando pelo numero do contrato e buscando suas respectivas parcelas
    FOR EACH int-ped-venda WHERE int-ped-venda.nr-contrato = nr-contrato USE-INDEX ch-pedseq NO-LOCK:
        //USE-INDEX ch-nr-contrato NO-LOCK:

        FIND FIRST ped-venda WHERE ped-venda.nr-pedido = int-ped-venda.nr-pedido NO-ERROR.
        FOR EACH int-ped-item WHERE int-ped-item.nr-pedcli    = ped-venda.nr-pedcli
                                AND int-ped-item.nome-abrev   = ped-venda.nome-abrev 
                                AND int-ped-item.nr-parcela   <> ? NO-LOCK :
            IF AVAIL int-ped-item THEN DO:
                CREATE tt-ped-parcela.
                ASSIGN tt-ped-parcela.nr-pedcli        = int-ped-item.nr-pedcli        
                       tt-ped-parcela.it-codigo        = int-ped-item.it-codigo        
                       tt-ped-parcela.nr-sequencia     = int-ped-item.nr-sequencia     
                       tt-ped-parcela.nr-parcela-recor = int-ped-item.nr-parcela-recor .
            END.
        END.
    END.

    IF incrementa-parcela = YES THEN DO:
        FOR LAST tt-ped-parcela BY tt-ped-parcela.nr-parcela-recor:
            ASSIGN parcela-ini = tt-ped-parcela.nr-parcela-recor + 1 .
        END.
    END.

    FIND LAST tt-ped-parcela WHERE tt-ped-parcela.nr-parcela-recor >= parcela-ini NO-ERROR.
    IF AVAIL tt-ped-parcela THEN DO:
        CREATE tt-erro-local.
        ASSIGN tt-erro-local.mensagem = "Numero da parcela deste contrato j† existente em outro pedido, PEDIDO: " + string(tt-ped-parcela.nr-pedcli) + " ITEM SEQUENCIA: " + string(tt-ped-parcela.nr-sequencia)  .
               l-erro           = YES.

       RETURN "NOK":U.
    END.
    ELSE DO:
       RETURN "OK":U.
    END.
    

END PROCEDURE. //pi-valida-parcelas-duplicadas 

PROCEDURE CriaItem:

    DEF VAR de-valor     AS DEC  NO-UNDO.
    def var i-cod-repres as inte no-undo.

    IF l-log = YES THEN
        PUT "14" SKIP.

    FIND FIRST item NO-LOCK
        WHERE  item.it-codigo = tt-ped-item-arq.it-codigo NO-ERROR.

    IF l-log = YES THEN
        PUT "15 " tt-ped-item-arq.it-codigo AVAIL ITEM SKIP.

    IF  NOT AVAIL ITEM THEN DO:
        CREATE tt-erro-local.
        ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "Item nío encontrado - " + tt-ped-item-arq.it-codigo.
               l-erro           = YES.
        RETURN "NOK":U.
    END.

    if tt-ped-item-arq.cod-repres <> ""
    then do:
         release b-repres.

         assign i-cod-repres = inte(tt-ped-item-arq.cod-repres) no-error.

         if error-status:error
         then.
         else for FIRST b-repres
                  WHERE b-repres.cod-rep = i-cod-repres
                        no-lock: end.
        
         IF l-log = YES THEN
             PUT "16 " tt-ped-item-arq.cod-repres AVAIL b-repres SKIP.
         IF NOT AVAIL b-repres THEN DO:
             CREATE tt-erro-local.
             ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "CΩdigo repres item pedido nío encontrado - " + tt-ped-item-arq.cod-repres.
                    l-erro           = YES.
             RETURN "NOK":U.
         END.
    end.

    
    
    if tt-ped-item-arq.nr-tabpre <> ""
    then do:
        FIND FIRST tb-preco NO-LOCK
            WHERE  tb-preco.nr-tabpre = (tt-ped-item-arq.nr-tabpre) NO-ERROR.

        IF l-log = YES THEN
            PUT "16-1" SKIP.
        IF NOT AVAIL tb-preco THEN DO:
            CREATE tt-erro-local.
            ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "CΩdigo da tabela de preªos informada nío encontrada. " + string(tt-ped-item-arq.nr-tabpre)
                   l-erro            =  YES.

            RETURN "NOK":U.
        END.
    END.
    ELSE DO:
        IF AVAIL int-emitente AND int-emitente.log-salesforce THEN DO:

             FIND FIRST tt-prog-ponto3 
                  WHERE tt-prog-ponto3.conteudo = string(emitente.cod-gr-cli) NO-ERROR.
             IF AVAIL tt-prog-ponto3 THEN DO:
                 CREATE tt-erro-local.
                 ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "Tabela de preco devera ser informada para cliente sales force. ".
                        l-erro            =  YES.
               
                 RETURN "NOK":U.
               
             END.

         END.
    END.

    IF  tt-ped-venda-arq.nat-operacao <> ""
    AND tt-ped-venda-arq.nat-operacao <> ? THEN DO:
    
        /*Chamado 102518, sΩ importa do arquivo as naturezas cadastradas no es0018*/
        IF  CAN-FIND (FIRST tt-prog-ponto
                      WHERE tt-prog-ponto.conteudo = tt-ped-venda-arq.nat-operacao) THEN DO:
            FIND FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao  = tt-ped-venda-arq.nat-operacao 
                   AND natur-oper.nat-operacao >= "500000" NO-ERROR.
       
            IF  AVAIL natur-oper THEN
                ASSIGN c-nat-oper = tt-ped-venda-arq.nat-operacao.
            
        END.
        ELSE DO:
            RUN defineNatOperacao IN h-boes505 (INPUT  estabelec.cod-estabel,
                                                INPUT  emitente.cod-emitente,
                                                INPUT  "padrao",
                                                INPUT  ITEM.it-codigo,
                                                INPUT  IF  tt-ped-venda-arq.destino = "Revenda" THEN NO ELSE YES,
                                                OUTPUT c-nat-oper,
                                                OUTPUT l-return).
    
            IF  NOT l-return THEN DO:
                CREATE tt-erro-local.
                ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "Natureza de operacao p/ item nao encontrada para o cliente/estabelecimento " + STRING(emitente.cod-emitente) + " Estabelec " + estabelec.cod-estabel
                       l-erro           = YES.
    
                RETURN "NOK".
            END.
        END.
    END.
    ELSE DO:
    
        RUN defineNatOperacao IN h-boes505 (INPUT  estabelec.cod-estabel,
                                            INPUT  emitente.cod-emitente,
                                            INPUT  "padrao",
                                            INPUT  ITEM.it-codigo,
                                            INPUT  IF  tt-ped-venda-arq.destino = "Revenda" THEN NO ELSE YES,
                                            OUTPUT c-nat-oper,
                                            OUTPUT l-return).
    
        IF  NOT l-return THEN DO:
            CREATE tt-erro-local.
            ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "Natureza de operaªío p/ Item nío encontrada para o cliente/estabelecimento " + STRING(emitente.cod-emitente) + " Estabelec " + estabelec.cod-estabel
                   l-erro           = YES.
    
            RETURN "NOK".
        END.
    
    END.
    

    FIND FIRST natur-oper NO-LOCK
        WHERE  natur-oper.nat-operacao = c-nat-oper NO-ERROR.
    IF  NOT AVAIL natur-oper THEN DO:
        CREATE tt-erro-local.
        ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "Natureza de operaªío " + c-nat-oper + " invˇlido ou nío cadastrada, Cliente: " + STRING(emitente.cod-emitente) + " Estabelec " + estabelec.cod-estabel + " Item " + item.it-codigo
               l-erro           = YES.
        UNDO, LEAVE.
    END.

    IF  tt-ped-item-arq.qtd = 0 THEN DO:
        CREATE tt-erro-local.
        ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "Item com quantidade zerada  " + item.it-codigo + " Cliente " + STRING(emitente.cod-emitente)
               l-erro           = YES.
        UNDO, LEAVE.
    END.

    FIND LAST  tt-ped-item NO-LOCK
         WHERE tt-ped-item.nr-pedcli = tt-ped-venda.nr-pedcli NO-ERROR.
    IF  AVAIL  tt-ped-item THEN 
        ASSIGN i-sequencia = tt-ped-item.nr-sequencia.
    ELSE
        ASSIGN i-sequencia = 0.

    CREATE tt-ped-item.
    ASSIGN tt-ped-item.nr-pedcli           = tt-ped-venda.nr-pedcli
           tt-ped-item.nome-abrev          = tt-ped-venda.nome-abrev
           tt-ped-item.it-codigo           = item.it-codigo
           tt-ped-item.aliquota-ipi        = item.aliquota-ipi
           tt-ped-item.des-un-medida       = item.un
           tt-ped-item.cod-entrega         = tt-ped-venda.cod-entrega
           OVERLAY(tt-ped-item.char-2,1,8) = item.class-fiscal
           OVERLAY(tt-ped-item.char-2,56,5) = string(ITEM.cod-servico).

    /* Atribuir Sequºncia do Item */
    ASSIGN i-sequencia              = i-sequencia + 10
           tt-ped-item.nr-sequencia = i-sequencia.

    /** Incidente 29678                 **/
    IF tt-ped-venda.cod-priori =  44 OR tt-ped-venda.tp-pedido  = '34' THEN 
        ASSIGN tt-ped-item.dt-entrega = tt-ped-venda.dt-entrega.

    /* Se o preªo nío foi informado deverˇ buscar da tabela informada no pedido */

    /* Inicio busca preªo programa de canais */
     
    IF int-emitente.log-salesforce = NO THEN DO:
        IF  int-emitente.ind-participa-canais = 993520001  /* Participa canais */ 
        AND NOT tt-param.l-import-preco THEN DO:
            FIND FIRST ProdutoItem
                 WHERE ProdutoItem.CodigoProduto = tt-ped-item.it-codigo 
                   AND ProdutoItem.bloqueado     = FALSE NO-LOCK NO-ERROR.
           IF NOT AVAIL produtoitem THEN DO:
              CREATE tt-erro-local.
               ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "ITEM Nao encontrado NO portfolio " + item.it-codigo + " Cliente " + STRING(emitente.cod-emitente)
                      l-erro           = YES.
               UNDO, LEAVE.
    
           END.
           EMPTY TEMP-TABLE tt-itens.
           EMPTY TEMP-TABLE Resultado.
    
           FIND ITEM
               WHERE ITEM.it-codigo = tt-ped-item.it-codigo NO-LOCK NO-ERROR.
           FIND item-uni-estab
               WHERE item-uni-estab.cod-estabel = tt-ped-venda.cod-estabel
                 AND item-uni-estab.it-codigo   = tt-ped-item.it-codigo
               NO-LOCK NO-ERROR.
    
           FIND FIRST int-calculo-canal-item NO-LOCK
                WHERE int-calculo-canal-item.cod-guid    = int-emitente.cod-guid
                  AND int-calculo-canal-item.cod-estabel = tt-ped-venda.cod-estabel
                  AND int-calculo-canal-item.it-codigo   = tt-ped-item.it-codigo
                  AND int-calculo-canal-item.data-calculo = TODAY NO-ERROR.
           IF AVAIL int-calculo-canal-item THEN DO:
               ASSIGN de-valor = int-calculo-canal-item.valor-produto.
           END.
           ELSE DO:
               EMPTY TEMP-TABLE tt-itens.
               CREATE tt-itens.
               ASSIGN tt-itens.it-codigo              = tt-ped-item.it-codigo
                      tt-itens.de-quantidade          = tt-ped-item-arq.qtd
                      tt-itens.TipoPortfolio          = 993520005
                      tt-itens.CodigoUnidadeNegocio   = item-uni-estab.cod-unid-neg
                      tt-itens.CodigoFamiliaComercial = ITEM.fm-cod-com
                      tt-itens.CodigoEstabelecimento  = tt-ped-venda.cod-estabel.
    
               RUN esp/esb/out/msg0101.p (INPUT int-emitente.cod-guid,
                                          INPUT  TABLE tt-itens,
                                          OUTPUT TABLE ProdutoItemR,
                                          OUTPUT TABLE Resultado).
    
               FIND FIRST ProdutoItemR NO-ERROR.
               FIND FIRST Resultado    NO-ERROR.
    
               IF  AVAIL Resultado THEN DO:
               
                   IF Resultado.Sucesso THEN DO:
                       ASSIGN de-valor = ProdutoItemR.ValorComDesconto.
        
                       FIND FIRST int-calculo-canal-item EXCLUSIVE-LOCK
                            WHERE int-calculo-canal-item.cod-guid    = int-emitente.cod-guid
                              AND int-calculo-canal-item.cod-estabel = tt-ped-venda.cod-estabel
                              AND int-calculo-canal-item.it-codigo   = tt-ped-item.it-codigo NO-ERROR.
                       IF AVAIL int-calculo-canal-item THEN DO:
                           ASSIGN int-calculo-canal-item.valor-produto          = ProdutoItemR.ValorComDesconto
                                  int-calculo-canal-item.perc-descto-verde      = ProdutoItemR.PercentualDescontoVerde
                                  int-calculo-canal-item.perc-descto-top-milhao = ProdutoItemR.PercentualDescontoTopMilhao
                                  int-calculo-canal-item.perc-rebate-antec      = ProdutoItemR.PercentualRebateAntecipado
                                  int-calculo-canal-item.data-calculo           = TODAY.
                       END.
                       ELSE DO:
                           CREATE int-calculo-canal-item.
                           ASSIGN int-calculo-canal-item.cod-guid               = int-emitente.cod-guid   
                                  int-calculo-canal-item.cod-estabel            = tt-ped-venda.cod-estabel   
                                  int-calculo-canal-item.it-codigo              = ProdutoItemR.CodigoProduto
                                  int-calculo-canal-item.preco-base             = ProdutoItemR.PrecoBase
                                  int-calculo-canal-item.valor-produto          = ProdutoItemR.ValorComDesconto
                                  int-calculo-canal-item.tipo-portifolio        = 993520005
                                  int-calculo-canal-item.bloqueado              = NO
                                  int-calculo-canal-item.qtd-range              = ProdutoItemR.QuantidadeMaxima
                                  int-calculo-canal-item.log-calcrebate         = ProdutoItemR.CalcularRebate            
                                  int-calculo-canal-item.log-preco-alterado     = ProdutoItemR.PrecoAlterado             
                                  int-calculo-canal-item.log-rebate-antec       = ProdutoItemR.RebateAntecipado          
                                  int-calculo-canal-item.perc-descto-verde      = ProdutoItemR.PercentualDescontoVerde
                                  int-calculo-canal-item.perc-descto-top-milhao = ProdutoItemR.PercentualDescontoTopMilhao
                                  int-calculo-canal-item.perc-rebate-antec      = ProdutoItemR.PercentualRebateAntecipado
                                  int-calculo-canal-item.data-calculo           = TODAY.
                       END.
                       RELEASE int-calculo-canal-item.
                   END.
                   ELSE DO:
                       CREATE tt-erro-local.
                       ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "Valor CRM Sem resultado. Preªo calculado zerado  " + item.it-codigo + " Cliente " + STRING(emitente.cod-emitente)
                              l-erro           = YES.
                       UNDO, LEAVE.
                   END.
               END.
               ELSE DO:
                   CREATE tt-erro-local.
                   ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "Valor CRM Sem resultado. Preªo calculado zerado  " + item.it-codigo + " Cliente " + STRING(emitente.cod-emitente)
                          l-erro           = YES.
                   UNDO, LEAVE.
               END.
           END.    
           
           IF de-valor <> 0 THEN DO:
    
               IF NOT VALID-HANDLE (h-msg138a) THEN
                   RUN esp/esb/in/msg0138a.p PERSISTENT SET h-msg138a.
    
               RUN pi-calc-juros IN h-msg138a (INPUT  tt-ped-venda.cod-cond-pag,
                                               OUTPUT p-indice-financiamento,
                                               OUTPUT TABLE tt-erro).
    
    
               RUN pi-calcula-icms IN h-msg138a (INPUT  int-emitente.cod-guid,
                                                 INPUT  tt-ped-venda.cod-estabel,
                                                 INPUT  tt-ped-item.it-codigo,
                                                 OUTPUT de-perc-icms,
                                                 OUTPUT de-perc-desc-icms,
                                                 OUTPUT TABLE tt-erro).
    
               IF VALID-HANDLE(h-msg138a) THEN
                   DELETE PROCEDURE h-msg138a.
    
               IF  de-perc-desc-icms > 0 THEN
                   ASSIGN de-perc-desc-icms = ((100 - de-perc-desc-icms) / 100)
                          de-valor  = round(de-valor / de-perc-desc-icms,4).
    
               IF p-indice-financiamento = 0 THEN
                   ASSIGN tt-ped-item.vl-pretab           = (de-valor / ((100 - de-perc-icms) / 100)).
               ELSE DO:
    
                   RUN esp/pdp/espdp098.p(INPUT int-emitente.cod-guid,
                                          INPUT tt-ped-venda.cod-estabel ,
                                          INPUT tt-ped-item.it-codigo,
                                          INPUT de-valor,
                                          INPUT de-perc-icms,
                                          INPUT p-indice-financiamento,
                                          OUTPUT de-valor-item ).
    
                   IF de-valor-item <> 0 THEN
                       ASSIGN tt-ped-item.vl-pretab = de-valor-item.
                   ELSE IF (de-valor / ((100 - de-perc-icms) / 100)) * p-indice-financiamento <> 0 THEN
                            ASSIGN  tt-ped-item.vl-pretab       = (de-valor / ((100 - de-perc-icms) / 100)) * p-indice-financiamento.
                         ELSE DO:
                             CREATE tt-erro-local.
                             ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "Valor CRM 0. Preªo nío encontrado - preco calculado zerado  " + item.it-codigo + " Cliente " + STRING(emitente.cod-emitente)
                                    l-erro           = YES.
                             UNDO, LEAVE.
                         END.
               END.
           END.
    /* Fim busca preªo programa de canais */
        END.
        ELSE
            IF  tt-ped-item-arq.preco = 0 THEN DO:
                FIND LAST preco-item NO-LOCK
                    WHERE preco-item.it-codigo  = tt-ped-item.it-codigo
                    AND   preco-item.nr-tabpre  = tt-ped-venda-arq.nr-tabpre
                    AND   preco-item.situacao   = 1
                    AND   preco-item.dt-inival <= TODAY NO-ERROR.
                IF  AVAIL preco-item THEN
                    ASSIGN tt-ped-item.vl-preori = preco-item.preco-venda
                           tt-ped-item.vl-pretab = preco-item.preco-venda.
            END.
            ELSE
                ASSIGN tt-ped-item.vl-pretab = tt-ped-item-arq.preco
                       tt-ped-item.vl-preori = tt-ped-item.vl-pretab.
    END.

     IF int-emitente.log-salesforce = YES THEN DO:
       
       CREATE mgesp.int-ped-item-pci. 
       ASSIGN int-ped-item-pci.nome-abrev         = tt-ped-venda.nome-abrev  
              int-ped-item-pci.nr-pedcli          = tt-ped-venda.nr-pedcli   
              int-ped-item-pci.it-codigo          = tt-ped-item.it-codigo    
              int-ped-item-pci.nr-sequencia       = tt-ped-item.nr-sequencia 
              int-ped-item-pci.nr-tabpre          = tt-ped-item-arq.nr-tabpre
              int-ped-item-pci.desc-neg-comercial = IF dec(tt-ped-item-arq.pc-desc) > 0 THEN dec(tt-ped-item-arq.pc-desc) ELSE 0.

      /* IF NOT tt-param.l-import-preco THEN DO:
          FIND LAST preco-item 
              WHERE preco-item.it-codigo  = tt-ped-item.it-codigo
                AND preco-item.nr-tabpre  = tt-ped-item-arq.nr-tabpre  //c-tab-preco 
                AND preco-item.cod-refer  = tt-ped-venda.cod-estabel
                and preco-item.dt-inival <= today    
                and preco-item.situacao   = 1 
                /*AND preco-item.quant-min  <= tt-ped-item-arq.qtd*/  NO-LOCK NO-ERROR.
         
          IF AVAIL preco-item THEN 
             ASSIGN tt-ped-item.vl-pretab      = tt-ped-item-arq.preco //preco-item.preco-venda
                    tt-ped-item.vl-preori      = tt-ped-item-arq.preco //preco-item.preco-venda.
          ELSE DO:
              CREATE tt-erro-local.
              ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + 
                  "Tabela de preªos informada nao possui preªo ativo para o item " + item.it-codigo + " TabPreªo " + tt-ped-item-arq.nr-tabpre
                     l-erro           = YES.
              UNDO, LEAVE.
          END. 
       END. */

       ASSIGN tt-ped-item.vl-pretab      = tt-ped-item-arq.preco //preco-item.preco-venda
              tt-ped-item.vl-preori      = tt-ped-item-arq.preco. //preco-item.preco-venda
              

       FIND FIRST cond-pagto
            WHERE cond-pagto.cod-cond-pag   = tt-ped-venda.cod-cond-pag NO-LOCK NO-ERROR.
       FIND FIRST tab-finan-indice NO-LOCK
            WHERE tab-finan-indice.nr-tab-finan = cond-pagto.nr-tab-finan
              AND tab-finan-indice.num-seq = cond-pagto.nr-ind-finan NO-ERROR.

       IF AVAIL tab-finan-indice THEN DO:
          ASSIGN  p-indice-financiamento = tab-finan-indice.tab-ind-fin.
       END.
        // APLICA INDICE DE FINANCIAMENTO NO PRECO 
        IF p-indice-financiamento <> 1 THEN DO:
           ASSIGN tt-ped-item.vl-pretab      = /*preco-item.preco-venda*/ tt-ped-item.vl-pretab * p-indice-financiamento
                  tt-ped-item.vl-preori      = /*preco-item.preco-venda*/ tt-ped-item.vl-preori * p-indice-financiamento.
        END.
        
        // APLICA NO PRECO O FATOR DE DESCONTO ACRESCIMO DO CLIENTE 
        ASSIGN de-fator-cli = 0.
        RUN pi-busca-desconto-cliente (INPUT tt-ped-venda.cod-emitente,
                                       INPUT tt-ped-item-arq.nr-tabpre,
                                       INPUT tt-ped-item-arq.it-codigo,
                                       OUTPUT de-fator-cli).
        
        IF de-fator-cli <> 0 THEN DO:
           ASSIGN tt-ped-item.vl-pretab      = /*preco-item.preco-venda*/ tt-ped-item.vl-pretab * de-fator-cli
                  tt-ped-item.vl-preori      = /*preco-item.preco-venda*/ tt-ped-item.vl-preori * de-fator-cli.
        END.

        //Busca a matriz pra validar os  beneficios da conta
        FIND FIRST int-emitente-canal 
             WHERE int-emitente-canal.cod-emitente = tt-ped-venda.cod-emitente NO-LOCK NO-ERROR.

        IF AVAIL int-emitente-canal THEN
           FIND FIRST emitente 
                WHERE emitente.cod-emitente = int-emitente-canal.cod-emitente-matriz NO-LOCK NO-ERROR.

        IF NOT AVAIL emitente THEN
           FIND FIRST emitente 
                WHERE emitente.cod-emitente = tt-ped-venda.cod-emitente NO-LOCK NO-ERROR. 

       FOR EACH int-beneficio-conta NO-LOCK
          WHERE int-beneficio-conta.cod-emitente      = emitente.cod-emitente //tt-ped-venda.cod-emitente
            AND int-beneficio-conta.log-ativo         = YES
            AND int-beneficio-conta.log-bloq-infracao = NO:

           FIND FIRST ITEM
                WHERE ITEM.it-codigo = tt-ped-item.it-codigo NO-LOCK NO-ERROR.

           IF int-beneficio-conta.segmento-produto = SUBSTR(ITEM.fm-cod-com,1,4) AND 
              int-beneficio-conta.familia-produto  = SUBSTR(item.fm-cod-com,1,5) THEN
              RUN pi-desconto.

           IF int-beneficio-conta.segmento-produto = SUBSTR(ITEM.fm-cod-com,1,4) AND 
              int-beneficio-conta.familia-produto  = '' THEN
              RUN pi-desconto.

           IF int-beneficio-conta.segmento-produto = '' AND 
              int-beneficio-conta.familia-produto  = '' THEN
              RUN pi-desconto.

       END.

       FIND FIRST mgesp.int-ped-item-pci                                   
            WHERE int-ped-item-pci.nome-abrev   = tt-ped-venda.nome-abrev   
              AND int-ped-item-pci.nr-pedcli    = tt-ped-venda.nr-pedcli    
              AND int-ped-item-pci.it-codigo    = tt-ped-item.it-codigo     
              AND int-ped-item-pci.nr-sequencia = tt-ped-item.nr-sequencia  NO-LOCK NO-ERROR.
     
       IF dec(tt-ped-item-arq.pc-desc) > 0 THEN 
          ASSIGN tt-ped-item.des-pct-desconto-inform = STRING(tt-ped-item-arq.pc-desc).

       IF tt-ped-item.des-pct-desconto-inform <> '' AND 
           int-ped-item-pci.desc-topmilhao > 0 THEN 
           ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform + '+'.
        IF dec(int-ped-item-pci.desc-topmilhao) > 0 THEN
           ASSIGN tt-ped-item.des-pct-desconto-inform  = tt-ped-item.des-pct-desconto-inform + string(int-ped-item-pci.desc-topmilhao).
        IF tt-ped-item.des-pct-desconto-inform <> '' AND 
           int-ped-item-pci.desc-maisverde > 0 THEN 
           ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform + '+'.
        IF dec(int-ped-item-pci.desc-maisverde) > 0 THEN
           ASSIGN tt-ped-item.des-pct-desconto-inform  = tt-ped-item.des-pct-desconto-inform + string(int-ped-item-pci.desc-maisverde).
        IF tt-ped-item.des-pct-desconto-inform <> '' AND 
           int-ped-item-pci.desc-focounid > 0 THEN 
           ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform + '+'.
        IF dec(int-ped-item-pci.desc-focounid) > 0 THEN
           ASSIGN tt-ped-item.des-pct-desconto-inform  = tt-ped-item.des-pct-desconto-inform + string(int-ped-item-pci.desc-focounid).
        IF tt-ped-item.des-pct-desconto-inform <> '' AND 
           int-ped-item-pci.desc-distrib > 0 THEN 
           ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform + '+'.
        IF dec(int-ped-item-pci.desc-distrib) > 0 THEN
           ASSIGN tt-ped-item.des-pct-desconto-inform   = tt-ped-item.des-pct-desconto-inform + string(int-ped-item-pci.desc-distrib20).
        IF tt-ped-item.des-pct-desconto-inform <> '' AND 
           int-ped-item-pci.desc-widecloud > 0 THEN 
           ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform + '+'.
        IF dec(int-ped-item-pci.desc-widecloud) > 0 THEN
           ASSIGN tt-ped-item.des-pct-desconto-inform  = tt-ped-item.des-pct-desconto-inform + string(int-ped-item-pci.desc-widecloud).

    END.
    ELSE DO:
        IF dec(tt-ped-item-arq.pc-desc) > 0 THEN 
          ASSIGN tt-ped-item.des-pct-desconto-inform = STRING(tt-ped-item-arq.pc-desc).
    END.



    IF l-log = YES THEN
        PUT "Natureza ITEM " natur-oper.nat-operacao SKIP.

    ASSIGN tt-ped-item.vl-preori               = tt-ped-item.vl-pretab
           tt-ped-item.qt-pedida               = tt-ped-item-arq.qtd
           tt-ped-item.qt-un-fat               = tt-ped-item.qt-pedida
           tt-ped-item.cod-sit-item            = tt-ped-venda.cod-sit-ped
           tt-ped-item.cod-sit-pre             = tt-ped-venda.cod-sit-pre
           tt-ped-item.dt-entorig              = tt-ped-venda.dt-entorig
           tt-ped-item.dt-userimp              = tt-ped-venda.dt-userimp
           tt-ped-item.esp-ped                 = 1
           tt-ped-item.nat-operacao            = natur-oper.nat-operacao
           tt-ped-item.per-des-icms            = natur-oper.per-des-icms
           tt-ped-item.tp-adm-lote             = 1
           tt-ped-item.tp-preco                = 0
           tt-ped-item.user-impl               = tt-ped-venda.user-impl
           tt-ped-item.log-usa-tabela-desconto = NO
           tt-ped-item.per-minfat              = IF AVAIL emitente THEN emitente.per-minfat ELSE tt-ped-item.per-minfat
           tt-ped-item.cd-origem               = 2
           tt-ped-item.tipo-atend              = IF item.baixa-estoq = NO OR tt-ped-venda.ind-fat-par THEN 2 ELSE 1.

    CREATE tt-int-ped-item.
    ASSIGN tt-int-ped-item.nome-abrev    = tt-ped-item.nome-abrev
           tt-int-ped-item.nr-pedcli     = tt-ped-item.nr-pedcli
           tt-int-ped-item.nr-sequencia  = tt-ped-item.nr-sequencia
           tt-int-ped-item.it-codigo     = tt-ped-item.it-codigo.

    release int-segmento-item.

    if avail emitente
    then for FIRST int-segmento-item
             WHERE int-segmento-item.it-codigo  = tt-ped-item.it-codigo
               AND int-segmento-item.cod-gr-cli = emitente.cod-gr-cli
                   no-lock: end.

    create tt-int-ped-item-pci.
    assign tt-int-ped-item-pci.nome-abrev   = tt-ped-item.nome-abrev
           tt-int-ped-item-pci.nr-pedcli    = tt-ped-item.nr-pedcli
           tt-int-ped-item-pci.nr-sequencia = tt-ped-item.nr-sequencia
           tt-int-ped-item-pci.it-codigo    = tt-ped-item.it-codigo
           tt-int-ped-item-pci.cod-refer    = tt-ped-item.cod-refer
           tt-int-ped-item-pci.cod-repres   = if tt-ped-item-arq.cod-repres <> ""
                                              then inte(tt-ped-item-arq.cod-repres)
                                              else inte(tt-ped-venda-arq.cod-repres)
           tt-int-ped-item-pci.cod-segmento = int-segmento-item.cod-segmento when avail int-segmento-item.
    find current tt-int-ped-item-pci no-error.
    release tt-int-ped-item-pci.
           
    IF  tt-ped-venda-arq.destino = "Revenda"  then do:
        IF  NOT VALID-HANDLE(h-bodi154sdf) THEN
            RUN dibo/bodi154sdf.p PERSISTENT SET h-bodi154sdf.
    
        IF  AVAIL emitente   AND
            AVAIL natur-oper THEN DO:
            RUN setICMRetido IN h-bodi154sdf (INPUT  tt-ped-item.nome-abrev,
                                              INPUT  tt-ped-item.cod-entrega,
                                              INPUT  tt-ped-item.it-codigo,
                                              INPUT  tt-ped-venda.cod-estabel,
                                              INPUT  emitente.insc-subs-trib,
                                              INPUT  natur-oper.subs-trib,
                                              OUTPUT tt-ped-item.ind-icm-ret).  
        END.
        DELETE PROCEDURE h-bodi154sdf.
        /* Fim Busca Indicador ICMS Ret */    
    end .


    /* Definiªío do Valor Unitˇrio com Desconto ZFM */
    IF  natur-oper.per-des-icm > 0 THEN
        ASSIGN tt-ped-item.vl-preuni = tt-ped-item.vl-preori - (tt-ped-item.vl-preori * (natur-oper.per-des-icm / 100)) WHEN AVAIL natur-oper.
    ELSE
        ASSIGN tt-ped-item.vl-preuni = tt-ped-item.vl-preori.

    ASSIGN tt-ped-item.vl-liq-it   = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni
           tt-ped-item.vl-merc-abe = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni.


    /* Tratamento IPI */
    IF  item.cd-trib-ipi       = 1  AND   /* Tributado */
       (natur-oper.cd-trib-ipi = 1  OR    /* Tributado */
        natur-oper.cd-trib-ipi = 4) THEN  /* Reduzido  */
        ASSIGN tt-ped-item.vl-liq-abe = tt-ped-item.vl-liq-it + (tt-ped-item.vl-liq-it * tt-ped-item.aliquota-ipi / 100).
    ELSE
        ASSIGN tt-ped-item.vl-liq-abe = tt-ped-item.vl-liq-it.

    ASSIGN tt-ped-item.vl-tot-it = tt-ped-item.vl-liq-abe.


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

    /* Atribuir Valores Totais do Pedido */
    ASSIGN d-vl-liq-it  = d-vl-liq-it  + tt-ped-item.vl-liq-it
           d-vl-liq-abe = d-vl-liq-abe + tt-ped-item.vl-liq-abe.
END PROCEDURE.


PROCEDURE CriaItemReceitaRecorrente:

    DEF INPUT PARAM  iCont        AS INT.
    DEF INPUT PARAM  iParcela     AS INT FORMAT 999.
    DEF INPUT PARAM  dt-entrega   AS DATE.
   // DEF INPUT PARAM  i-sequencia  AS INT.
 

    DEF VAR de-valor     AS DEC  NO-UNDO.
    def var i-cod-repres as inte no-undo.

    IF l-log = YES THEN
        PUT "14" SKIP.

    FIND FIRST item NO-LOCK
        WHERE  item.it-codigo = tt-ped-item-arq.it-codigo NO-ERROR.

    IF l-log = YES THEN
        PUT "15 " tt-ped-item-arq.it-codigo AVAIL ITEM SKIP.

    IF  NOT AVAIL ITEM THEN DO:
        CREATE tt-erro-local.
        ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "Item nío encontrado - " + tt-ped-item-arq.it-codigo.
               l-erro           = YES.
        RETURN "NOK":U.
    END.

    if tt-ped-item-arq.cod-repres <> ""
    then do:
         release b-repres.

         assign i-cod-repres = inte(tt-ped-item-arq.cod-repres) no-error.

         if error-status:error
         then.
         else for FIRST b-repres
                  WHERE b-repres.cod-rep = i-cod-repres
                        no-lock: end.
        
         IF l-log = YES THEN
             PUT "16 " tt-ped-item-arq.cod-repres AVAIL b-repres SKIP.
         IF NOT AVAIL b-repres THEN DO:
             CREATE tt-erro-local.
             ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "CΩdigo repres item pedido nío encontrado - " + tt-ped-item-arq.cod-repres.
                    l-erro           = YES.
             RETURN "NOK":U.
         END.
    end.

    
    
    if tt-ped-item-arq.nr-tabpre <> ""
    then do:
        FIND FIRST tb-preco NO-LOCK
            WHERE  tb-preco.nr-tabpre = (tt-ped-item-arq.nr-tabpre) NO-ERROR.

        IF l-log = YES THEN
            PUT "16-1" SKIP.
        IF NOT AVAIL tb-preco THEN DO:
            CREATE tt-erro-local.
            ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "CΩdigo da tabela de preªos informada nío encontrada. " + string(tt-ped-item-arq.nr-tabpre)
                   l-erro            =  YES.

            RETURN "NOK":U.
        END.
    END.
    ELSE DO:
        IF AVAIL int-emitente AND int-emitente.log-salesforce THEN DO:

             FIND FIRST tt-prog-ponto3 
                  WHERE tt-prog-ponto3.conteudo = string(emitente.cod-gr-cli) NO-ERROR.
             IF AVAIL tt-prog-ponto3 THEN DO:
                 CREATE tt-erro-local.
                 ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "Tabela de preco devera ser informada para cliente sales force. ".
                        l-erro            =  YES.
               
                 RETURN "NOK":U.
               
             END.

         END.
    END.

    IF  tt-ped-venda-arq.nat-operacao <> ""
    AND tt-ped-venda-arq.nat-operacao <> ? THEN DO:
    
        /*Chamado 102518, sΩ importa do arquivo as naturezas cadastradas no es0018*/
        IF  CAN-FIND (FIRST tt-prog-ponto
                      WHERE tt-prog-ponto.conteudo = tt-ped-venda-arq.nat-operacao) THEN DO:
            FIND FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao  = tt-ped-venda-arq.nat-operacao 
                   AND natur-oper.nat-operacao >= "500000" NO-ERROR.
       
            IF  AVAIL natur-oper THEN
                ASSIGN c-nat-oper = tt-ped-venda-arq.nat-operacao.
            
        END.
        ELSE DO:
            RUN defineNatOperacao IN h-boes505 (INPUT  estabelec.cod-estabel,
                                                INPUT  emitente.cod-emitente,
                                                INPUT  "padrao",
                                                INPUT  ITEM.it-codigo,
                                                INPUT  IF  tt-ped-venda-arq.destino = "Revenda" THEN NO ELSE YES,
                                                OUTPUT c-nat-oper,
                                                OUTPUT l-return).
    
            IF  NOT l-return THEN DO:
                CREATE tt-erro-local.
                ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "Natureza de operaªío p/ item nío encontrada para o cliente/estabelecimento " + STRING(emitente.cod-emitente) + " Estabelec " + estabelec.cod-estabel
                       l-erro           = YES.
    
                RETURN "NOK".
            END.
        END.
    END.
    ELSE DO:
    
        RUN defineNatOperacao IN h-boes505 (INPUT  estabelec.cod-estabel,
                                            INPUT  emitente.cod-emitente,
                                            INPUT  "padrao",
                                            INPUT  ITEM.it-codigo,
                                            INPUT  IF  tt-ped-venda-arq.destino = "Revenda" THEN NO ELSE YES,
                                            OUTPUT c-nat-oper,
                                            OUTPUT l-return).
    
        IF  NOT l-return THEN DO:
            CREATE tt-erro-local.
            ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "Natureza de operaªío p/ Item nío encontrada para o cliente/estabelecimento " + STRING(emitente.cod-emitente) + " Estabelec " + estabelec.cod-estabel
                   l-erro           = YES.
    
            RETURN "NOK".
        END.
    
    END.
    

    FIND FIRST natur-oper NO-LOCK
        WHERE  natur-oper.nat-operacao = c-nat-oper NO-ERROR.
    IF  NOT AVAIL natur-oper THEN DO:
        CREATE tt-erro-local.
        ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "Natureza de operaªío " + c-nat-oper + " invˇlido ou nío cadastrada, Cliente: " + STRING(emitente.cod-emitente) + " Estabelec " + estabelec.cod-estabel + " Item " + item.it-codigo
               l-erro           = YES.
        UNDO, LEAVE.
    END.

    IF  tt-ped-item-arq.qtd = 0 THEN DO:
        CREATE tt-erro-local.
        ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "Item com quantidade zerada  " + item.it-codigo + " Cliente " + STRING(emitente.cod-emitente)
               l-erro           = YES.
        UNDO, LEAVE.
    END.

    
    FIND LAST  tt-ped-item NO-LOCK
         WHERE tt-ped-item.nr-pedcli = tt-ped-venda.nr-pedcli NO-ERROR.
    IF  AVAIL  tt-ped-item THEN 
        ASSIGN i-sequencia = tt-ped-item.nr-sequencia.
    ELSE
        ASSIGN i-sequencia = 0.

        /* Atribuir Sequºncia do Item */
    ASSIGN i-sequencia                = i-sequencia + 10.


    CREATE tt-ped-item.
    ASSIGN tt-ped-item.nr-pedcli            = tt-ped-venda.nr-pedcli
           tt-ped-item.nome-abrev           = tt-ped-venda.nome-abrev
           tt-ped-item.it-codigo            = item.it-codigo
           tt-ped-item.aliquota-ipi         = item.aliquota-ipi
           tt-ped-item.des-un-medida        = item.un
           tt-ped-item.cod-entrega          = tt-ped-venda.cod-entrega
           OVERLAY(tt-ped-item.char-2,1,8)  = item.class-fiscal
           OVERLAY(tt-ped-item.char-2,56,5) = string(ITEM.cod-servico)
           tt-ped-item.nr-sequencia         = i-sequencia.      

    CREATE tt-ped-item-seq-parcela.
    ASSIGN tt-ped-item-seq-parcela.nr-pedcli    = tt-ped-venda.nr-pedcli 
           tt-ped-item-seq-parcela.nome-abrev   = tt-ped-venda.nome-abrev
           tt-ped-item-seq-parcela.it-codigo    = item.it-codigo         
           tt-ped-item-seq-parcela.nr-sequencia = i-sequencia
           tt-ped-item-seq-parcela.parcela      = iParcela 
           tt-ped-item-seq-parcela.dt-entrega   = dt-entrega. 

    /** Incidente 29678                 **/
    IF tt-ped-venda.cod-priori =  44 OR tt-ped-venda.tp-pedido  = '34' THEN 
        ASSIGN tt-ped-item.dt-entrega = dt-entrega.

    /* Se o preªo nío foi informado deverˇ buscar da tabela informada no pedido */

    /* Inicio busca preªo programa de canais */
     
    IF int-emitente.log-salesforce = NO THEN DO:
        IF  int-emitente.ind-participa-canais = 993520001  /* Participa canais */ 
        AND NOT tt-param.l-import-preco THEN DO:
            FIND FIRST ProdutoItem
                 WHERE ProdutoItem.CodigoProduto = tt-ped-item.it-codigo 
                   AND ProdutoItem.bloqueado     = FALSE NO-LOCK NO-ERROR.
           IF NOT AVAIL produtoitem THEN DO:
              CREATE tt-erro-local.
               ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "ITEM Nao encontrado NO portfolio " + item.it-codigo + " Cliente " + STRING(emitente.cod-emitente)
                      l-erro           = YES.
               UNDO, LEAVE.
    
           END.
           EMPTY TEMP-TABLE tt-itens.
           EMPTY TEMP-TABLE Resultado.
    
           FIND ITEM
               WHERE ITEM.it-codigo = tt-ped-item.it-codigo NO-LOCK NO-ERROR.
           FIND item-uni-estab
               WHERE item-uni-estab.cod-estabel = tt-ped-venda.cod-estabel
                 AND item-uni-estab.it-codigo   = tt-ped-item.it-codigo
               NO-LOCK NO-ERROR.
    
           FIND FIRST int-calculo-canal-item NO-LOCK
                WHERE int-calculo-canal-item.cod-guid    = int-emitente.cod-guid
                  AND int-calculo-canal-item.cod-estabel = tt-ped-venda.cod-estabel
                  AND int-calculo-canal-item.it-codigo   = tt-ped-item.it-codigo
                  AND int-calculo-canal-item.data-calculo = TODAY NO-ERROR.
           IF AVAIL int-calculo-canal-item THEN DO:
               ASSIGN de-valor = int-calculo-canal-item.valor-produto.
           END.
           ELSE DO:
               EMPTY TEMP-TABLE tt-itens.
               CREATE tt-itens.
               ASSIGN tt-itens.it-codigo              = tt-ped-item.it-codigo
                      tt-itens.de-quantidade          = tt-ped-item-arq.qtd
                      tt-itens.TipoPortfolio          = 993520005
                      tt-itens.CodigoUnidadeNegocio   = item-uni-estab.cod-unid-neg
                      tt-itens.CodigoFamiliaComercial = ITEM.fm-cod-com
                      tt-itens.CodigoEstabelecimento  = tt-ped-venda.cod-estabel.
    
               RUN esp/esb/out/msg0101.p (INPUT int-emitente.cod-guid,
                                          INPUT  TABLE tt-itens,
                                          OUTPUT TABLE ProdutoItemR,
                                          OUTPUT TABLE Resultado).
    
               FIND FIRST ProdutoItemR NO-ERROR.
               FIND FIRST Resultado    NO-ERROR.
    
               IF  AVAIL Resultado THEN DO:
               
                   IF Resultado.Sucesso THEN DO:
                       ASSIGN de-valor = ProdutoItemR.ValorComDesconto.
        
                       FIND FIRST int-calculo-canal-item EXCLUSIVE-LOCK
                            WHERE int-calculo-canal-item.cod-guid    = int-emitente.cod-guid
                              AND int-calculo-canal-item.cod-estabel = tt-ped-venda.cod-estabel
                              AND int-calculo-canal-item.it-codigo   = tt-ped-item.it-codigo NO-ERROR.
                       IF AVAIL int-calculo-canal-item THEN DO:
                           ASSIGN int-calculo-canal-item.valor-produto          = ProdutoItemR.ValorComDesconto
                                  int-calculo-canal-item.perc-descto-verde      = ProdutoItemR.PercentualDescontoVerde
                                  int-calculo-canal-item.perc-descto-top-milhao = ProdutoItemR.PercentualDescontoTopMilhao
                                  int-calculo-canal-item.perc-rebate-antec      = ProdutoItemR.PercentualRebateAntecipado
                                  int-calculo-canal-item.data-calculo           = TODAY.
                       END.
                       ELSE DO:
                           CREATE int-calculo-canal-item.
                           ASSIGN int-calculo-canal-item.cod-guid               = int-emitente.cod-guid   
                                  int-calculo-canal-item.cod-estabel            = tt-ped-venda.cod-estabel   
                                  int-calculo-canal-item.it-codigo              = ProdutoItemR.CodigoProduto
                                  int-calculo-canal-item.preco-base             = ProdutoItemR.PrecoBase
                                  int-calculo-canal-item.valor-produto          = ProdutoItemR.ValorComDesconto
                                  int-calculo-canal-item.tipo-portifolio        = 993520005
                                  int-calculo-canal-item.bloqueado              = NO
                                  int-calculo-canal-item.qtd-range              = ProdutoItemR.QuantidadeMaxima
                                  int-calculo-canal-item.log-calcrebate         = ProdutoItemR.CalcularRebate            
                                  int-calculo-canal-item.log-preco-alterado     = ProdutoItemR.PrecoAlterado             
                                  int-calculo-canal-item.log-rebate-antec       = ProdutoItemR.RebateAntecipado          
                                  int-calculo-canal-item.perc-descto-verde      = ProdutoItemR.PercentualDescontoVerde
                                  int-calculo-canal-item.perc-descto-top-milhao = ProdutoItemR.PercentualDescontoTopMilhao
                                  int-calculo-canal-item.perc-rebate-antec      = ProdutoItemR.PercentualRebateAntecipado
                                  int-calculo-canal-item.data-calculo           = TODAY.
                       END.
                       RELEASE int-calculo-canal-item.
                   END.
                   ELSE DO:
                       CREATE tt-erro-local.
                       ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "Valor CRM Sem resultado. Preªo calculado zerado  " + item.it-codigo + " Cliente " + STRING(emitente.cod-emitente)
                              l-erro           = YES.
                       UNDO, LEAVE.
                   END.
               END.
               ELSE DO:
                   CREATE tt-erro-local.
                   ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "Valor CRM Sem resultado. Preªo calculado zerado  " + item.it-codigo + " Cliente " + STRING(emitente.cod-emitente)
                          l-erro           = YES.
                   UNDO, LEAVE.
               END.
           END.    
           
           IF de-valor <> 0 THEN DO:
    
               IF NOT VALID-HANDLE (h-msg138a) THEN
                   RUN esp/esb/in/msg0138a.p PERSISTENT SET h-msg138a.
    
               RUN pi-calc-juros IN h-msg138a (INPUT  tt-ped-venda.cod-cond-pag,
                                               OUTPUT p-indice-financiamento,
                                               OUTPUT TABLE tt-erro).
    
    
               RUN pi-calcula-icms IN h-msg138a (INPUT  int-emitente.cod-guid,
                                                 INPUT  tt-ped-venda.cod-estabel,
                                                 INPUT  tt-ped-item.it-codigo,
                                                 OUTPUT de-perc-icms,
                                                 OUTPUT de-perc-desc-icms,
                                                 OUTPUT TABLE tt-erro).
    
               IF VALID-HANDLE(h-msg138a) THEN
                   DELETE PROCEDURE h-msg138a.
    
               IF  de-perc-desc-icms > 0 THEN
                   ASSIGN de-perc-desc-icms = ((100 - de-perc-desc-icms) / 100)
                          de-valor  = round(de-valor / de-perc-desc-icms,4).
    
               IF p-indice-financiamento = 0 THEN
                   ASSIGN tt-ped-item.vl-pretab           = (de-valor / ((100 - de-perc-icms) / 100)).
               ELSE DO:
    
                   RUN esp/pdp/espdp098.p(INPUT int-emitente.cod-guid,
                                          INPUT tt-ped-venda.cod-estabel ,
                                          INPUT tt-ped-item.it-codigo,
                                          INPUT de-valor,
                                          INPUT de-perc-icms,
                                          INPUT p-indice-financiamento,
                                          OUTPUT de-valor-item ).
    
                   IF de-valor-item <> 0 THEN
                       ASSIGN tt-ped-item.vl-pretab = de-valor-item.
                   ELSE IF (de-valor / ((100 - de-perc-icms) / 100)) * p-indice-financiamento <> 0 THEN
                            ASSIGN  tt-ped-item.vl-pretab       = (de-valor / ((100 - de-perc-icms) / 100)) * p-indice-financiamento.
                         ELSE DO:
                             CREATE tt-erro-local.
                             ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + "Valor CRM 0. Preªo nío encontrado - preco calculado zerado  " + item.it-codigo + " Cliente " + STRING(emitente.cod-emitente)
                                    l-erro           = YES.
                             UNDO, LEAVE.
                         END.
               END.
           END.
    /* Fim busca preªo programa de canais */
        END.
        ELSE
            IF  tt-ped-item-arq.preco = 0 THEN DO:
                FIND LAST preco-item NO-LOCK
                    WHERE preco-item.it-codigo  = tt-ped-item.it-codigo
                    AND   preco-item.nr-tabpre  = tt-ped-venda-arq.nr-tabpre
                    AND   preco-item.situacao   = 1
                    AND   preco-item.dt-inival <= TODAY NO-ERROR.
                IF  AVAIL preco-item THEN
                    ASSIGN tt-ped-item.vl-preori = preco-item.preco-venda
                           tt-ped-item.vl-pretab = preco-item.preco-venda.
            END.
            ELSE
                ASSIGN tt-ped-item.vl-pretab = tt-ped-item-arq.preco
                       tt-ped-item.vl-preori = tt-ped-item.vl-pretab.
    END.

     IF int-emitente.log-salesforce = YES THEN DO:
       
       CREATE mgesp.int-ped-item-pci. 
       ASSIGN int-ped-item-pci.nome-abrev   = tt-ped-venda.nome-abrev  
              int-ped-item-pci.nr-pedcli    = tt-ped-venda.nr-pedcli   
              int-ped-item-pci.it-codigo    = tt-ped-item.it-codigo    
              int-ped-item-pci.nr-sequencia = tt-ped-item.nr-sequencia 
              int-ped-item-pci.nr-tabpre    = tt-ped-item-arq.nr-tabpre.

      /* IF NOT tt-param.l-import-preco THEN DO:
          FIND LAST preco-item 
              WHERE preco-item.it-codigo  = tt-ped-item.it-codigo
                AND preco-item.nr-tabpre  = tt-ped-item-arq.nr-tabpre  //c-tab-preco 
                AND preco-item.cod-refer  = tt-ped-venda.cod-estabel
                and preco-item.dt-inival <= today    
                and preco-item.situacao   = 1 
                /*AND preco-item.quant-min  <= tt-ped-item-arq.qtd*/  NO-LOCK NO-ERROR.
         
          IF AVAIL preco-item THEN 
             ASSIGN tt-ped-item.vl-pretab      = tt-ped-item-arq.preco //preco-item.preco-venda
                    tt-ped-item.vl-preori      = tt-ped-item-arq.preco //preco-item.preco-venda.
          ELSE DO:
              CREATE tt-erro-local.
              ASSIGN tt-erro-local.mensagem = tt-ped-item-arq.linha + 
                  "Tabela de preªos informada nao possui preªo ativo para o item " + item.it-codigo + " TabPreªo " + tt-ped-item-arq.nr-tabpre
                     l-erro           = YES.
              UNDO, LEAVE.
          END. 
       END. */

       ASSIGN tt-ped-item.vl-pretab      = tt-ped-item-arq.preco //preco-item.preco-venda
              tt-ped-item.vl-preori      = tt-ped-item-arq.preco. //preco-item.preco-venda
              

       FIND FIRST cond-pagto
            WHERE cond-pagto.cod-cond-pag   = tt-ped-venda.cod-cond-pag NO-LOCK NO-ERROR.
       FIND FIRST tab-finan-indice NO-LOCK
            WHERE tab-finan-indice.nr-tab-finan = cond-pagto.nr-tab-finan
              AND tab-finan-indice.num-seq = cond-pagto.nr-ind-finan NO-ERROR.

       IF AVAIL tab-finan-indice THEN DO:
          ASSIGN  p-indice-financiamento = tab-finan-indice.tab-ind-fin.
       END.
        // APLICA INDICE DE FINANCIAMENTO NO PRECO 
        IF p-indice-financiamento <> 1 THEN DO:
           ASSIGN tt-ped-item.vl-pretab      = /*preco-item.preco-venda*/ tt-ped-item.vl-pretab * p-indice-financiamento
                  tt-ped-item.vl-preori      = /*preco-item.preco-venda*/ tt-ped-item.vl-preori * p-indice-financiamento.
        END.
        
        // APLICA NO PRECO O FATOR DE DESCONTO ACRESCIMO DO CLIENTE 
        ASSIGN de-fator-cli = 0.
        RUN pi-busca-desconto-cliente (INPUT tt-ped-venda.cod-emitente,
                                       INPUT tt-ped-item-arq.nr-tabpre,
                                       INPUT tt-ped-item-arq.it-codigo,
                                       OUTPUT de-fator-cli).
        
        IF de-fator-cli <> 0 THEN DO:
           ASSIGN tt-ped-item.vl-pretab      =  /*preco-item.preco-venda*/ tt-ped-item.vl-pretab * de-fator-cli
                  tt-ped-item.vl-preori      =  /*preco-item.preco-venda*/ tt-ped-item.vl-preori * de-fator-cli.
        END.

       FOR EACH int-beneficio-conta NO-LOCK
           WHERE int-beneficio-conta.cod-emitente      = tt-ped-venda.cod-emitente
             AND int-beneficio-conta.log-ativo         = YES
             AND int-beneficio-conta.log-bloq-infracao = NO:

           FIND FIRST ITEM
                WHERE ITEM.it-codigo = tt-ped-item.it-codigo NO-LOCK NO-ERROR.

           IF int-beneficio-conta.segmento-produto = SUBSTR(ITEM.fm-cod-com,1,4) AND 
              int-beneficio-conta.familia-produto  = SUBSTR(item.fm-cod-com,1,5) THEN
              RUN pi-desconto.

           IF int-beneficio-conta.segmento-produto = SUBSTR(ITEM.fm-cod-com,1,4) AND 
              int-beneficio-conta.familia-produto  = '' THEN
              RUN pi-desconto.

           IF int-beneficio-conta.segmento-produto = '' AND 
              int-beneficio-conta.familia-produto  = '' THEN
              RUN pi-desconto.

       END.

       FIND FIRST mgesp.int-ped-item-pci                                   
            WHERE int-ped-item-pci.nome-abrev   = tt-ped-venda.nome-abrev   
              AND int-ped-item-pci.nr-pedcli    = tt-ped-venda.nr-pedcli    
              AND int-ped-item-pci.it-codigo    = tt-ped-item.it-codigo     
              AND int-ped-item-pci.nr-sequencia = tt-ped-item.nr-sequencia  NO-LOCK NO-ERROR.
     
       IF dec(tt-ped-item-arq.pc-desc) > 0 THEN 
          ASSIGN tt-ped-item.des-pct-desconto-inform = STRING(tt-ped-item-arq.pc-desc).

       IF tt-ped-item.des-pct-desconto-inform <> '' AND 
           int-ped-item-pci.desc-topmilhao > 0 THEN 
           ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform + '+'.
        IF dec(int-ped-item-pci.desc-topmilhao) > 0 THEN
           ASSIGN tt-ped-item.des-pct-desconto-inform  = tt-ped-item.des-pct-desconto-inform + string(int-ped-item-pci.desc-topmilhao).
        IF tt-ped-item.des-pct-desconto-inform <> '' AND 
           int-ped-item-pci.desc-maisverde > 0 THEN 
           ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform + '+'.
        IF dec(int-ped-item-pci.desc-maisverde) > 0 THEN
           ASSIGN tt-ped-item.des-pct-desconto-inform  = tt-ped-item.des-pct-desconto-inform + string(int-ped-item-pci.desc-maisverde).
        IF tt-ped-item.des-pct-desconto-inform <> '' AND 
           int-ped-item-pci.desc-focounid > 0 THEN 
           ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform + '+'.
        IF dec(int-ped-item-pci.desc-focounid) > 0 THEN
           ASSIGN tt-ped-item.des-pct-desconto-inform  = tt-ped-item.des-pct-desconto-inform + string(int-ped-item-pci.desc-focounid).
        IF tt-ped-item.des-pct-desconto-inform <> '' AND 
           int-ped-item-pci.desc-distrib > 0 THEN 
           ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform + '+'.
        IF dec(int-ped-item-pci.desc-distrib) > 0 THEN
           ASSIGN tt-ped-item.des-pct-desconto-inform   = tt-ped-item.des-pct-desconto-inform + string(int-ped-item-pci.desc-distrib20).
        IF tt-ped-item.des-pct-desconto-inform <> '' AND 
           int-ped-item-pci.desc-widecloud > 0 THEN 
           ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform + '+'.
        IF dec(int-ped-item-pci.desc-widecloud) > 0 THEN
           ASSIGN tt-ped-item.des-pct-desconto-inform  = tt-ped-item.des-pct-desconto-inform + string(int-ped-item-pci.desc-widecloud).

    END.
    ELSE DO:
        IF dec(tt-ped-item-arq.pc-desc) > 0 THEN 
          ASSIGN tt-ped-item.des-pct-desconto-inform = STRING(tt-ped-item-arq.pc-desc).
    END.



    IF l-log = YES THEN
        PUT "Natureza ITEM " natur-oper.nat-operacao SKIP.

    ASSIGN tt-ped-item.vl-preori               = tt-ped-item.vl-pretab
           tt-ped-item.qt-pedida               = tt-ped-item-arq.qtd
           tt-ped-item.qt-un-fat               = tt-ped-item.qt-pedida
           tt-ped-item.cod-sit-item            = tt-ped-venda.cod-sit-ped
           tt-ped-item.cod-sit-pre             = tt-ped-venda.cod-sit-pre
           tt-ped-item.dt-entorig              = tt-ped-venda.dt-entorig
           tt-ped-item.dt-userimp              = tt-ped-venda.dt-userimp
           tt-ped-item.esp-ped                 = 1
           tt-ped-item.nat-operacao            = natur-oper.nat-operacao
           tt-ped-item.per-des-icms            = natur-oper.per-des-icms
           tt-ped-item.tp-adm-lote             = 1
           tt-ped-item.tp-preco                = 0
           tt-ped-item.user-impl               = tt-ped-venda.user-impl
           tt-ped-item.log-usa-tabela-desconto = NO
           tt-ped-item.per-minfat              = IF AVAIL emitente THEN emitente.per-minfat ELSE tt-ped-item.per-minfat
           tt-ped-item.cd-origem               = 2
           tt-ped-item.tipo-atend              = IF item.baixa-estoq = NO OR tt-ped-venda.ind-fat-par THEN 2 ELSE 1.

    CREATE tt-int-ped-item.
    ASSIGN tt-int-ped-item.nome-abrev    = tt-ped-item.nome-abrev
           tt-int-ped-item.nr-pedcli     = tt-ped-item.nr-pedcli
           tt-int-ped-item.nr-sequencia  = tt-ped-item.nr-sequencia
           tt-int-ped-item.it-codigo     = tt-ped-item.it-codigo.

    release int-segmento-item.

    if avail emitente
    then for FIRST int-segmento-item
             WHERE int-segmento-item.it-codigo  = tt-ped-item.it-codigo
               AND int-segmento-item.cod-gr-cli = emitente.cod-gr-cli
                   no-lock: end.

    create tt-int-ped-item-pci.
    assign tt-int-ped-item-pci.nome-abrev   = tt-ped-item.nome-abrev
           tt-int-ped-item-pci.nr-pedcli    = tt-ped-item.nr-pedcli
           tt-int-ped-item-pci.nr-sequencia = tt-ped-item.nr-sequencia
           tt-int-ped-item-pci.it-codigo    = tt-ped-item.it-codigo
           tt-int-ped-item-pci.cod-refer    = tt-ped-item.cod-refer
           tt-int-ped-item-pci.cod-repres   = if tt-ped-item-arq.cod-repres <> ""
                                              then inte(tt-ped-item-arq.cod-repres)
                                              else inte(tt-ped-venda-arq.cod-repres)
           tt-int-ped-item-pci.cod-segmento = int-segmento-item.cod-segmento when avail int-segmento-item.
    find current tt-int-ped-item-pci no-error.
    release tt-int-ped-item-pci.
           
    IF  tt-ped-venda-arq.destino = "Revenda"  then do:
        IF  NOT VALID-HANDLE(h-bodi154sdf) THEN
            RUN dibo/bodi154sdf.p PERSISTENT SET h-bodi154sdf.
    
        IF  AVAIL emitente   AND
            AVAIL natur-oper THEN DO:
            RUN setICMRetido IN h-bodi154sdf (INPUT  tt-ped-item.nome-abrev,
                                              INPUT  tt-ped-item.cod-entrega,
                                              INPUT  tt-ped-item.it-codigo,
                                              INPUT  tt-ped-venda.cod-estabel,
                                              INPUT  emitente.insc-subs-trib,
                                              INPUT  natur-oper.subs-trib,
                                              OUTPUT tt-ped-item.ind-icm-ret).  
        END.
        DELETE PROCEDURE h-bodi154sdf.
        /* Fim Busca Indicador ICMS Ret */    
    end .


    /* Definiªío do Valor Unitˇrio com Desconto ZFM */
    IF  natur-oper.per-des-icm > 0 THEN
        ASSIGN tt-ped-item.vl-preuni = tt-ped-item.vl-preori - (tt-ped-item.vl-preori * (natur-oper.per-des-icm / 100)) WHEN AVAIL natur-oper.
    ELSE
        ASSIGN tt-ped-item.vl-preuni = tt-ped-item.vl-preori.

    ASSIGN tt-ped-item.vl-liq-it   = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni
           tt-ped-item.vl-merc-abe = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni.


    /* Tratamento IPI */
    IF  item.cd-trib-ipi       = 1  AND   /* Tributado */
       (natur-oper.cd-trib-ipi = 1  OR    /* Tributado */
        natur-oper.cd-trib-ipi = 4) THEN  /* Reduzido  */
        ASSIGN tt-ped-item.vl-liq-abe = tt-ped-item.vl-liq-it + (tt-ped-item.vl-liq-it * tt-ped-item.aliquota-ipi / 100).
    ELSE
        ASSIGN tt-ped-item.vl-liq-abe = tt-ped-item.vl-liq-it.

    ASSIGN tt-ped-item.vl-tot-it = tt-ped-item.vl-liq-abe.

    
    CREATE tt-ped-ent.
    ASSIGN tt-ped-ent.nr-pedcli    = tt-ped-item.nr-pedcli
           tt-ped-ent.cod-sit-ent  = tt-ped-item.cod-sit-item
           tt-ped-ent.cod-sit-pre  = tt-ped-item.cod-sit-pre
           tt-ped-ent.dt-entorig   = tt-ped-item.dt-entorig
           tt-ped-ent.dt-entrega   = dt-entrega
           tt-ped-ent.dt-userimp   = tt-ped-item.dt-userimp
           tt-ped-ent.it-codigo    = tt-ped-item.it-codigo
           tt-ped-ent.nome-abrev   = tt-ped-item.nome-abrev
           tt-ped-ent.qt-pedida    = tt-ped-item.qt-pedida
           tt-ped-ent.user-impl    = tt-ped-item.user-impl
           tt-ped-ent.vl-liq-it    = tt-ped-item.vl-liq-it
           tt-ped-ent.nr-sequencia = tt-ped-item.nr-sequencia
           tt-ped-ent.vl-liq-abe   = tt-ped-item.vl-liq-abe.

    /* Atribuir Valores Totais do Pedido */
    ASSIGN d-vl-liq-it  = d-vl-liq-it  + tt-ped-item.vl-liq-it
           d-vl-liq-abe = d-vl-liq-abe + tt-ped-item.vl-liq-abe.
END PROCEDURE. //CriaItemReceitaRecorrente



PROCEDURE pi-executar-bos:
    DEFINE INPUT  PARAMETER p-desc-suspend AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER l-erro         AS LOGICAL     NO-UNDO.

    DEFINE VARIABLE i-cod-gr-canais        AS INT NO-UNDO.

    EMPTY TEMP-TABLE tt-ped-venda-aux.

    CREATE tt-ped-venda-aux.
    BUFFER-COPY tt-ped-venda TO tt-ped-venda-aux.
    
    FIND FIRST tt-param NO-ERROR.

    bloco:
    DO  TRANSACTION ON ERROR  UNDO bloco, LEAVE bloco
                    ON ENDKEY UNDO bloco, LEAVE bloco:

        RUN pi-acompanhar IN h-acomp (INPUT "Efetivando pedido...").

        IF  NOT VALID-HANDLE(h-bodi159) THEN
            RUN dibo/bodi159.p PERSISTENT SET h-bodi159.

        RUN openQueryStatic IN h-bodi159(INPUT "Main":U).
        RUN setRecord       IN h-bodi159(INPUT TABLE tt-ped-venda-aux).
        RUN emptyRowErrors  IN h-bodi159.
        RUN createMPLog     IN h-bodi159(INPUT NO).
        RUN createRecord    IN h-bodi159.
        RUN getRowErrors    IN h-bodi159(OUTPUT TABLE RowErrors).

        FOR EACH  RowErrors NO-LOCK
            WHERE RowErrors.ErrorType   <> "INTERNAL":U
            AND   RowErrors.ErrorSubType = "Error":U:
            CREATE tt-erro-local.
            ASSIGN tt-erro-local.mensagem = tt-ped-venda-arq.linha +  "Erro BO => " + RowErrors.errorDescription  + " Cliente: " + tt-ped-venda-aux.nome-abrev + " - " + string(tt-ped-venda-aux.cod-emitente)
                   l-erro           = YES.
        END.

        IF  l-erro  THEN
            UNDO bloco, LEAVE bloco.

        
        IF  NOT VALID-HANDLE(h-bodi157) THEN
            RUN dibo/bodi157.p PERSISTENT SET h-bodi157.
        RUN openQueryStatic IN h-bodi157(INPUT "Default":U).

        FOR EACH tt-ped-repre
            WHERE tt-ped-repre.nr-pedido = tt-ped-venda-aux.nr-pedido:

            RUN emptyRowErrors  IN h-bodi157.
            RUN setRecord       IN h-bodi157(INPUT TABLE tt-ped-repre).
            RUN createMPLog     IN h-bodi157(INPUT NO).
            RUN createRecord    IN h-bodi157.
            RUN getRowErrors    IN h-bodi157(OUTPUT TABLE RowErrors).

            FOR EACH  RowErrors NO-LOCK
                WHERE RowErrors.ErrorType   <> "INTERNAL":U
                AND   RowErrors.ErrorSubType = "Error":U:
                CREATE tt-erro-local.
                ASSIGN tt-erro-local.mensagem = tt-ped-venda-arq.linha + "Erro BO => "  + RowErrors.errorDescription + " Repres: " + tt-ped-repre.nome-ab-rep
                       l-erro           = YES.
            END.
            DELETE tt-ped-repre.
        END.

        IF  l-erro THEN
            UNDO bloco, LEAVE bloco.        

        RUN pi-acompanhar IN h-acomp (INPUT "Efetivando itens...").

        IF  NOT VALID-HANDLE(h-bodi154) THEN
            RUN dibo/bodi154.p PERSISTENT SET h-bodi154.
        RUN openQueryStatic IN h-bodi154(INPUT "Default":U).

        FOR EACH  tt-ped-item NO-LOCK
            WHERE tt-ped-item.nr-pedcli = tt-ped-venda.nr-pedcli:

       // IF tt-param.l-receita-recorrente = NO THEN DO: 
                /* DATA ENTREGA DO ITEM */
                FIND int-ped-venda2 NO-LOCK
                    WHERE int-ped-venda2.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.
                
                FIND FIRST item-dt-entrega NO-LOCK
                    WHERE item-dt-entrega.it-codigo = tt-ped-item.it-codigo 
                      AND item-dt-entrega.cod-gr-canais = IF AVAIL int-ped-venda2 THEN int-ped-venda2.int-1 ELSE 0 NO-ERROR.
                
                IF NOT AVAIL item-dt-entrega THEN DO:
    
                    ASSIGN i-cod-gr-canais = 0.
            
                    FIND FIRST atendente
                         WHERE atendente.cd-oper = int(tt-ped-venda.tp-pedido) NO-LOCK NO-ERROR.
                    IF AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN DO:
                        ASSIGN i-cod-gr-canais = atendente.cod-gr-canais.
                    END. /* IF AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN DO: */
                    ELSE DO:
                        FIND FIRST emitente
                             WHERE emitente.cod-emitente = tt-ped-venda.cod-emitente NO-LOCK NO-ERROR.
                        IF  AVAIL emitente THEN DO:
                            FIND FIRST grupo-canais-clientes
                                 WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
                            IF AVAIL grupo-canais-clientes THEN DO:
                                ASSIGN i-cod-gr-canais = grupo-canais-clientes.cod-gr-canais.
                            END.
                        END.
                    END. /* IF NOT AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN DO: */
            
                    FIND LAST item-dt-entrega NO-LOCK
                        WHERE item-dt-entrega.it-codigo = tt-ped-item.it-codigo 
                          AND item-dt-entrega.cod-gr-canais = i-cod-gr-canais NO-ERROR.
                END.


                IF AVAIL item-dt-entrega
                     AND item-dt-entrega.dt-entrega-futura > TODAY 
                     AND tt-ped-venda.dt-entrega           < item-dt-entrega.dt-entrega-futura THEN DO:
    
                     FOR FIRST ponto-programa NO-LOCK
                         WHERE ponto-programa.nome-programa = "espdp079"
                           AND ponto-programa.ponto         = 3:
                     END.
                     FIND FIRST conteudo-programa NO-LOCK
                          WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                            AND conteudo-programa.conteudo     = tt-ped-venda.tp-pedido NO-ERROR.
                     IF AVAIL conteudo-programa THEN
                         ASSIGN tt-ped-item.dt-entrega = tt-ped-venda.dt-entrega.
                     ELSE
                         ASSIGN tt-ped-item.dt-entrega = item-dt-entrega.dt-entrega-futura
                                tt-ped-item.dt-entorig = item-dt-entrega.dt-entrega-futura. 

                END.
                
                //Reatribui data de entrega conforme receita recorrente
                IF tt-param.l-receita-recorrente = YES THEN DO:

                    FIND FIRST tt-ped-item-seq-parcela WHERE tt-ped-item-seq-parcela.nr-pedcli    = tt-ped-item.nr-pedcli
                                                         AND tt-ped-item-seq-parcela.nr-sequencia = tt-ped-item.nr-sequencia
                                                         AND tt-ped-item-seq-parcela.it-codigo    = tt-ped-item.it-codigo NO-ERROR.
                    IF AVAIL tt-ped-item-seq-parcela THEN DO:
                       ASSIGN tt-ped-item.dt-entrega = tt-ped-item-seq-parcela.dt-entrega .
                    END.

                END.


            //IDBA Bruno - 24/05/2024 => Chamado - C2403-2860
             IF l-mantem-data-espdp079 = YES THEN DO:
                 ASSIGN tt-ped-item.dt-entrega = tt-ped-venda.dt-entrega .
             END.

           // END. //IF tt-param.l-receita-recorrente = NO
           
            EMPTY TEMP-TABLE tt-prog-ponto.
            RUN esp/es0018p.p (INPUT  "espdp079":U,
                               INPUT  5,
                               INPUT  0,
                               INPUT  "":U,
                               OUTPUT TABLE tt-prog-ponto).
            FIND FIRST tt-prog-ponto  NO-ERROR.
            IF tt-ped-item.dt-entrega > TODAY + (365 * int(tt-prog-ponto.conteudo)) THEN DO:
                CREATE tt-erro-local.
                ASSIGN tt-erro-local.mensagem = tt-ped-venda-arq.linha +  "Data de entrega do item " + tt-ped-item.it-codigo + " superior a " + tt-prog-ponto.conteudo + " anos" .
                       l-erro           = YES.
            END.

            RUN emptyRowErrors  IN h-bodi154.
            RUN setRecord       IN h-bodi154(INPUT TABLE tt-ped-item).
            RUN createMPLog     IN h-bodi154(INPUT NO).
            RUN createRecord    IN h-bodi154.
            RUN getRowErrors    IN h-bodi154(OUTPUT TABLE RowErrors).

            FOR EACH  RowErrors NO-LOCK
                WHERE RowErrors.ErrorType   <> "INTERNAL":U
                AND   RowErrors.ErrorSubType = "Error":U:
                CREATE tt-erro-local.
                ASSIGN tt-erro-local.mensagem = tt-ped-venda-arq.linha +  "Erro BO => " + RowErrors.errorDescription + " Item: " + tt-ped-item.it-codigo
                       l-erro           = YES.
            END.

            DELETE tt-ped-item.
        END.

        IF  l-erro  THEN
            UNDO bloco, LEAVE bloco.


        FIND FIRST ped-venda Exclusive-LOCK
             WHERE ped-venda.nr-pedcli  = tt-ped-venda-aux.nr-pedcli
               AND ped-venda.nome-abrev = tt-ped-venda-aux.nome-abrev NO-ERROR.
               
        IF AVAIL ped-venda THEN 
            ASSIGN ped-venda.completo = NO.
               
        /**** Efetiva as Tabelas Espec°ficas ****/
        /* Pedido */
        FIND FIRST tt-int-ped-venda NO-LOCK
            WHERE  tt-int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-ERROR.
        IF  AVAIL  tt-int-ped-venda THEN DO:
        
            RUN pi-acompanhar IN h-acomp (INPUT "Atualizando Tabelas Especificas...int-ped-venda").
        
            FIND FIRST int-ped-venda EXCLUSIVE-LOCK
                WHERE  int-ped-venda.nr-pedido   = tt-int-ped-venda.nr-pedido NO-ERROR.
            IF  NOT AVAIL int-ped-venda THEN DO:
                CREATE int-ped-venda.
                ASSIGN int-ped-venda.nr-pedido   = tt-int-ped-venda.nr-pedido.
            END.

            ASSIGN int-ped-venda.cod-estabel          = tt-int-ped-venda.cod-estabel
                   int-ped-venda.dt-negociacao        = tt-int-ped-venda.dt-negociacao
                   int-ped-venda.dias-negociacao      = tt-int-ped-venda.dias-negociacao
                   int-ped-venda.vl-guid              = tt-int-ped-venda.vl-guid
                   int-ped-venda.char-1               = tt-int-ped-venda.char-1
                   int-ped-venda.nr-contrato          = tt-int-ped-venda.nr-contrato .
            RELEASE int-ped-venda.
        END.

        /* Itens Pedido */
        FOR EACH  ped-item NO-LOCK
            WHERE ped-item.nome-abrev = ped-venda.nome-abrev
              AND ped-item.nr-pedcli  = ped-venda.nr-pedcli:
              
              RUN pi-acompanhar IN h-acomp (INPUT "Atualizando Tabelas Especificas...int-ped-item").

            /* Efetivaá∆o das Tabelas de Extens∆o */
            FIND FIRST tt-int-ped-item NO-LOCK
                WHERE  tt-int-ped-item.nome-abrev   = ped-item.nome-abrev
                AND    tt-int-ped-item.nr-pedcli    = ped-item.nr-pedcli
                AND    tt-int-ped-item.nr-sequencia = ped-item.nr-sequencia
                AND    tt-int-ped-item.it-codigo    = ped-item.it-codigo NO-ERROR.
            IF  AVAIL  tt-int-ped-item THEN DO:
                FIND FIRST int-ped-item EXCLUSIVE-LOCK
                    WHERE  int-ped-item.nome-abrev   = ped-item.nome-abrev
                    AND    int-ped-item.nr-pedcli    = ped-item.nr-pedcli
                    AND    int-ped-item.nr-sequencia = ped-item.nr-sequencia
                    AND    int-ped-item.it-codigo    = ped-item.it-codigo
                    AND    int-ped-item.cod-refer    = ped-item.cod-refer NO-ERROR.
                IF  NOT AVAIL int-ped-item THEN DO:
                    CREATE int-ped-item.
                    ASSIGN int-ped-item.nome-abrev   = ped-item.nome-abrev
                           int-ped-item.nr-pedcli    = ped-item.nr-pedcli
                           int-ped-item.nr-sequencia = ped-item.nr-sequencia
                           int-ped-item.it-codigo    = ped-item.it-codigo
                           int-ped-item.cod-refer    = ped-item.cod-refer.
                    //IDBA Bruno 22/08/2023
                    //Se for receita recorrente vamos salvar o campo parcela na int-ped-item
                    IF tt-param.l-receita-recorrente = YES THEN DO :
                        FIND FIRST tt-ped-item-seq-parcela WHERE tt-ped-item-seq-parcela.nr-pedcli    = ped-item.nr-pedcli    
                                                             AND tt-ped-item-seq-parcela.nr-sequencia = ped-item.nr-sequencia 
                                                             AND tt-ped-item-seq-parcela.it-codigo    = ped-item.it-codigo NO-ERROR.
                        IF AVAIL tt-ped-item-seq-parcela THEN DO:
                            /*
                            MESSAGE "tt-ped-item-seq-parcela.nr-pedcli  "  tt-ped-item-seq-parcela.nr-pedcli   skip 
                                    "tt-ped-item-seq-parcela.nome-abrev "  tt-ped-item-seq-parcela.nome-abrev  skip
                                    "tt-ped-item-seq-parcela.it-codigo  "  tt-ped-item-seq-parcela.it-codigo   skip
                                    "tt-ped-item-seq-parcela.nr-sequencia " tt-ped-item-seq-parcela.nr-sequencia
                                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                                */

                            ASSIGN int-ped-item.nr-parcela-recor = tt-ped-item-seq-parcela.parcela .
                        END.
                    END.

                END.

                ASSIGN int-ped-item.vl-guid       = tt-int-ped-item.vl-guid
                       int-ped-item.it-codigo-pai = tt-int-ped-item.it-codigo-pai.

                FIND CURRENT int-ped-item NO-LOCK NO-ERROR.
                RELEASE int-ped-item.
            END. /* IF  AVAIL  tt-int-ped-item */

            for FIRST tt-int-ped-item-pci
                WHERE tt-int-ped-item-pci.nome-abrev   = ped-item.nome-abrev
                  AND tt-int-ped-item-pci.nr-pedcli    = ped-item.nr-pedcli
                  AND tt-int-ped-item-pci.nr-sequencia = ped-item.nr-sequencia
                  AND tt-int-ped-item-pci.it-codigo    = ped-item.it-codigo
                  and tt-int-ped-item-pci.cod-refer    = ped-item.cod-refer:
                for FIRST mgesp.int-ped-item-pci
                    WHERE int-ped-item-pci.nome-abrev   = ped-item.nome-abrev
                      AND int-ped-item-pci.nr-pedcli    = ped-item.nr-pedcli
                      AND int-ped-item-pci.nr-sequencia = ped-item.nr-sequencia
                      AND int-ped-item-pci.it-codigo    = ped-item.it-codigo
                      AND int-ped-item-pci.cod-refer    = ped-item.cod-refer
                          exclusive-lock: end.

                IF NOT AVAIL int-ped-item-pci 
                THEN DO:
                     CREATE mgesp.int-ped-item-pci.
                     ASSIGN int-ped-item-pci.nome-abrev   = ped-item.nome-abrev
                            int-ped-item-pci.nr-pedcli    = ped-item.nr-pedcli
                            int-ped-item-pci.nr-sequencia = ped-item.nr-sequencia
                            int-ped-item-pci.it-codigo    = ped-item.it-codigo
                            int-ped-item-pci.cod-refer    = ped-item.cod-refer.
                END.

                ASSIGN int-ped-item-pci.cod-repres   = tt-int-ped-item-pci.cod-repres
                       int-ped-item-pci.cod-segmento = tt-int-ped-item-pci.cod-segmento.

                FIND CURRENT mgesp.int-ped-item-pci NO-LOCK NO-ERROR.
                RELEASE int-ped-item-pci.
            end. /* for FIRST tt-int-ped-item-pci */
        END. 
        
        RUN pi-acompanhar IN h-acomp (INPUT "Completando pedido...").

        IF tt-ped-venda-arq.num-dias-parc <> "" AND tt-ped-venda.cod-cond-pag = 0 THEN DO:

           ASSIGN i-num-dias = int(ENTRY(1,tt-ped-venda-arq.num-dias-parc,"/"))
                  i-nr-parc  = int(ENTRY(2,tt-ped-venda-arq.num-dias-parc,"/")).

            /*IF tt-int-ped-venda.dias-negociacao <> 0 THEN
                ASSIGN d-dias-parcela = tt-int-ped-venda.dias-negociacao.
            ELSE */
                ASSIGN d-dias-parcela = i-num-dias.

            DO i-parcela = 1 TO i-nr-parc : 

                 CREATE cond-ped.
                 ASSIGN cond-ped.nr-pedido    = ped-venda.nr-pedido
                        cond-ped.nr-sequencia = i-parcela * 10
                        //cond-ped.data-pagto   = d-data-parcela
                        cond-ped.nr-dias-venc  = d-dias-parcela
                        cond-ped.observacoes   = "".

                 IF i-parcela = i-nr-parc THEN DO: //ultima parcela
                     ASSIGN d-resto-parcela     = round(100 - d-perc-parcela,2)
                            cond-ped.perc-pagto = d-resto-parcela.
                 END.
                 ELSE DO:
                     ASSIGN d-perc-parcela      = d-perc-parcela + ROUND((100 / i-nr-parc),2)
                            cond-ped.perc-pagto = ROUND((100 / i-nr-parc),2).
                 END.

                 ASSIGN d-dias-parcela   = d-dias-parcela + i-num-dias.
            END. 
        END.
        ELSE DO:
            IF tt-ped-venda-arq.dt-cond-espec <> ? THEN DO:
                CREATE cond-ped.
                ASSIGN cond-ped.nr-pedido    = ped-venda.nr-pedido
                       cond-ped.nr-sequencia = 10
                       cond-ped.data-pagto   = tt-ped-venda-arq.dt-cond-espec
                       cond-ped.perc-pagto   = 100
                       cond-ped.observacoes  = "".
            END.
        END.

        IF tt-param.l-efetiva-pedido THEN DO:
            IF l-log = YES THEN
                PUT "Antes Completar " ped-venda.nr-pedcli " " ped-venda.completo SKIP.

            /*completa Pedido*/
            IF  NOT VALID-HANDLE(h-bodi159com) THEN
                RUN dibo/bodi159com.p PERSISTENT SET h-bodi159com.
            RUN completeOrder IN h-bodi159com (INPUT ROWID(ped-venda) , 
                                               OUTPUT TABLE RowErrors).  
                                               
            FOR EACH  rowErrors NO-LOCK
                WHERE rowErrors.errornumber <> 8259:  /* credito n∆o aprovado */
                CREATE tt-erro-local.
                ASSIGN tt-erro-local.mensagem = tt-ped-venda-arq.linha +  "Erro BO => " + RowErrors.errorDescription + " Cliente: " + ped-venda.nome-abrev + " Pedido: " + ped-venda.nr-pedcli.
    
                /*IF  rowErrors.errorSubType <> "Warning":U THEN
                    ASSIGN l-erro = YES.*/
            END.
            
        END. /*IF l-efetiva-pedido THEN DO:*/
        ELSE DO:

            if not valid-handle(h-bodi159cal) or
               h-bodi159cal:type <> "PROCEDURE":U or
               h-bodi159cal:file-name <> "dibo/bodi159cal.p" then
                run dibo/bodi159cal.p persistent set h-bodi159cal.
        
            IF ped-venda.completo = NO THEN
                run calculateOrder in h-bodi159cal(input ROWID(ped-venda)).

        END.

        IF  l-erro THEN
            UNDO bloco, LEAVE bloco.

        IF AVAIL ped-venda THEN
            PUT UNFORMATTED "Pedido gerado: " ped-venda.nr-pedido  SKIP.
           // PUT UNFORMATTED "Nat-oper -> " + ped-venda.nat-oper SKIP.

       /*IF  l-erro  = NO THEN DO:
            /* Retorna o n£mero do pedido gerado para o Portal B2B */

            FIND FIRST tt-erro-local
                WHERE tt-erro-local.mensagem BEGINS "##" EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL tt-erro-local THEN
                ASSIGN tt-erro-local.mensagem = "## Pedidos: " + c-lista-pedidos.
            ELSE
               CREATE tt-erro-local.
               ASSIGN tt-erro-local.mensagem = "## Pedidos: " + c-lista-pedidos.


            /*ASSIGN tt-erro-local.mensagem = "## Pedido: " + STRING(ped-venda.nr-pedido).*/

                PUT UNFORMATTED "Pedido gerado: " ped-venda.nr-pedido SKIP.
            ASSIGN c-lista-pedidos = "".
        END.*/
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-desconto:

   CASE int-beneficio-conta.nome-beneficio: 
       WHEN 'Top Milh∆o'                THEN ASSIGN mgesp.int-ped-item-pci.desc-topmilhao  = int-beneficio-conta.perc-desconto / 100.
       WHEN 'Mais Verde  '              THEN ASSIGN int-ped-item-pci.desc-maisverde  = int-beneficio-conta.perc-desconto / 100.
       WHEN 'Foco na Unidade'           THEN ASSIGN int-ped-item-pci.desc-focounid   = int-beneficio-conta.perc-desconto / 100.
       WHEN 'Distribuidor 2.0'          THEN ASSIGN int-ped-item-pci.desc-distrib    = int-beneficio-conta.perc-desconto / 100.
       WHEN 'Wide Cloud'                THEN ASSIGN int-ped-item-pci.desc-widecloud  = int-beneficio-conta.perc-desconto / 100.
   END.
END PROCEDURE.

PROCEDURE pi-destroi-handles:

    IF  VALID-HANDLE(h-bodi154) THEN DO:
        RUN destroyBO IN h-bodi154.
        ASSIGN h-bodi154 = ?.
    END.

    IF  VALID-HANDLE(h-bodi157) THEN DO:
        DELETE PROCEDURE h-bodi157.
        ASSIGN h-bodi157 = ?.
    END.

    IF  VALID-HANDLE(h-bodi159) THEN DO:
        RUN destroyBO IN h-bodi159.
        ASSIGN h-bodi159 = ?.
    END.

    IF  VALID-HANDLE(h-bodi159com) THEN DO:
        RUN destroyBO IN h-bodi159com.
        ASSIGN h-bodi159com = ?.
    END.

    IF  VALID-HANDLE(h-bodi159sus) THEN DO:
        RUN destroyBO in h-bodi159sus.
        ASSIGN h-bodi159sus = ?.
    END.

    IF  VALID-HANDLE(h-boes505) THEN
        DELETE PROCEDURE h-boes505.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-busca-desconto-cliente:
    {esp/wso/eswso0010.i1}
END PROCEDURE.
