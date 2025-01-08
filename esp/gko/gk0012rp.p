/*****************************************************************************
**
**     Objetivo: Notas Fiscais de Saida do EMS para GKO
** 
**     Versao..: 2.00.00.000
**     Autor: hoepers - 15/03/2012
*****************************************************************************/
{include/i-prgvrs.i gk0012 2.00.00.000}

{esp/es0018.i}
{esp/gko/gk0012tt.i}
{esp/gko/gkapi012.i}

   

def temp-table tt-raw-digita
    field raw-digita as raw.

DEF TEMP-TABLE tt-cliente NO-UNDO
    FIELD cod-emitente LIKE emitente.cod-emitente
    FIELD cod-estabel  LIKE estabelec.cod-estabel
    INDEX id-emitente
            cod-emitente.

DEF TEMP-TABLE tt-series NO-UNDO
    FIELD serie LIKE nota-fiscal.serie
    INDEX id-serie
            serie.

DEF TEMP-TABLE tt-naturezas NO-UNDO
    FIELD nat-operacao LIKE nota-fiscal.nat-operacao
    INDEX id-nota
        nat-operacao.

DEF TEMP-TABLE tt-esp-docto NO-UNDO
    FIELD esp-docto LIKE nota-fiscal.esp-docto
    INDEX id-esp-docto
        esp-docto.

DEF TEMP-TABLE tt-transportadora NO-UNDO
    FIELD nome-abrev LIKE transporte.nome-abrev
    INDEX id-transportadora
            nome-abrev.

DEF TEMP-TABLE tt-volume-item-nf NO-UNDO
    FIELD nr-volume      LIKE volume-nf.nr-volume
    FIELD it-codigo      LIKE volume-nf.it-codigo
    FIELD nr-seq-fat     LIKE it-nota-fisc.nr-seq-fat
    FIELD log-fracionado LIKE volume-nf.varios-itens
    FIELD qtd-m3       AS DEC
    INDEX id-volume
            nr-volume
    INDEX id-item
            it-codigo
            nr-seq-fat.

DEF TEMP-TABLE tt-prog-entrada NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

DEF TEMP-TABLE tt-prog-pont5 NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

DEF TEMP-TABLE tt-prog-pont6 NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

DEF TEMP-TABLE tt-prog-pont7 NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

DEF TEMP-TABLE tt-prog-pont8 NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

/****Variaveis de Relatorio******/
DEFINE BUFFER   b-nota-fiscal         FOR  nota-fiscal.
DEFINE VARIABLE v-qtd-volumes         LIKE nota-embal.qt-volumes     NO-UNDO.
DEFINE VARIABLE v-qtd-total-volumes   LIKE nota-embal.qt-volumes     NO-UNDO.
DEFINE VARIABLE v-cod-familia         LIKE ITEM.fm-codigo            NO-UNDO.
DEFINE VARIABLE v-cod-item            LIKE ITEM.it-codigo            NO-UNDO.
DEFINE VARIABLE v-qtd-peso-bruto      LIKE it-nota-fisc.peso-bruto   NO-UNDO.
DEFINE VARIABLE v-qtd-peso-liq        LIKE it-nota-fisc.peso-liq-fat NO-UNDO.
DEFINE VARIABLE h-acomp                 AS HANDLE                    NO-UNDO.
DEFINE VARIABLE v-num-entr-param        AS INTEGER                   NO-UNDO.
DEFINE VARIABLE v-ind-modal-peso-cubado AS INTEGER                   NO-UNDO.
DEFINE VARIABLE v-cod-tipo-operac       AS CHARACTER                 NO-UNDO. 
DEFINE VARIABLE v-cod-arq-destino       AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE v-cod-arq-destino2      AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE v-cod-embalagem         AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE v-cod-conta-contab      AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE v-cod-ccusto            AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE v-des-tipo-carga        AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE v-dat-tmp               AS DATE                      NO-UNDO.
DEFINE VARIABLE v-qtd-peso-cubado       AS DECIMAL                   NO-UNDO.
DEFINE VARIABLE c-conhecimento          AS CHARACTER FORMAT 'x(200)' NO-UNDO.
DEFINE VARIABLE i-nro-itens             AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-via                   AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-transp-redesp         AS INT NO-UNDO.


DEFINE BUFFER b-emitente         FOR emitente.
DEFINE BUFFER b-emitente-reg-100 FOR emitente.
DEFINE BUFFER b-it-nota-fisc     FOR it-nota-fisc.
DEFINE BUFFER b-emitente-retirada FOR emitente.
DEFINE BUFFER b-emitente-transp   FOR emitente.

DEFINE VARIABLE c-arquivo-entrada AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-linha           AS CHAR FORMAT "X(200)" NO-UNDO.
DEFINE VARIABLE c-TpStatusDNE     AS CHAR NO-UNDO.

DEFINE VARIABLE h-gkapi0012         AS HANDLE      NO-UNDO.

/* 
Valores poss≠veis para o campo v-cod-tipo-operac

I - Incluir se n∆o existir ou Rejeitar se existir
A - Incluir se n∆o existir ou Atualizar se existir
M - Alterar se existir ou Rejeitar se n∆o existir
E - Excluir se existir ou Rejeitar se n∆o existir
*/

{include/i-rpvar.i}
{include/i-freeac.i}

/*********************************************************************/

FIND LAST param-global NO-LOCK NO-ERROR.
RUN utp/ut-acomp.p PERSISTEN SET h-acomp.
RUN pi-inicializar IN h-acomp("Extraá∆o de nota GKO").
DEF STREAM s-arquivo.
create tt-param.
raw-transfer raw-param to tt-param.
assign c-programa     = "gk0012"
       c-sistema      = "Notas Fiscais EMS para GKO"
       c-titulo-relat = "Notas Fiscais EMS para GKO"
       c-versao       = "2.00.00"
       c-revisao      = "000"
       c-empresa      = "Intelbras".
{include/i-rpout.i}
{include/i-rpcab.i}

EMPTY TEMP-TABLE tt-cliente.
EMPTY TEMP-TABLE tt-series.
EMPTY TEMP-TABLE tt-naturezas.
EMPTY TEMP-TABLE tt-esp-docto.
EMPTY TEMP-TABLE tt-transportadora.
EMPTY TEMP-TABLE tt-prog-entrada.
EMPTY TEMP-TABLE tt-prog-pont5.
EMPTY TEMP-TABLE tt-prog-pont6.
EMPTY TEMP-TABLE tt-prog-pont7.
EMPTY TEMP-TABLE tt-prog-pont8.
/* Identificar diretΩrio destino dos arquivos */
FOR FIRST ponto-programa
    WHERE ponto-programa.nome-programa = "gk0001"
      AND ponto-programa.ponto         = 1,
     EACH conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
    IF  conteudo-programa.conteudo                  <> "" AND
        NUM-ENTRIES(conteudo-programa.conteudo,";")  > 1
    THEN DO:
        IF  OPSYS = "WIN32"
        THEN DO:
            IF  ENTRY(1,conteudo-programa.conteudo,";") = "ENTRADAGKOWIN32"
            THEN
                ASSIGN v-cod-arq-destino  = ENTRY(2,conteudo-programa.conteudo,";")
                       v-cod-arq-destino2 = ENTRY(2,conteudo-programa.conteudo,";").
        END.
        ELSE DO:
            IF  ENTRY(1,conteudo-programa.conteudo,";") = "ENTRADAGKOUNIX"
            THEN
                ASSIGN v-cod-arq-destino  = ENTRY(2,conteudo-programa.conteudo,";")
                       v-cod-arq-destino2 = ENTRY(2,conteudo-programa.conteudo,";").
        END.
    END.
END.

DEF VAR v-cod-arq-destino-aux AS CHAR.

ASSIGN v-cod-arq-destino-aux = v-cod-arq-destino.

/* Identificar par≥metros para filtro de notas */
FOR FIRST ponto-programa
    WHERE ponto-programa.nome-programa = "gk0001"
      AND ponto-programa.ponto         = 2,
     EACH conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
    IF  conteudo-programa.conteudo                  <> "" AND
        NUM-ENTRIES(conteudo-programa.conteudo,";")  > 1
    THEN DO:
        IF  ENTRY(1,conteudo-programa.conteudo,";") = "CLIENTE"
        THEN DO:
            DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                IF INDEX(ENTRY(v-num-entr-param,conteudo-programa.conteudo,";"),"-") <> 0 THEN DO:
                    CREATE tt-cliente.
                    ASSIGN tt-cliente.cod-estabel  = entry(1,ENTRY(v-num-entr-param,conteudo-programa.conteudo,";"),"-")
                           tt-cliente.cod-emitente = int(entry(2,ENTRY(v-num-entr-param,conteudo-programa.conteudo,";"),"-")).
                END.
                ELSE DO:
                    CREATE tt-cliente.
                    ASSIGN tt-cliente.cod-emitente = INT(ENTRY(v-num-entr-param,conteudo-programa.conteudo,";")).
                END.
            END.
        END.

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "SERIE"
        THEN DO:
            DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                CREATE tt-series.
                ASSIGN tt-series.serie = ENTRY(v-num-entr-param,conteudo-programa.conteudo,";").
            END.
        END.

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "NATUREZA"
        THEN DO:
            DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                CREATE tt-naturezas.
                ASSIGN tt-naturezas.nat-operacao = ENTRY(v-num-entr-param,conteudo-programa.conteudo,";").
            END.
        END.

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "ESPDOCTO"
        THEN DO:
            DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                CREATE tt-esp-docto.
                ASSIGN tt-esp-docto.esp-docto = INT(ENTRY(v-num-entr-param,conteudo-programa.conteudo,";")).
            END.
        END.

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "TRANSPORTADORA"
        THEN DO:
            /* Para transportadoras deve ser cadastrado nos par≥metros qual n∆o deve integrar */
            DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                CREATE tt-transportadora.
                ASSIGN tt-transportadora.nome-abrev = ENTRY(v-num-entr-param,conteudo-programa.conteudo,";").
            END.
        END.
    END.
END.

/*
IF  tt-param.dat-emis-ini = 01/01/0001 AND
    tt-param.dat-emis-fim = 12/31/9999 OR
    tt-param.tg-habilita  = YES
THEN
    ASSIGN tt-param.dat-emis-ini = TODAY - 60
           tt-param.dat-emis-fim = TODAY.
    /* FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE */
    /* FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE */
    /************************  LAYOUT 000  ***************************/
    ASSIGN v-cod-arq-destino = v-cod-arq-destino
                               + "FRDNE"
                               + string(day(TODAY),"99")
                               + string(month(TODAY),"99")
                               + string(YEAR(TODAY),"9999")
                               + string(TIME)
                               + ".txt".

    output STREAM s-arquivo to value(v-cod-arq-destino) page-size 0.

    PUT STREAM s-arquivo 
        "000"       FORMAT "x(03)" /* 1 - TpRegistro   */
        "IntDNE"    FORMAT "x(10)" /* 2 - NmInterface  */
        "6.42a"     FORMAT "x(06)" /* 3 - Versao       */
        "INTELBRAS" FORMAT "x(40)" /* 4 - Remetente    */
        "GKO"       FORMAT "x(40)" /* 5 - Destinatario */
        "EMS"       FORMAT "x(03)" /* 6 - CdAmbiente   */
        SKIP. */


    EMPTY TEMP-TABLE tt-prog-entrada.
    RUN esp/es0018p.p (INPUT "gk0001":U,
                       INPUT 4,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    RUN esp/es0018p.p (INPUT "gk0001":U,           
                       INPUT 7,                    
                       INPUT 0,                    
                       INPUT "":U,                 
                       OUTPUT TABLE tt-prog-pont5).

    RUN esp/es0018p.p (INPUT "gk0001":U,           
                       INPUT 8,                    
                       INPUT 0,                    
                       INPUT "":U,                 
                       OUTPUT TABLE tt-prog-pont6).

    IF tt-param.dat-emis-ini = 01/01/0001 THEN
        ASSIGN tt-param.log-60dias = YES.

    IF tt-param.log-60dias THEN
        ASSIGN tt-param.dat-emis-ini = TODAY - 60
               tt-param.dat-emis-fim = TODAY.

    DO v-dat-tmp = tt-param.dat-emis-ini TO tt-param.dat-emis-fim ON ERROR UNDO, LEAVE:

        RUN pi-acompanhar IN h-acomp (INPUT "Verificando dia: " + STRING(v-dat-tmp,"99/99/9999")).

        IF tt-param.log-nota-entrada  THEN DO:
            FOR EACH docum-est NO-LOCK
               WHERE docum-est.dt-emissao = v-dat-tmp:
                IF CAN-FIND(FIRST tt-prog-pont7
                            WHERE tt-prog-pont7.conteudo = docum-est.nat-operacao) OR
                        CAN-FIND(FIRST tt-prog-pont8
                                WHERE tt-prog-pont8.conteudo = docum-est.nat-operacao) THEN DO:
                                
                                IF CAN-FIND(FIRST item-doc-est OF docum-est NO-LOCK
                                            WHERE item-doc-est.sc-codigo = "") THEN 
                                                NEXT. //nao importa notas de entrada sem conta informada no item    
                                
                                   
                END.
                ELSE
                    IF CAN-FIND(FIRST tt-prog-ponto
                            WHERE tt-prog-ponto.conteudo = docum-est.nat-operacao) THEN
                            RUN imprimi-nf-entrada-arquivo.
            END.
        END.
        IF tt-param.log-nota-saida THEN DO:
           FOR EACH nota-fiscal USE-INDEX ch-sit-nota NO-LOCK
              WHERE nota-fiscal.dt-emis-nota = v-dat-tmp
                AND int(nota-fiscal.ind-tip-nota) <> 8 /*Tipo recebimento*/:
               RUN imprimi-nf-arquivo.
           END. /* FOR EACH nota-fiscal USE-INDEX ch-sit-nota NO-LOCK*/
           FOR EACH devol-cli NO-LOCK
               WHERE devol-cli.dt-devol = v-dat-tmp:
               FOR FIRST nota-fiscal
                   WHERE nota-fiscal.cod-estabel  = devol-cli.cod-estabel
                     AND nota-fiscal.serie       = devol-cli.serie
                     AND nota-fiscal.nr-nota-fis = devol-cli.nr-nota-fis NO-LOCK:
                   IF AVAIL nota-fiscal THEN DO:
                       FIND FIRST int-docum-est
                           WHERE int-docum-est.serie-docto  = devol-cli.serie
                             AND int-docum-est.nro-docto    = devol-cli.nro-docto
                             AND int-docum-est.cod-emitente = devol-cli.cod-emitente
                             AND int-docum-est.nat-operacao = devol-cli.nat-operacao NO-LOCK NO-ERROR.
           
/*                        IF AVAIL int-docum-est then                       */
/*                            if int-docum-est.cod-msg-devolucao = 517 THEN */
/*                                NEXT.                                     */
/*                            ELSE                                          */
                               RUN imprimi-nf-arquivo.
                      /* ELSE
                          RUN imprimi-nf-arquivo. */
                   END.
               END.
           END. /*FOR EACH devol-cli USE-INDEX ch-dt-emit NO-LOCK*/

        END.
    END.
    
    /* FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE */
    /* FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE */

    /* N∆o ter† correios */
/*     IF tt-param.log-correios = YES THEN DO:                                                                                                           */
/*         RUN pi-acompanhar IN h-acomp (INPUT "De FRDNE para FRGEN").                                                                                   */
/*                                                                                                                                                       */
/*         /* FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN */                                                                                   */
/*         /* FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN */                                                                                   */
/*         /************************  LAYOUT 000  ***************************/                                                                           */
/*         ASSIGN v-cod-arq-destino2 = v-cod-arq-destino2                                                                                                */
/*                                    + "FRGEN"                                                                                                          */
/*                                    + string(day(TODAY),"99")                                                                                          */
/*                                    + string(month(TODAY),"99")                                                                                        */
/*                                    + string(YEAR(TODAY),"9999")                                                                                       */
/*                                    + string(TIME)                                                                                                     */
/*                                    + ".txt".                                                                                                          */
/*                                                                                                                                                       */
/*         OUTPUT STREAM s-arquivo  to value(v-cod-arq-destino2) page-size 0.                                                                            */
/*                                                                                                                                                       */
/*         PUT STREAM s-arquivo                                                                                                                          */
/*             '000^INTGEN^5.0aD^EMPRESAUSUµRIA^GKO FRETE^'                                        SKIP                                                  */
/*             '001^MEMBTRANSPORTE^CDEMBTRANSPORTEINT^1^004'                                       SKIP                                                  */
/*             '002^CDEMBTRANSPORTEINT^C^13^0^1^^^'                                                SKIP                                                  */
/*             '002^CDEMBTRANSPORTE^C^13^0^1^^^'                                                   SKIP                                                  */
/*             '002^IDEVENTO^C^11^0^1^^^'                                                          SKIP                                                  */
/*             '002^IDEMBALA^C^8^0^1^^^'                                                           SKIP.                                                 */
/*                                                                                                                                                       */
/*         DO v-dat-tmp = tt-param.dat-emis-ini TO tt-param.dat-emis-fim ON ERROR UNDO, LEAVE:                                                           */
/*                                                                                                                                                       */
/*             FOR EACH nota-fiscal USE-INDEX ch-sit-nota NO-LOCK                                                                                        */
/*                 WHERE nota-fiscal.dt-emis-nota = v-dat-tmp:                                                                                           */
/*                 IF  nota-fiscal.cod-estabel < tt-param.cod-estab-ini OR                                                                               */
/*                     nota-fiscal.cod-estabel > tt-param.cod-estab-fim                                                                                  */
/*                 THEN NEXT.                                                                                                                            */
/*                                                                                                                                                       */
/*                 IF nota-fiscal.nr-nota-fis < tt-param.num-nota-ini OR                                                                                 */
/*                    nota-fiscal.nr-nota-fis > tt-param.num-nota-fim                                                                                    */
/*                 THEN NEXT.                                                                                                                            */
/*                                                                                                                                                       */
/*                                                                                                                                                       */
/*                 RUN pi-acompanhar IN h-acomp (INPUT "FRGEN Nota Fiscal: " + string(nota-fiscal.nr-nota-fis) + " Transp: " + nota-fiscal.nome-transp). */
/*                                                                                                                                                       */
/*                 IF tt-param.log-desconsidera = NO THEN DO:                                                                                            */
/*                     IF nota-fiscal.dt-saida = ? THEN NEXT.                                                                                            */
/*                     IF  nota-fiscal.idi-sit-nf-eletro < 3 OR                                                                                          */
/*                         nota-fiscal.cod-chave-aces-nf-eletro = "" /* Uso autorizado */ THEN NEXT.                                                     */
/*                                                                                                                                                       */
/*                     IF SUBSTRING(nota-fiscal.nat-operacao, 1,1) <> "5" AND                                                                            */
/*                        SUBSTRING(nota-fiscal.nat-operacao, 1,1) <> "6" AND                                                                            */
/*                        SUBSTRING(nota-fiscal.nat-operacao, 1,1) <> "7" THEN DO:                                                                       */
/*                        NEXT.                                                                                                                          */
/*                     END.                                                                                                                              */
/*                 END.                                                                                                                                  */
/*                 RUN pi-acompanhar IN h-acomp (INPUT "FRGEN Nota Fiscal: " + string(nota-fiscal.nr-nota-fis) + " Transp: " + nota-fiscal.nome-transp). */
/*                                                                                                                                                       */
/*     /*             FIND FIRST transporte                                                        */                                                    */
/*     /*                  WHERE transporte.nome-abrev = nota-fiscal.nome-transp NO-LOCK NO-ERROR. */                                                    */
/*     /*             IF AVAIL transporte THEN DO:                                                 */                                                    */
/*                                                                                                                                                       */
/*                     IF CAN-FIND(FIRST param-correios                                                                                                  */
/*                                 WHERE param-correios.cod-estabel = nota-fiscal.cod-estabel                                                            */
/*                                   AND param-correios.tp-servico  = nota-fiscal.nome-transp) THEN DO:                                                  */
/*                                                                                                                                                       */
/*                         FOR EACH int-nota-conhec                                                                                                      */
/*                             WHERE int-nota-conhec.cod-estabel = nota-fiscal.cod-estabel                                                               */
/*                               AND int-nota-conhec.serie       = nota-fiscal.serie                                                                     */
/*                               AND int-nota-conhec.nr-nota-fis = nota-fiscal.nr-nota-fis EXCLUSIVE-LOCK .                                              */
/*                                                                                                                                                       */
/*                             IF tt-param.log-desconsidera = NO THEN DO:                                                                                */
/*                                 IF tt-param.log-reexportar = NO THEN                                                                                  */
/*                                    IF int-nota-conhec.int-1 = 1 THEN NEXT.                                                                            */
/*                             END.                                                                                                                      */
/*                             IF  int-nota-conhec.nr-conhec   <> '' THEN DO:                                                                            */
/*                                                                                                                                                       */
/*                                 ASSIGN c-conhecimento = int-nota-conhec.nr-conhec + '^' + int-nota-conhec.nr-conhec  + '^1^46170602^'.                */
/*                                                                                                                                                       */
/*                                 PUT STREAM s-arquivo '004^' + TRIM(c-conhecimento)                       FORMAT 'x(200)'                 SKIP.        */
/*                                                                                                                                                       */
/*                                 ASSIGN int-nota-conhec.int-1 = 1.                                                                                     */
/*                             END. /* IF  int-nota-conhec.log-1       <> YES AND int-nota-conhec.nr-conhec   <> '' THEN DO: */                          */
/*                                                                                                                                                       */
/*                         END. /* FOR EACH int-nota-conhec */                                                                                           */
/*                                                                                                                                                       */
/*                         FIND CURRENT int-nota-conhec NO-LOCK NO-ERROR.                                                                                */
/*                         RELEASE int-nota-conhec.                                                                                                      */
/*                                                                                                                                                       */
/*                     END. /* IF CAN-FIND(param-correios */                                                                                             */
/*                                                                                                                                                       */
/*     /*                 IF (transporte.cod-transp = 254           */                                                                                   */
/*     /*                 OR  transporte.cod-transp = 264           */                                                                                   */
/*     /*                 OR  transporte.cod-transp = 350) THEN DO: */                                                                                   */
/*     /*                 END. /* Transporte Correios*/       */                                                                                         */
/*     /*                                                     */                                                                                         */
/*     /*             END. /* IF AVAIL transporte THEN DO: */ */                                                                                         */
/*                                                                                                                                                       */
/*             END. /* FOR EACH nota-fiscal USE-INDEX ch-sit-nota NO-LOCK*/                                                                              */
/*                                                                                                                                                       */
/*         END.  /*DO v-dat-tmp = tt-param.dat-emis-ini TO tt-param.dat-emis-fim ON ERROR UNDO, LEAVE: */                                                */


        
        /* FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN */
        /* FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN */

 /*   END. /* IF tt-param.log-correios = YES THEN DO: */ */


run pi-finalizar in h-acomp.

{include/i-rpclo.i}



PROCEDURE pi-gera-registro-100:

    DEF INPUT PARAM p-cod-emitente LIKE emitente.cod-emitente.
    DEF INPUT PARAM p-ind-tipo-par   AS INTEGER.

    DEF VAR v-cod-cgc       LIKE emitente.cgc      NO-UNDO.
    DEF VAR v-ind-tp-pessoa LIKE emitente.natureza NO-UNDO.
    DEF VAR v-cod-cep       LIKE emitente.cep      NO-UNDO.

    EMPTY TEMP-TABLE tt-parceiro.

    /* Validar na tabela criada se o registro j† est† integrado antes de chamar o GKO, caso j† esteja, n∆o chamar GKO */
    IF NOT CAN-FIND(FIRST gko-emitente-integrado
                    WHERE gko-emitente-integrado.cod-emitente = p-cod-emitente) THEN DO:
        FIND b-emitente-reg-100 NO-LOCK
            WHERE b-emitente-reg-100.cod-emitente = p-cod-emitente NO-ERROR.
    
        IF  AVAIL b-emitente-reg-100
        THEN DO:
            ASSIGN v-cod-cgc       = b-emitente-reg-100.cgc
                   v-ind-tp-pessoa = b-emitente-reg-100.natureza
                   v-cod-cep       = b-emitente-reg-100.cep.
    
            /* Tratar valores para quando destino ≤ exportaá∆o */
            IF  b-emitente-reg-100.estado = "EX" OR
                b-emitente-reg-100.natureza = 3  OR
                b-emitente-reg-100.natureza = 4
            THEN
                ASSIGN v-cod-cgc       = "000000000000000"
                       v-ind-tp-pessoa = 2 /* Juridica */
                       v-cod-cep       = "00000000".

            RUN pi-acompanhar IN h-acomp (INPUT "Adicionando Parceiro: " + STRING(b-emitente-reg-100.cod-emitente)).
    
            CREATE tt-parceiro.
            ASSIGN tt-parceiro.partnerType                      = "Cliente"
                   tt-parceiro.cod-emitente                     = b-emitente-reg-100.cod-emitente                        /*  5 - CdParceiroComercial              */           
                   tt-parceiro.nome-emit                        = fn-free-accent(upper(trim(SUBSTRING(b-emitente-reg-100.nome-emit,1,40))))     /*  6 - NmParceiroComercial              */
                   tt-parceiro.natureza                         = IF b-emitente-reg-100.natureza = 1 THEN "Pessoa F°sica" ELSE "Pessoa Jur°dica"                                                /* 13 - TpPessoa                         */
                   tt-parceiro.taxaPayerICMS                    = IF b-emitente-reg-100.contrib-icms THEN 1 ELSE 0 
                   tt-parceiro.taxpayerOptingICMS               = 0 /* 17 - StRegCredICMS (0- Cliente)       */
                   tt-parceiro.cgc                              = v-cod-cgc /*  3 - NoCgcCpf                         */
                   tt-parceiro.companyType                      = "Cliente"
                   tt-parceiro.ins-municipal                    = b-emitente-reg-100.ins-municipal /* 14 - DsInscrMunicipal                 */
                   tt-parceiro.ins-estadual                     = b-emitente-reg-100.ins-estadual  /* 15 - DsInscrEstadual                  */
                   tt-parceiro.appointmentRequesAutomatically   = NO 
                   tt-parceiro.schedulingType                   = "N∆o exige Agendamento" 
                   tt-parceiro.birthDate                        = "" 
                   tt-parceiro.formCommunicationId              = "MAIL" 
                   tt-parceiro.formCommunication                = "MAIL" 
                   tt-parceiro.isCharge                         = NO 
                   tt-parceiro.noticeLateCharge                 = NO 
                   tt-parceiro.confirmationNotice               = NO 
                   tt-parceiro.bairro                           = fn-free-accent(upper(trim(b-emitente-reg-100.bairro)))       /*  8 - DsBairro                         */
                   tt-parceiro.cep                              = v-cod-cep                                                    /* 11 - NoCEP                            */
                   tt-parceiro.endereco                         = fn-free-accent(upper(trim(b-emitente-reg-100.endereco)))     /*  7 - DsEndereco                       */
                   tt-parceiro.cidade                           = fn-free-accent(upper(trim(b-emitente-reg-100.cidade)))       /*  9 - NomeCidade                       */
                   tt-parceiro.estado                           = fn-free-accent(upper(trim(b-emitente-reg-100.estado)))       /* 10 - UF                               */
            .

            IF NOT VALID-HANDLE(h-gkapi0012) THEN
                RUN esp/gko/gkapi012.p persistent set h-gkapi0012.

            RUN integrarParceiro IN h-gkapi0012 (INPUT TABLE tt-parceiro).
        END.
    END.

    FINALLY:
        ASSIGN h-gkapi0012 = ? NO-ERROR.
        DELETE OBJECT h-gkapi0012 NO-ERROR.
    END FINALLY.
    
END PROCEDURE.


PROCEDURE pi-calcula-peso-cubado-item:

    DEF INPUT PARAM p-log-ultimo AS LOG NO-UNDO.

    ASSIGN v-qtd-peso-cubado = 0
           v-qtd-volumes     = 0.

    FIND FIRST ped-venda NO-LOCK                                                
         WHERE ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli                      
           AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.        

    FIND FIRST int-ped-venda no-lock
         WHERE int-ped-venda.cod-estabel = ped-venda.cod-estabel
           AND int-ped-venda.nr-pedido   = ped-venda.nr-pedido no-error.

    FOR EACH  volume-nf NO-LOCK
        WHERE volume-nf.cod-estabel = it-nota-fisc.cod-estabel
          AND volume-nf.serie       = it-nota-fisc.serie
          AND volume-nf.nr-nota-fis = it-nota-fisc.nr-nota-fis
          AND volume-nf.it-codigo   = it-nota-fisc.it-codigo
        BREAK BY volume-nf.it-codigo:

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = volume-nf.it-codigo NO-ERROR.

        FIND FIRST int-item NO-LOCK
             WHERE int-item.it-codigo = ITEM.it-codigo NO-ERROR.

        FIND FIRST tt-volume-item-nf NO-LOCK
             WHERE tt-volume-item-nf.nr-volume = volume-nf.nr-volume NO-ERROR.

        IF  NOT AVAIL tt-volume-item-nf
        THEN DO:
            CREATE tt-volume-item-nf.
            ASSIGN tt-volume-item-nf.nr-volume      = volume-nf.nr-volume
                   tt-volume-item-nf.it-codigo      = volume-nf.it-codigo
                   tt-volume-item-nf.log-fracionado = volume-nf.varios-itens
                   tt-volume-item-nf.nr-seq-fat     = it-nota-fisc.nr-seq-fat.

            IF  AVAIL int-ped-venda
            AND int-ped-venda.vol-m3 > 0 THEN DO:
                IF FIRST-OF (volume-nf.it-codigo) THEN
                    ASSIGN tt-volume-item-nf.qtd-m3 = IF AVAIL int-ped-venda THEN int-ped-venda.vol-m3 ELSE 0.
            END.
            ELSE DO:
                FIND FIRST embalag NO-LOCK
                     WHERE embalag.sigla-emb = volume-nf.sigla-emb NO-ERROR.
    
                IF AVAIL embalag THEN
                    ASSIGN tt-volume-item-nf.qtd-m3 = tt-volume-item-nf.qtd-m3 + embalag.volume.
            END.
        END.
    END.

    FOR EACH  tt-volume-item-nf NO-LOCK                                    
        WHERE tt-volume-item-nf.it-codigo  = it-nota-fisc.it-codigo    
          AND tt-volume-item-nf.nr-seq-fat = it-nota-fisc.nr-seq-fat:

        ASSIGN v-qtd-peso-cubado = v-qtd-peso-cubado + tt-volume-item-nf.qtd-m3
               v-qtd-volumes     = v-qtd-volumes     + 1.

        IF  tt-volume-item-nf.log-fracionado = NO
        THEN
            ASSIGN v-des-tipo-carga = "Fechada".
    END.

    ASSIGN v-qtd-total-volumes = v-qtd-total-volumes + v-qtd-volumes.

    /* Acumular volumes que n∆o est∆o lanáados como item na nota */
    IF  p-log-ultimo
    THEN DO:
        bloco-volume-extra:
        FOR EACH  volume-nf NO-LOCK
            WHERE volume-nf.cod-estabel = it-nota-fisc.cod-estabel
              AND volume-nf.serie       = it-nota-fisc.serie
              AND volume-nf.nr-nota-fis = it-nota-fisc.nr-nota-fis:
    
            FIND FIRST b-it-nota-fisc NO-LOCK
                WHERE  b-it-nota-fisc.cod-estabel = volume-nf.cod-estabel
                  AND  b-it-nota-fisc.serie       = volume-nf.serie      
                  AND  b-it-nota-fisc.nr-nota-fis = volume-nf.nr-nota-fis
                  AND  b-it-nota-fisc.it-codigo   = volume-nf.it-codigo NO-ERROR.

            IF  AVAIL b-it-nota-fisc
            THEN
                NEXT bloco-volume-extra.

            FIND FIRST tt-volume-item-nf NO-LOCK
                WHERE  tt-volume-item-nf.nr-volume = volume-nf.nr-volume NO-ERROR.
    
            IF  NOT AVAIL tt-volume-item-nf
            THEN DO:
                CREATE tt-volume-item-nf.
                ASSIGN tt-volume-item-nf.nr-volume  = volume-nf.nr-volume
                       tt-volume-item-nf.it-codigo  = volume-nf.it-codigo
                       tt-volume-item-nf.nr-seq-fat = 99.
    
                FIND FIRST embalag NO-LOCK
                    WHERE  embalag.sigla-emb = volume-nf.sigla-emb NO-ERROR.
    
                IF  AVAIL embalag
                THEN
                    ASSIGN tt-volume-item-nf.qtd-m3 = tt-volume-item-nf.qtd-m3 + embalag.volume.
            END.
        END. /* FOR EACH  volume-nf NO-LOCK */
    
        FOR EACH tt-volume-item-nf NO-LOCK:
            IF  tt-volume-item-nf.nr-seq-fat = 99
            THEN
                ASSIGN v-qtd-peso-cubado = v-qtd-peso-cubado + tt-volume-item-nf.qtd-m3
                       v-qtd-volumes     = v-qtd-volumes     + 1.
        END.
        ASSIGN v-qtd-total-volumes = v-qtd-total-volumes + v-qtd-volumes.
        IF  v-qtd-total-volumes = 0
        THEN
            ASSIGN v-qtd-volumes = INT(nota-fiscal.nr-volumes).
    END. /* IF  p-log-ultimo */
END PROCEDURE.

PROCEDURE pi-busca-conta-contabil:

    FOR FIRST ped-fiscal FIELDS(ct-codigo sc-codigo)
        WHERE ped-fiscal.cod-estabel = nota-fiscal.cod-estabel
        AND   ped-fiscal.serie       = nota-fiscal.serie
        AND   ped-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK:

        ASSIGN v-cod-ccusto = ped-fiscal.sc-codigo.
    END.

    FIND FIRST gko-param-contab-totvs11
        WHERE  gko-param-contab-totvs11.cod-estabel     = nota-fiscal.cod-estabel
        AND    gko-param-contab-totvs11.nat-operacao    = it-nota-fisc.nat-operacao
        AND    gko-param-contab-totvs11.cod-unid-negoc  = it-nota-fisc.cod-unid-negoc
        AND    gko-param-contab-totvs11.cod-canal-venda = nota-fiscal.cod-canal-venda NO-LOCK NO-ERROR.
    
    IF NOT AVAIL gko-param-contab-totvs11 THEN
        FIND FIRST gko-param-contab-totvs11 
            WHERE  gko-param-contab-totvs11.cod-estabel     = nota-fiscal.cod-estabel
            AND    gko-param-contab-totvs11.nat-operacao    = it-nota-fisc.nat-operacao
            AND    gko-param-contab-totvs11.cod-unid-negoc  = it-nota-fisc.cod-unid-negoc
            AND    gko-param-contab-totvs11.cod-canal-venda = ? NO-LOCK NO-ERROR.
                   
    
    IF NOT AVAIL gko-param-contab-totvs11 THEN
        FIND FIRST gko-param-contab-totvs11 
            WHERE  gko-param-contab-totvs11.cod-estabel     = nota-fiscal.cod-estabel
            AND    gko-param-contab-totvs11.nat-operacao    = it-nota-fisc.nat-operacao
            AND    gko-param-contab-totvs11.cod-unid-negoc  = ?
            AND    gko-param-contab-totvs11.cod-canal-venda = nota-fiscal.cod-canal-venda NO-LOCK NO-ERROR.
    IF NOT AVAIL gko-param-contab-totvs11 THEN
        FIND FIRST gko-param-contab-totvs11 
            WHERE  gko-param-contab-totvs11.cod-estabel     = nota-fiscal.cod-estabel
            AND    gko-param-contab-totvs11.nat-operacao    = it-nota-fisc.nat-operacao
            AND    gko-param-contab-totvs11.cod-unid-negoc  = "?"
            AND    gko-param-contab-totvs11.cod-canal-venda = nota-fiscal.cod-canal-venda NO-LOCK NO-ERROR.
    
    IF NOT AVAIL gko-param-contab-totvs11 THEN
        FIND FIRST gko-param-contab-totvs11 
            WHERE  gko-param-contab-totvs11.cod-estabel     = nota-fiscal.cod-estabel
            AND    gko-param-contab-totvs11.nat-operacao    = it-nota-fisc.nat-operacao
            AND    gko-param-contab-totvs11.cod-unid-negoc  = ?
            AND    gko-param-contab-totvs11.cod-canal-venda = ? NO-LOCK NO-ERROR.
    IF NOT AVAIL gko-param-contab-totvs11 THEN
        FIND FIRST gko-param-contab-totvs11 
            WHERE  gko-param-contab-totvs11.cod-estabel     = nota-fiscal.cod-estabel
            AND    gko-param-contab-totvs11.nat-operacao    = it-nota-fisc.nat-operacao
            AND    gko-param-contab-totvs11.cod-unid-negoc  = "?"
            AND    gko-param-contab-totvs11.cod-canal-venda = ? NO-LOCK NO-ERROR.

    FIND unid_negoc
        WHERE unid_negoc.cod_unid_negoc = it-nota-fisc.cod-unid-negoc NO-LOCK NO-ERROR.
    
    IF  AVAIL gko-param-contab-totvs11 AND AVAIL unid_negoc THEN DO:
        IF v-cod-ccusto <> "" AND gko-param-contab-totvs11.cod-canal-venda = 12 THEN 
            ASSIGN v-cod-ccusto = STRING(unid_negoc.cdn_unid_negoc,"999") + v-cod-ccusto.
        ELSE
            ASSIGN v-cod-ccusto = STRING(unid_negoc.cdn_unid_negoc,"999") + gko-param-contab-totvs11.sc-codigo.

        ASSIGN v-cod-conta-contab = gko-param-contab-totvs11.ct-codigo.
    END.
    
    IF NOT AVAIL gko-param-contab-totvs11 AND AVAIL unid_negoc THEN
        ASSIGN v-cod-conta-contab = "11910160"
               v-cod-ccusto       = "00000001" WHEN v-cod-ccusto = "".
    

END PROCEDURE.


PROCEDURE imprimi-nf-arquivo:

        DEF VAR c-marketplace AS CHAR NO-UNDO.

        IF nota-fiscal.cod-estabel BEGINS "5" OR nota-fiscal.cod-estabel BEGINS "6" THEN NEXT. /*nao extrair notas da Decio e Prediotech*/
    
        IF  nota-fiscal.idi-sit-nf-eletro <> 3 OR
/*             substring(nota-fiscal.cod-chave-aces-nf-eletro,28,7) <> substring(nota-fiscal.cod-chave-aces-nf-eletro,37,7) or /* Chave NFe Invalida */  */
            nota-fiscal.cod-chave-aces-nf-eletro = "" /* Uso autorizado idi-sit-nf-eletro = 3*/ 
        THEN NEXT. 

        
        IF  nota-fiscal.cod-estabel < tt-param.cod-estab-ini OR
            nota-fiscal.cod-estabel > tt-param.cod-estab-fim
        THEN NEXT. 
        
        IF nota-fiscal.nr-nota-fis < tt-param.num-nota-ini OR
           nota-fiscal.nr-nota-fis > tt-param.num-nota-fim 
        THEN NEXT. 

        IF nota-fiscal.serie < tt-param.serie-ini OR
           nota-fiscal.serie > tt-param.serie-fim 
        THEN NEXT. 

        FIND FIRST tt-cliente NO-LOCK
            WHERE  tt-cliente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
        IF AVAIL tt-cliente
            AND (tt-cliente.cod-estabel <> ""
              and tt-cliente.cod-estabel = nota-fiscal.cod-estabel) THEN
                NEXT.

        IF SUBSTRING(nota-fiscal.nat-operacao, 1,1) <> "5" AND
           SUBSTRING(nota-fiscal.nat-operacao, 1,1) <> "6" AND
           SUBSTRING(nota-fiscal.nat-operacao, 1,1) <> "7" THEN DO: 
           NEXT.
        END.

        FIND FIRST tt-series NO-LOCK
            WHERE  tt-series.serie = nota-fiscal.serie NO-ERROR.
        IF  NOT AVAIL tt-series THEN NEXT.

        FIND FIRST tt-esp-docto NO-LOCK
            WHERE  tt-esp-docto.esp-docto = nota-fiscal.esp-docto NO-ERROR.
        IF  NOT AVAIL tt-esp-docto THEN NEXT.

        FIND FIRST transporte NO-LOCK
            WHERE  transporte.nome-abrev = nota-fiscal.nome-transp NO-ERROR.
  
        FIND FIRST volume-nf NO-LOCK
            WHERE  volume-nf.cod-estabel = nota-fiscal.cod-estabel
              AND  volume-nf.serie       = nota-fiscal.serie
              AND  volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
        IF    int(nota-fiscal.nr-volume) = 0 THEN DO:
            FIND b-nota-fiscal
                WHERE ROWID(b-nota-fiscal) = rowid(nota-fiscal)
                EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL b-nota-fiscal THEN DO:
                ASSIGN b-nota-fiscal.dt-saida = nota-fiscal.dt-emis-nota.
            END.
            NEXT.
        END.
        ASSIGN v-cod-tipo-operac = "A"
               c-TpStatusDNE     = "A".

        /*Verificar nota de devoluá∆o*/
        FIND FIRST devol-cli 
             WHERE devol-cli.cod-estabel = nota-fiscal.cod-estabel
               AND devol-cli.serie       = nota-fiscal.serie 
               AND devol-cli.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
        IF AVAIL devol-cli THEN
            FIND FIRST int-docum-est
                 WHERE int-docum-est.serie-docto  = devol-cli.serie-docto
                   AND int-docum-est.nro-docto    = devol-cli.nro-docto
                   AND int-docum-est.cod-emitente = devol-cli.cod-emitente
                   AND int-docum-est.nat-operacao = devol-cli.nat-operacao 
                   AND (int-docum-est.cod-msg-devolucao = 500
                    OR  int-docum-est.cod-msg-devolucao = 521) NO-LOCK NO-ERROR.
    
        IF (AVAIL devol-cli AND AVAIL int-docum-est) OR nota-fiscal.dt-cancel <> ? THEN
            ASSIGN c-TpStatusDNE = "E".
    
        IF  nota-fiscal.dt-cancela <> ? THEN ASSIGN v-cod-tipo-operac = "E".
    
        /* Validar nota ja integrada */ 
        // Comentar este trecho para teste

        IF  tt-param.log-reexportar = NO THEN DO:

            IF CAN-FIND(FIRST gko-nfs-integrada                                                                                                               
                        WHERE gko-nfs-integrada.cod-estabel               = nota-fiscal.cod-estabel                                                                        
                          AND gko-nfs-integrada.serie                     = nota-fiscal.serie                                                                              
                          AND gko-nfs-integrada.nr-nota-fis               = nota-fiscal.nr-nota-fis
                          AND gko-nfs-integrada.cod-chave-aces-nf-eletr   = nota-fiscal.cod-chave-aces-nf-eletro  
                          AND gko-nfs-integrada.cod-emitente              = nota-fiscal.cod-emitente             
                        /*  AND gko-nfs-integrada.tipo-operacao = c-TpStatusDNE */) 
            THEN NEXT. 
          
    
            
        END. /* tt-param.log-reexportar = NO THEN DO: */
        ELSE DO:
            IF NOT CAN-FIND(FIRST gko-nfs-integrada                                                                                                               
                            WHERE gko-nfs-integrada.cod-estabel               = nota-fiscal.cod-estabel                                                                        
                              AND gko-nfs-integrada.serie                     = nota-fiscal.serie                                                                              
                              AND gko-nfs-integrada.nr-nota-fis               = nota-fiscal.nr-nota-fis
                              AND gko-nfs-integrada.cod-chave-aces-nf-eletr   = nota-fiscal.cod-chave-aces-nf-eletro
                              AND gko-nfs-integrada.cod-emitente              = nota-fiscal.cod-emitente            
                           /*   AND gko-nfs-integrada.tipo-operacao = c-TpStatusDNE */ ) 
            THEN NEXT. 
        END.

        EMPTY TEMP-TABLE tt-volume-item-nf.
        
    /* FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE */
    /* FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE */
    /************************  LAYOUT 000  ***************************/
/*         ASSIGN v-cod-arq-destino = v-cod-arq-destino-aux                 */
/*                                  + "FRDNE"                               */
/*                                  + STRING(nota-fiscal.nr-nota-fis)       */
/*                                  + string(day(TODAY),"99")               */
/*                                  + string(month(TODAY),"99")             */
/*                                  + string(YEAR(TODAY),"9999")            */
/*                                  + string(TIME)                          */
/*                                  + ".txt".                               */
/*                                                                          */
/*         output STREAM s-arquivo to value(v-cod-arq-destino) page-size 0. */

        //modificando para gerar um arquivo por nota.
/*         PUT STREAM s-arquivo                                */
/*           "000"       FORMAT "x(03)" /* 1 - TpRegistro   */ */
/*           "IntDNE"    FORMAT "x(10)" /* 2 - NmInterface  */ */
/*           "6.42a"     FORMAT "x(06)" /* 3 - Versao       */ */
/*           "INTELBRAS" FORMAT "x(40)" /* 4 - Remetente    */ */
/*           "GKO"       FORMAT "x(40)" /* 5 - Destinatario */ */
/*           "EMS"       FORMAT "x(03)" /* 6 - CdAmbiente   */ */
/*         SKIP.                                               */
    
        RUN pi-acompanhar IN h-acomp (INPUT "NF: " + string(nota-fiscal.nr-nota-fis) + " Transp: " + nota-fiscal.nome-transp).

        FIND estabelec NO-LOCK
            WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.
  
/*         FIND FIRST gko-nfs-integrada NO-LOCK                                  */
/*              WHERE gko-nfs-integrada.cod-estabel   = nota-fiscal.cod-estabel  */
/*                AND gko-nfs-integrada.serie         = nota-fiscal.serie        */
/*                AND gko-nfs-integrada.nr-nota-fis   = nota-fiscal.nr-nota-fis  */
/*                AND gko-nfs-integrada.tipo-operacao = c-TpStatusDNE NO-ERROR.  */
/*         IF  NOT AVAIL gko-nfs-integrada THEN DO:                              */
/*             CREATE gko-nfs-integrada.                                         */
/*             ASSIGN gko-nfs-integrada.cod-estabel    = nota-fiscal.cod-estabel */
/*                    gko-nfs-integrada.serie          = nota-fiscal.serie       */
/*                    gko-nfs-integrada.nr-nota-fis    = nota-fiscal.nr-nota-fis */
/*                    gko-nfs-integrada.tipo-operacao  = c-TpStatusDNE           */
/*                    gko-nfs-integrada.dat-integracao = TODAY                   */
/*                    gko-nfs-integrada.hor-integracao = TIME                    */
/*                    gko-nfs-integrada.arq-integracao = v-cod-arq-destino.      */
/*         END.                                                                  */
        FIND FIRST b-emitente NO-LOCK
            WHERE  b-emitente.cgc = transporte.cgc NO-ERROR.
    
        ASSIGN v-ind-modal-peso-cubado = transporte.via-transp.
    
        /*---------------------- Grava os Dados da Nota Fiscal ------------------*/        
    
        find first natur-oper
             where natur-oper.nat-operacao = nota-fiscal.nat-operacao no-lock no-error.
        find first estabelec
             where estabelec.cod-estabel = nota-fiscal.cod-estabel no-lock no-error.
    
        for FIRST nota-embal use-index ch-nota-emb NO-LOCK
            where nota-embal.cod-estabel = nota-fiscal.cod-estabel
              and nota-embal.serie       = nota-fiscal.serie
              and nota-embal.nr-nota-fis = nota-fiscal.nr-nota-fis:
            ASSIGN v-cod-embalagem = nota-embal.sigla-emb.
        END.
        FIND FIRST emitente 
            WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.
   
        /************************  LAYOUT 100  ***************************/ 
        RUN pi-gera-registro-100 (INPUT nota-fiscal.cod-emitente,
                                  INPUT 2).
    
        /* Gerar registro 100 para local de redespacho */
        IF  nota-fiscal.nome-tr-red <> "" THEN DO:
            find first transporte
                 where transporte.nome-abrev = nota-fiscal.nome-tr-red no-lock no-error.
            IF  AVAIL transporte THEN DO:
                FIND FIRST emitente NO-LOCK
                    WHERE  emitente.cgc = transporte.cgc NO-ERROR.
    
                IF  AVAIL emitente THEN DO:
                    RUN pi-gera-registro-100 (INPUT emitente.cod-emitente,
                                              INPUT 5).
                END.
            END.

        END.
/*                                                                                                                                               */
        FIND FIRST emitente
            WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.
/*         IF AVAIL emitente THEN DO:                                                                                                            */
/*                                                                                                                                               */
/*             FIND FIRST gr-cli WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.                                                 */
/*             IF AVAIL gr-cli THEN DO:                                                                                                          */
/* /*                 PUT STREAM s-arquivo                                                                                                    */ */
/* /*                     "102"                                        format "x(03)"             /*  1 - Registro Identificador           */ */ */
/* /*                     "TIPO DE CLIENTE"                                                                                                   */ */
/* /*                     gr-cli.descricao                             format "x(20)"             /*  3 - Tipo de Cliente                  */ */ */
/* /*                     SKIP.                                                                                                               */ */
/*             END. /* IF AVAIL gr-cli THEN DO: */                                                                                               */
/*                                                                                                                                               */
/*         END. /* IF AVAIL emitente THEN DO: */                                                                                                 */

        EMPTY TEMP-TABLE tt-nota-fiscal.
        EMPTY TEMP-TABLE tt-item-nota-fiscal.


        CREATE tt-nota-fiscal.
        ASSIGN tt-nota-fiscal.cod-estabel                   = nota-fiscal.cod-estabel
               tt-nota-fiscal.partnerType                   = "Companhia" /* IF nota-fiscal.esp-docto = 23 THEN 1 ELSE 2 */
               tt-nota-fiscal.customerCode                  = SUBSTRING(STRING(estabelec.cod-emitente,"999999"),1,6)
               tt-nota-fiscal.documentNumber                = estabelec.cgc
               tt-nota-fiscal.nr-nota-fis                   = nota-fiscal.nr-nota-fis   
               tt-nota-fiscal.serie                         = nota-fiscal.serie 
               tt-nota-fiscal.invoiceType                   = "Sa°da"
               tt-nota-fiscal.nat-operacao                  = nota-fiscal.nat-operacao /* operationType */
               tt-nota-fiscal.issueDate                     = nota-fiscal.dt-emis-nota 
               tt-nota-fiscal.dt-emis-nota                  = nota-fiscal.dt-emis-nota 
               tt-nota-fiscal.dt-saida                      = nota-fiscal.dt-saida
               tt-nota-fiscal.senderType                    = "Cliente" /* Fixo */
               tt-nota-fiscal.customerCodeSender            = nota-fiscal.cod-emitente
               tt-nota-fiscal.documentNumberSender          = emitente.cgc
               tt-nota-fiscal.consumerCodePaymentShipping   = IF substring(nota-fiscal.CHAR-2,201,8) <> "0" THEN nota-fiscal.cod-emitente ELSE estabelec.cod-emitente
               tt-nota-fiscal.documentNumberPaymentShipping = IF substring(nota-fiscal.CHAR-2,201,8) <> "0" THEN emitente.cgc ELSE estabelec.cgc
                
               tt-nota-fiscal.customerCodeShippingCompany   = b-emitente.cod-emitente
               tt-nota-fiscal.documentNumberShippingCompany = b-emitente.cgc

               tt-nota-fiscal.quantityGrossWeight           = 0
               tt-nota-fiscal.quantityCubedWeight           = 0
               tt-nota-fiscal.quantityNetWeight             = 0
               tt-nota-fiscal.kindOfPacking                 = "GEN"
               tt-nota-fiscal.quantityVolume                = 0
               tt-nota-fiscal.cod-chave-aces-nf-eletro      = nota-fiscal.cod-chave-aces-nf-eletro

        /*********************** LAYOUT - 140 ***********************/    
               tt-nota-fiscal.endereco =   nota-fiscal.endereco
               tt-nota-fiscal.bairro   =   nota-fiscal.bairro
               tt-nota-fiscal.cidade   =   nota-fiscal.cidade
               tt-nota-fiscal.estado   =   nota-fiscal.estado
               tt-nota-fiscal.cep      =   nota-fiscal.cep          /* 15 - NoCEPDestRemet                   */
               tt-nota-fiscal.nat-operacao      = nota-fiscal.nat-operacao /* operationType */
               tt-nota-fiscal.via-transp        = transporte.via-transp    /* meansOfTransport */
            //   tt-nota-fiscal.kindOfPacking     = v-cod-embalagem
               
            //   tt-nota-fiscal.transportCode     = string(b-emitente.cod-emitente) /* Ver se Ç a posiá∆o 27 - RCS - VER REDESPACHO */ 
               tt-nota-fiscal.equipmentCode = "CARRET CAV"
               tt-nota-fiscal.contractCode = "5"
               tt-nota-fiscal.shippingType = IF substring(nota-fiscal.CHAR-2,201,8) <> "0" THEN "FOB" ELSE "CIF"
               tt-nota-fiscal.nr-pedcli    = nota-fiscal.nr-pedcli
               tt-nota-fiscal.taxOperation = nota-fiscal.nat-operacao /* taxOperation*/
               /* RCS - Est† validando e n∆o aceitando em branco as observaá‰es: */
               tt-nota-fiscal.observation1  = "A"
               tt-nota-fiscal.observation2  = "A"  
               tt-nota-fiscal.observation3  = "A"
               tt-nota-fiscal.shippingStatus = "Normal".

        IF c-TpStatusDNE = "E" THEN
            ASSIGN tt-nota-fiscal.shippingPaymentStatus =  "2".
        ELSE
            ASSIGN tt-nota-fiscal.shippingPaymentStatus =  "1".                /* 45 - TpStatusDNE(1- normal, 2- cancelado) */

        ASSIGN tt-nota-fiscal.channelSales = STRING(nota-fiscal.cod-canal-venda).
        /*********************** LAYOUT - 142 ***********************/

       FIND FIRST ped-venda NO-LOCK                                                
            WHERE  ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli                      
              AND  ped-venda.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR. 

        IF  AVAIL ped-venda THEN DO:

            FIND FIRST atendente
                WHERE atendente.cd-oper = integer(ped-venda.tp-pedido) NO-LOCK NO-ERROR.
            IF AVAIL atendente THEN
                ASSIGN tt-nota-fiscal.attendant =  substring(atendente.email,1,20).

            ASSIGN tt-nota-fiscal.implementationDate = ped-venda.dt-implant.
            
            IF  ped-venda.cod-sit-ped < 4  AND ped-venda.dt-reativ <> ? THEN
                ASSIGN tt-nota-fiscal.commercialApproverUser = ped-venda.dt-reativ.
                
            IF ped-venda.dt-reativ = ? AND ped-venda.dt-useralt = ? THEN
                ASSIGN tt-nota-fiscal.commercialChangeDate1 = ped-venda.dt-entrega.
            ELSE
                IF ped-venda.dt-reativ > ped-venda.dt-useralt THEN
                   ASSIGN  tt-nota-fiscal.commercialChangeDate1 = ped-venda.dt-reativ.
                ELSE
                    ASSIGN tt-nota-fiscal.commercialChangeDate1 = ped-venda.dt-useralt.
                
            FOR FIRST int-ped-venda2 NO-LOCK
                 WHERE int-ped-venda2.nr-pedido   = ped-venda.nr-pedido
                   AND int-ped-venda2.cod-estabel = ped-venda.cod-estabel :
            END.
            
            IF  AVAIL int-ped-venda2  THEN DO:
                FIND FIRST grupo-canais NO-LOCK
                    WHERE grupo-canais.cod-gr-canais = int-ped-venda2.int-1 NO-ERROR.
                IF  AVAIL grupo-canais THEN
                    ASSIGN tt-nota-fiscal.descriptionSalesChannel = grupo-canais.descricao.
                
            END.
            
            FIND LAST historico-credito NO-LOCK
                WHERE historico-credito.nome-abrev = ped-venda.nome-abrev
                  AND historico-credito.nr-pedcli  = ped-venda.nr-pedcli NO-ERROR.
            IF AVAIL historico-credito AND historico-credito.dt-data-movto <> ? THEN
                ASSIGN tt-nota-fiscal.creditApprovalDate = historico-credito.dt-data-movto.
            ELSE DO:
                IF ped-venda.dt-apr-cred <> ? THEN
                    ASSIGN tt-nota-fiscal.creditApprovalDate = ped-venda.dt-apr-cred.
            END.

            FIND FIRST int-ped-venda2 EXCLUSIVE-LOCK 
                 WHERE int-ped-venda2.nr-pedido   = ped-venda.nr-pedido
                   AND int-ped-venda2.cod-estabel = ped-venda.cod-estabel NO-ERROR.
            IF AVAIL int-ped-venda2 THEN
                IF int-ped-venda2.dt-avaliacao <> ? THEN
                   ASSIGN tt-nota-fiscal.commercialChangeDate = int-ped-venda2.dt-avaliacao.
            

            ASSIGN tt-nota-fiscal.orderDeliveryDate = ped-venda.dt-entrega.

            FIND FIRST int-ped-trans  
                 WHERE int-ped-trans.cod-estabel = ped-venda.cod-estabel 
                   AND int-ped-trans.nome-abrev  = ped-venda.nome-abrev 
                   AND int-ped-trans.nr-pedcli   = ped-venda.nr-pedcli NO-LOCK NO-ERROR.
            IF AVAIL int-ped-trans AND int-ped-trans.lot-transp THEN
                ASSIGN tt-nota-fiscal.airTransportType = "TIPO AEREO     1".
           
            /*Leonam Alterado para 20 digitos o codigo vtex 18/05/2020*/
            IF  AVAIL int-ped-venda2 
            AND int-ped-venda2.PedidoeCommerce <> ""
            AND int-ped-venda2.PedidoeCommerce <> ?
            AND int-ped-venda2.PedidoeCommerce <> "?" THEN DO:

                FIND FIRST int-pedido-vtex NO-LOCK
                     WHERE int-pedido-vtex.nr-pedido  = int-ped-venda2.PedidoeCommerce
                       AND int-pedido-vtex.nr-pedcli  = ped-venda.nr-pedcli NO-ERROR.
                IF AVAIL int-pedido-vtex THEN DO:
                    ASSIGN c-marketplace = int-pedido-vtex.marketplace + "-".

                    ASSIGN tt-nota-fiscal.vtexPartner = c-marketplace.
                           tt-nota-fiscal.vtexOrder = substring(REPLACE(int-ped-venda2.PedidoeCommerce,c-marketplace,""),1,20).
                END.
            END.

            FIND int-ped-venda WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
                                 AND int-ped-venda.cod-estabel = ped-venda.cod-estabel
            NO-LOCK NO-ERROR.

            //Solicitado Leonam - Projeto GOL - IAB - 18/02/21
            IF AVAIL int-ped-venda THEN
               ASSIGN tt-nota-fiscal.customerOrderNumber = substring(int-ped-venda.char-1,53,12).

        END.
        
       /*********************** LAYOUT - 147 ***********************/
       FIND FIRST nota-fisc-adc NO-LOCK
            WHERE nota-fisc-adc.cod-estab    = nota-fiscal.cod-estabel
              AND nota-fisc-adc.cod-serie    = nota-fiscal.serie
              AND nota-fisc-adc.cod-nota-fis = nota-fiscal.nr-nota-fis 
              AND nota-fisc-adc.idi-tip-dado = 32 NO-ERROR. // 32 = local de retirada

       /* Redespacho */
       IF nota-fiscal.nome-tr-red <> "" OR AVAIL nota-fisc-adc THEN DO:
           IF nota-fiscal.nome-tr-red <> "" THEN DO: //tem redespacho
              find first transporte
                   where transporte.nome-abrev = nota-fiscal.nome-tr-red no-lock no-error.
              IF AVAIL transporte THEN DO:
                 FIND FIRST b-emitente NO-LOCK
                      WHERE b-emitente.cgc = transporte.cgc NO-ERROR.
                 ASSIGN i-via           = transporte.via-transp
                        i-transp-redesp = b-emitente.cod-emitente.
              END.
           END.
           ELSE IF AVAIL nota-fisc-adc  THEN DO: //tem local de retirada
               FIND FIRST b-emitente-retirada NO-LOCK
                    WHERE b-emitente-retirada.cod-emitente = int(ENTRY(1,nota-fisc-adc.cod-livre-1,"")) NO-ERROR.

               FIND FIRST b-emitente NO-LOCK
                    WHERE b-emitente.cgc = b-emitente-retirada.cgc NO-ERROR.

               find first transporte
                    where transporte.nome-abrev = nota-fiscal.nome-transp no-lock no-error.
               IF AVAIL transporte THEN DO:
                  FIND FIRST b-emitente-transp NO-LOCK 
                       WHERE b-emitente-transp.cgc = transporte.cgc NO-ERROR.

                  ASSIGN i-via           = transporte.via-transp
                         i-transp-redesp = b-emitente-transp.cod-emitente.
               END.
           END.

           ASSIGN tt-nota-fiscal.redispatchPartnerType              = "Local Redesp"
                  tt-nota-fiscal.subsidiaryCarrierDocumentNumber    = STRING(transporte.cgc) 
                  tt-nota-fiscal.redispatchCustomerCode             = STRING(b-emitente.cod-emitente)                     /*  3 - ParceiroComercial               */
                  tt-nota-fiscal.redispatchDocumentNumber           = STRING(b-emitente.cgc) 
                  tt-nota-fiscal.transportCode                      = string(int(transporte.via-transp))                 /* 21- CdMeioTransporte                 */
                  tt-nota-fiscal.carrierCode                        = i-transp-redesp
                  tt-nota-fiscal.redispatchType                     = "CIF"
                  tt-nota-fiscal.position                           =  "1".
               
               .
       END. /* IF nota-fiscal.nome-tr-red <> "" */
       ELSE DO:
           ASSIGN tt-nota-fiscal.redispatchPartnerType              = "Companhia"
                  tt-nota-fiscal.redispatchCustomerCode             = SUBSTRING(STRING(estabelec.cod-emitente,"999999"),1,6)
                  tt-nota-fiscal.redispatchDocumentNumber           = estabelec.cgc                                         
                  tt-nota-fiscal.redispatchType                     = "CIF"
                  tt-nota-fiscal.subsidiaryCarrierDocumentNumber    = b-emitente.cgc
                  tt-nota-fiscal.carrierCode                        = b-emitente.cod-emitente  
                  tt-nota-fiscal.transportCode                      = "1"
                  tt-nota-fiscal.position                           = "0".
.

       END.
       /*********************** LAYOUT - 148 ***********************/
       /* Correios PAC: 264 / E-SEDEX: 350 / SEDEX: 254*/
/*        FIND FIRST param-correios                                                                                                               */
/*            WHERE param-correios.cod-estabel = nota-fiscal.cod-estabel                                                                          */
/*              AND param-correios.tp-servico  = nota-fiscal.nome-transp NO-LOCK NO-ERROR.                                                        */
/*        IF AVAIL param-correios THEN DO:                                                                                                        */
/*                                                                                                                                                */
/*            FOR EACH volume-nf NO-LOCK                                                                                                          */
/*                WHERE volume-nf.cod-estabel     = nota-fiscal.cod-estabel                                                                       */
/*                  AND volume-nf.serie           = nota-fiscal.serie                                                                             */
/*                  AND volume-nf.nr-nota-fis     = nota-fiscal.nr-nota-fis                                                                       */
/*                BREAK BY volume-nf.nr-volume:                                                                                                   */
/*                                                                                                                                                */
/*                IF FIRST-OF(volume-nf.nr-volume) THEN DO:                                                                                       */
/*                                                                                                                                                */
/*                    FIND FIRST int-nota-conhec                                                                                                  */
/*                        WHERE int-nota-conhec.cod-estabel = nota-fiscal.cod-estabel                                                             */
/*                          AND int-nota-conhec.serie       = nota-fiscal.serie                                                                   */
/*                          AND int-nota-conhec.nr-nota-fis = nota-fiscal.nr-nota-fis                                                             */
/*                          AND int-nota-conhec.nr-volume   = volume-nf.nr-volume NO-LOCK NO-ERROR.                                               */
/*                    IF AVAIL int-nota-conhec THEN                                                                                               */
/*                        PUT STREAM s-arquivo                                                                                                    */
/*                            "148"                                          FORMAT "x(3)"             /*  1 - TpRegistro                      */ */
/*                            int-nota-conhec.nr-conhec                      FORMAT "x(20)"            /*  2 - EtiquetaCorreios                */ */
/*                            SKIP.                                                                                                               */
/*                                                                                                                                                */
/*                END.                                                                                                                            */
/*                                                                                                                                                */
/*            END.                                                                                                                                */
/*                                                                                                                                                */
/*        END. /* IF AVAIL param-correios THEN DO: */                                                                                             */

       ASSIGN v-qtd-total-volumes = 0.
       ASSIGN i-nro-itens = 0.
       for each it-nota-fisc of nota-fiscal NO-LOCK:
           ASSIGN i-nro-itens = i-nro-itens + 1.
       END.

       for each it-nota-fisc of nota-fiscal NO-LOCK,
           FIRST ITEM OF it-nota-fisc NO-LOCK
           BREAK BY it-nota-fisc.cod-estabel
                 BY it-nota-fisc.nr-nota-fis
                 BY it-nota-fisc.serie:

           ASSIGN v-cod-familia = fn-free-accent(upper(trim(it-nota-fisc.cod-unid-negoc)))
                  v-cod-item    = fn-free-accent(upper(trim(ITEM.it-codigo ))).

           IF  v-cod-item = "" THEN
               ASSIGN v-cod-item = "DD". /* Para item dÇbito direto branco, enviar DD, pois, o GKO n∆o aceita c¢digo em branco */

           /* RCS - Validar se o item j† est† integrado, caso n∆o esteja cadastrar no GKO 
              provavelmente colocar em uma procedure e chamar a API de integraá∆o           */
           IF NOT CAN-FIND(FIRST gko-item-integrado
                           WHERE gko-item-integrado.it-codigo = v-cod-item) THEN DO:
               
               FOR FIRST item-mat NO-LOCK
                   WHERE item-mat.it-codigo = it-nota-fisc.it-codigo:
               END.

               RUN pi-acompanhar IN h-acomp (INPUT "Adicionando Item: " + v-cod-item).

               RUN itemGKO.

           END.

           RUN pi-acompanhar IN h-acomp (INPUT "NF: " + string(nota-fiscal.nr-nota-fis) + " Transp: " + nota-fiscal.nome-transp + " Item: " + v-cod-item).

    
            ASSIGN v-cod-conta-contab = ""
                   v-cod-ccusto       = ""
                   v-des-tipo-carga   = "Fracionada". /* N∆o Ç mais utilizado? - RCS */
    
            IF  LAST-OF(it-nota-fisc.serie)
            THEN
                RUN pi-calcula-peso-cubado-item (YES).
            ELSE
                RUN pi-calcula-peso-cubado-item (NO).
    
            RUN pi-busca-conta-contabil.

            FIND FIRST param-correios /* Correios */
                WHERE param-correios.cod-estabel = nota-fiscal.cod-estabel
                  AND param-correios.tp-servico  = nota-fiscal.nome-transp NO-LOCK NO-ERROR.
            IF AVAIL param-correios THEN DO:
                FIND FIRST int-nota-conhec
                    WHERE int-nota-conhec.cod-estabel = nota-fiscal.cod-estabel    
                      AND int-nota-conhec.serie       = nota-fiscal.serie          
                      AND int-nota-conhec.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
                IF AVAIL int-nota-conhec THEN
                    ASSIGN v-qtd-peso-bruto = int-nota-conhec.peso-bruto / i-nro-itens.
                ELSE
                    ASSIGN v-qtd-peso-bruto = it-nota-fisc.peso-bruto / i-nro-itens.

                ASSIGN v-qtd-peso-liq   = it-nota-fisc.peso-liq-fat / i-nro-itens.
            END.
            ELSE DO:
                ASSIGN v-qtd-peso-bruto = it-nota-fisc.peso-bruto  
                       v-qtd-peso-liq   = it-nota-fisc.peso-liq-fat.
            END.

            IF  v-qtd-peso-bruto < 0.0001
            THEN
                ASSIGN v-qtd-peso-bruto = 0.0001.
    
            IF  v-qtd-peso-liq < 0.0001
            THEN
                ASSIGN v-qtd-peso-liq = 0.0001.
    
            IF  v-qtd-peso-cubado < 0.0001
            THEN
                ASSIGN v-qtd-peso-cubado = 0.0001.

/*             IF nota-fiscal.nr-nota-fis = "0028107" THEN                 */
/*                 MESSAGE "v-cod-conta-contab-> " v-cod-conta-contab SKIP */
/*                         "v-cod-ccusto-> " v-cod-ccusto                  */
/*                     VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.           */

            /* RCS - Criar aqui os itens da Nota Fiscal */

           CREATE tt-item-nota-fiscal.
           ASSIGN tt-item-nota-fiscal.cod-estabel          = nota-fiscal.cod-estabel
                  tt-item-nota-fiscal.cod-emitente         = nota-fiscal.cod-emitente
                  tt-item-nota-fiscal.nr-nota-fis          = nota-fiscal.nr-nota-fis      
                  tt-item-nota-fiscal.serie                = nota-fiscal.serie
                           
                  tt-item-nota-fiscal.it-codigo            = it-nota-fisc.it-codigo
                  tt-item-nota-fiscal.nr-seq-fat           = it-nota-fisc.nr-seq-fat
                  tt-item-nota-fiscal.DNEItemValue         = STRING(round(it-nota-fisc.vl-tot-item,2))
                  tt-item-nota-fiscal.quantity             = STRING(round(it-nota-fisc.qt-faturada[1],2))
                  tt-item-nota-fiscal.unit                 = fn-free-accent(upper(trim(it-nota-fisc.un-fatur[1])))
                  tt-item-nota-fiscal.peso-liq-fat         = STRING(v-qtd-peso-liq)
                  tt-item-nota-fiscal.quantityCubedWeight  = 0 // v-qtd-peso-cubado
                  tt-item-nota-fiscal.peso-bruto           = STRING(v-qtd-peso-bruto)
                  tt-item-nota-fiscal.cubageValue          = STRING(v-qtd-peso-cubado) // v-qtd-volumes
                  tt-item-nota-fiscal.quantityVolume       = int(v-qtd-volumes)
                  tt-item-nota-fiscal.costCenterCode       = v-cod-ccusto       /* v-cod-ccusto         */
                  tt-item-nota-fiscal.accountingAccount    = v-cod-conta-contab /* v-cod-conta-contab   */
                  tt-item-nota-fiscal.shippingCanceled     = NO
                  tt-item-nota-fiscal.ICMSCreditStatus     = YES
                  tt-item-nota-fiscal.taxStatus1           = NO
                  tt-item-nota-fiscal.taxStatus2           = NO
                  tt-item-nota-fiscal.taxStatus3           = NO.

      end. /* for each it-nota-fisc of nota-fiscal NO-LOCK, */

      IF NOT VALID-HANDLE(h-gkapi0012) THEN
            RUN esp/gko/gkapi012.p persistent set h-gkapi0012.

      RUN integrarNotaFiscal IN h-gkapi0012 (INPUT TABLE tt-nota-fiscal,
                                             INPUT TABLE tt-item-nota-fiscal).

      
      ASSIGN h-gkapi0012 = ? NO-ERROR.
      DELETE OBJECT h-gkapi0012 NO-ERROR.
  

END PROCEDURE.

PROCEDURE imprimi-nf-entrada-arquivo:

    
        IF  docum-est.cod-estabel < tt-param.cod-estab-ini OR
            docum-est.cod-estabel > tt-param.cod-estab-fim THEN NEXT. 

        IF docum-est.nro-docto < tt-param.num-nota-ini OR
           docum-est.nro-docto > tt-param.num-nota-fim  THEN NEXT. 

        IF docum-est.serie-docto < tt-param.serie-ini OR
           docum-est.serie-docto > tt-param.serie-fim  THEN NEXT.

        FIND FIRST tt-cliente NO-LOCK
            WHERE  tt-cliente.cod-emitente = docum-est.cod-emitente NO-ERROR.
        IF AVAIL tt-cliente
            AND (tt-cliente.cod-estabel <> ""
              and tt-cliente.cod-estabel = docum-est.cod-estabel) THEN
                NEXT.
        
       /*     FIND FIRST tt-series NO-LOCK
                WHERE  tt-series.serie = docum-est.serie-docto NO-ERROR.
            IF  NOT AVAIL tt-series THEN NEXT.*/

    
 
/*             IF tt-param.log-correios = NO THEN DO:                                        */
/*                 FIND FIRST tt-transportadora NO-LOCK                                      */
/*                     WHERE  tt-transportadora.nome-abrev = docum-est.nome-transp NO-ERROR. */
/*                 IF  AVAIL tt-transportadora THEN NEXT.                                    */
/*             END. /* IF tt-param.log-correios = NO THEN DO: */                             */

    
        FIND FIRST transporte NO-LOCK
            WHERE  transporte.nome-abrev = docum-est.nome-transp NO-ERROR.
         
        ASSIGN v-cod-tipo-operac = "A"
               c-TpStatusDNE     = "A".

        /*Verificar nota de devoluá∆o*/
        FIND FIRST devol-cli 
             WHERE devol-cli.cod-estabel = docum-est.cod-estabel
               AND devol-cli.serie       = docum-est.serie-docto 
               AND devol-cli.nr-nota-fis = docum-est.nro-docto NO-LOCK NO-ERROR.
        IF AVAIL devol-cli THEN
            FIND FIRST int-docum-est
                 WHERE int-docum-est.serie-docto  = devol-cli.serie-docto
                   AND int-docum-est.nro-docto    = devol-cli.nro-docto
                   AND int-docum-est.cod-emitente = devol-cli.cod-emitente
                   AND int-docum-est.nat-operacao = devol-cli.nat-operacao 
                   AND (int-docum-est.cod-msg-devolucao = 500
                    OR  int-docum-est.cod-msg-devolucao = 521) NO-LOCK NO-ERROR.
    
     /*   IF (AVAIL devol-cli AND AVAIL int-docum-est) OR docum-est.dt-cancel <> ? THEN
            ASSIGN c-TpStatusDNE = "E".
    
        IF  docum-est.dt-cancela <> ? THEN ASSIGN v-cod-tipo-operac = "E".
    */
        /* Validar nota jò integrada */ 

        IF  tt-param.log-reexportar = NO THEN DO:

            IF CAN-FIND(FIRST gko-nfs-integrada                                                                                                               
                        WHERE gko-nfs-integrada.cod-estabel              = docum-est.cod-estabel                                                                        
                          AND gko-nfs-integrada.serie                    = docum-est.serie-docto                                                                              
                          AND gko-nfs-integrada.nr-nota-fis              = docum-est.nro-docto
                          AND gko-nfs-integrada.cod-chave-aces-nf-eletr  = docum-est.cod-chave-aces-nf-eletro  
                          AND gko-nfs-integrada.cod-emitente             = docum-est.cod-emitente            
                     /*      AND gko-nfs-integrada.tipo-operacao = c-TpStatusDNE */ ) 
            THEN NEXT. 
          
    
            
        END. /* tt-param.log-reexportar = NO THEN DO: */
        ELSE DO:
            IF NOT CAN-FIND(FIRST gko-nfs-integrada                                                                                                               
                            WHERE gko-nfs-integrada.cod-estabel              = docum-est.cod-estabel                                                                        
                              AND gko-nfs-integrada.serie                    = docum-est.serie-docto                                                                              
                              AND gko-nfs-integrada.nr-nota-fis              = docum-est.nro-docto
                              AND gko-nfs-integrada.cod-chave-aces-nf-eletr  = docum-est.cod-chave-aces-nf-eletro
                              AND gko-nfs-integrada.cod-emitente             = docum-est.cod-emitente            
                           /*   AND gko-nfs-integrada.tipo-operacao = c-TpStatusDNE */ ) 
            THEN NEXT. 
        END.

        EMPTY TEMP-TABLE tt-volume-item-nf.

        //modificando para gerar um arquivo por nota.

    /* FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE */
    /* FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE */
    /************************  LAYOUT 000  ***************************/
/*         ASSIGN v-cod-arq-destino = v-cod-arq-destino-aux                 */
/*                                  + "FRDNE"                               */
/*                                  + STRING(docum-est.nro-docto)           */
/*                                  + string(day(TODAY),"99")               */
/*                                  + string(month(TODAY),"99")             */
/*                                  + string(YEAR(TODAY),"9999")            */
/*                                  + string(TIME)                          */
/*                                  + ".txt".                               */
/*                                                                          */
/*         output STREAM s-arquivo to value(v-cod-arq-destino) page-size 0. */

        //modificando para gerar um arquivo por nota. RCS - N∆o ter† mais esse cabeáalho
/*         PUT STREAM s-arquivo                                */
/*           "000"       FORMAT "x(03)" /* 1 - TpRegistro   */ */
/*           "IntDNE"    FORMAT "x(10)" /* 2 - NmInterface  */ */
/*           "6.42a"     FORMAT "x(06)" /* 3 - Versao       */ */
/*           "INTELBRAS" FORMAT "x(40)" /* 4 - Remetente    */ */
/*           "GKO"       FORMAT "x(40)" /* 5 - Destinatario */ */
/*           "EMS"       FORMAT "x(03)" /* 6 - CdAmbiente   */ */
/*         SKIP.                                               */
        
        RUN pi-acompanhar IN h-acomp (INPUT "NF Entrada: " + string(docum-est.nro-docto) + " Transp: " + docum-est.nome-transp).

        FIND estabelec NO-LOCK
            WHERE estabelec.cod-estabel = docum-est.cod-estabel NO-ERROR.

        FIND FIRST b-emitente NO-LOCK
            WHERE  b-emitente.cgc = transporte.cgc NO-ERROR.

        ASSIGN v-ind-modal-peso-cubado = transporte.via-transp WHEN AVAIL transporte.
        
        /*---------------------- Grava os Dados da Nota Fiscal ------------------*/        
    
        find first natur-oper
             where natur-oper.nat-operacao = docum-est.nat-operacao no-lock no-error.
        find first estabelec
             where estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
    
        for FIRST nota-embal use-index ch-nota-emb NO-LOCK
            where nota-embal.cod-estabel = docum-est.cod-estabel
              and nota-embal.serie       = docum-est.serie-docto
              and nota-embal.nr-nota-fis = docum-est.nro-docto:
            ASSIGN v-cod-embalagem = nota-embal.sigla-emb.
        END.
        FIND FIRST emitente 
            WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.

        /************************  LAYOUT 100  ***************************/ 
        RUN pi-gera-registro-100 (INPUT /*estabelec.cod-emitente,*/ docum-est.cod-emitente,
                                  INPUT 2).

        
/*         FIND FIRST emitente                                                                                                                   */
/*             WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.                                                            */
/*         IF AVAIL emitente THEN DO:                                                                                                            */
/*                                                                                                                                               */
/*             FIND FIRST gr-cli WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.                                                 */
/*             IF AVAIL gr-cli THEN DO:                                                                                                          */
/* /*                 PUT STREAM s-arquivo                                                                                                    */ */
/* /*                     "102"                                        format "x(03)"             /*  1 - Registro Identificador           */ */ */
/* /*                     "TIPO DE CLIENTE"                                                                                                   */ */
/* /*                     gr-cli.descricao                             format "x(20)"             /*  3 - Tipo de Cliente                  */ */ */
/* /*                     SKIP.                                                                                                               */ */
/*             END. /* IF AVAIL gr-cli THEN DO: */                                                                                               */
/*                                                                                                                                               */
/*         END. /* IF AVAIL emitente THEN DO: */                                                                                                 */

        EMPTY TEMP-TABLE tt-nota-fiscal.
        EMPTY TEMP-TABLE tt-item-nota-fiscal.

        /* Criar informaá∆o da nota - RCS */
        CREATE tt-nota-fiscal.
        ASSIGN tt-nota-fiscal.cod-estabel                           = docum-est.cod-estabel
               tt-nota-fiscal.partnerType                           = "Cliente"
               tt-nota-fiscal.customerCode                          = SUBSTRING(STRING(docum-est.cod-emitente,"999999"),1,6)
               tt-nota-fiscal.documentNumber                        = emitente.cgc
               tt-nota-fiscal.nr-nota-fis                           = docum-est.nro-docto
               tt-nota-fiscal.serie                                 = docum-est.serie-docto
               tt-nota-fiscal.invoiceType                           = "Entrada"
               tt-nota-fiscal.nat-operacao                          = docum-est.nat-operacao
               tt-nota-fiscal.issueDate                             = docum-est.dt-emissao
               tt-nota-fiscal.dt-emis-nota                          = docum-est.dt-emissao
/*                tt-nota-fiscal.dt-saida                              = ?                                                    */
               tt-nota-fiscal.senderType                            = "Companhia"
               tt-nota-fiscal.customerCodeSender                    = estabelec.cod-emitente
               tt-nota-fiscal.documentNumberSender                  = estabelec.cgc
               tt-nota-fiscal.shippingType                          = "FOB" /* Segunda a l¢gica antiga era fixo FOB */
               tt-nota-fiscal.consumerCodePaymentShipping           = estabelec.cod-emitente
               tt-nota-fiscal.documentNumberPaymentShipping         = estabelec.cgc
               tt-nota-fiscal.customerCodeShippingCompany           = b-emitente.cod-emitente
               tt-nota-fiscal.documentNumberShippingCompany         = b-emitente.cgc


              /* tt-nota-fiscal.customerCodeShippingCompany         Enviar se o sistema reconhece transportador externo */
               tt-nota-fiscal.via-transp                            = transporte.via-transp
               tt-nota-fiscal.taxOperation                          = docum-est.nat-operacao
               tt-nota-fiscal.kindOfPacking                         = "GEN"

               tt-nota-fiscal.cod-chave-aces-nf-eletro              = docum-est.cod-chave-aces-nf-eletro
               tt-nota-fiscal.documentIsPreparation                 = NO
               tt-nota-fiscal.documentNeedsCompleted                = NO
               tt-nota-fiscal.shippingPaymentStatus                 = "Normal"
               tt-nota-fiscal.observation1                          = "A"
               tt-nota-fiscal.observation2                          = "A"
               tt-nota-fiscal.observation3                          = "A"
               tt-nota-fiscal.channelSales                          = "CANAL_VENDA"
               tt-nota-fiscal.attendant                             = "ATENDENTE"
/*                tt-nota-fiscal.commercialChangeDate1  */
               tt-nota-fiscal.descriptionSalesChannel               = "CANAL_VENDA"
/*                tt-nota-fiscal.implementationDate   */
/*                tt-nota-fiscal.creditApprovalDate   */
/*                tt-nota-fiscal.commercialChangeDate */
/*                tt-nota-fiscal.orderDeliveryDate    */
/*                tt-nota-fiscal.airTransportType     */
/*                tt-nota-fiscal.vtexPartner          */
/*                tt-nota-fiscal.vtexOrder            */
/*                tt-nota-fiscal.customerOrderNumber  */
               tt-nota-fiscal.bairro                                = docum-est.bairro
               tt-nota-fiscal.cep                                   = docum-est.cep
               tt-nota-fiscal.endereco                              = docum-est.endereco
               tt-nota-fiscal.cidade                                = docum-est.cidade
               tt-nota-fiscal.estado                                = docum-est.uf.

       
        /* REDESPACHO INFORMAÄÂES FIXAS */                                                                                
        ASSIGN tt-nota-fiscal.redispatchPartnerType            = "Companhia"                                                
               tt-nota-fiscal.redispatchCustomerCode           = SUBSTRING(STRING(estabelec.cod-emitente,"999999"),1,6)   
               tt-nota-fiscal.redispatchDocumentNumber         = estabelec.cgc                                            
               tt-nota-fiscal.subsidiaryCarrierDocumentNumber  = STRING(transporte.cgc) WHEN AVAIL transporte             
               tt-nota-fiscal.carrierCode                      = b-emitente.cod-emitente                                  
               tt-nota-fiscal.equipmentCode                    = "CARRET CAV"                                             
               tt-nota-fiscal.transportCode                    = "1"                                                      
               tt-nota-fiscal.contractCode                     = "5"                                                      
               tt-nota-fiscal.redispatchType                   = "FOB"                                                    
               tt-nota-fiscal.differentiatedShipping           = 0                                                        
               tt-nota-fiscal.POSITION                         = "99"                                                      
               tt-nota-fiscal.shippingStatus                   = "Normal".


       ASSIGN i-nro-itens = 0.
       for each item-doc-est of docum-est NO-LOCK:
           ASSIGN i-nro-itens = i-nro-itens + 1.
       END.
       for each item-doc-est of docum-est NO-LOCK,
            FIRST ITEM OF item-doc-est NO-LOCK
           BREAK BY item-doc-est.nro-docto
                 BY item-doc-est.serie-docto
                 :

           ASSIGN v-cod-familia = fn-free-accent(upper(trim(item-doc-est.cod-unid-negoc)))
                  v-cod-item    = fn-free-accent(upper(trim(ITEM.it-codigo ))).

           RUN pi-acompanhar IN h-acomp (INPUT "NF Entrada: " + string(docum-est.nro-docto) + " Transp: " + docum-est.nome-transp + " Item: " + v-cod-item).
           
           IF  v-cod-item = "" THEN
               ASSIGN v-cod-item = "DD". /* Para item d˝bito direto branco, enviar DD, pois, o GKO n o aceita c´digo em branco */

           /* RCS - Validar se o item j† est† integrado, caso n∆o esteja cadastrar no GKO 
              provavelmente colocar em uma procedure e chamar a API de integraá∆o           */
           IF NOT CAN-FIND(FIRST gko-item-integrado
                            WHERE gko-item-integrado.it-codigo = v-cod-item) THEN DO:
               RUN pi-acompanhar IN h-acomp (INPUT "Item: " + v-cod-item).

               FOR FIRST item-mat NO-LOCK
                   WHERE item-mat.it-codigo = item-doc-est.it-codigo:
               END.

               RUN itemGKO.
           END.

           ASSIGN v-cod-conta-contab = item-doc-est.conta-contabil
                   v-cod-ccusto       = item-doc-est.sc-codigo
                   v-des-tipo-carga   = "Fracionada".
                ASSIGN v-qtd-peso-bruto = item-doc-est.peso-bruto-item  
                       v-qtd-peso-liq   = item-doc-est.peso-liquido.
            IF  v-qtd-peso-bruto < 0.0001 
            THEN
                ASSIGN v-qtd-peso-bruto = 0.0001.
    
            IF  v-qtd-peso-liq < 0.0001 
            THEN
                ASSIGN v-qtd-peso-liq = 0.0001.
    
            IF  v-qtd-peso-cubado < 0.0001 
            THEN
                ASSIGN v-qtd-peso-cubado = 0.0001.
            
       

                      find last movto-estoq 
                         where movto-estoq.cod-estabel  = docum-est.cod-estabel
                           and movto-estoq.serie-docto  = item-doc-est.serie-docto
                           and movto-estoq.nro-docto    = item-doc-est.nro-docto
                           and movto-estoq.cod-emitente = item-doc-est.cod-emitente 
                           and movto-estoq.it-codigo = item-doc-est.it-codigo 
                           and (movto-estoq.esp-docto = 21 or movto-estoq.esp-docto = 28)
                           and movto-estoq.tipo-trans = 2 no-lock no-error.
                             if avail movto-estoq then do:
                              if v-cod-conta-contab = "" then do:
                                assign v-cod-conta-contab       =  movto-estoq.ct-codigo.
                              end.  
                              if v-cod-ccusto = "" then do:
                                assign v-cod-ccusto       =  movto-estoq.sc-codigo.
                              end.
                             end. 
                             else assign v-cod-conta-contab       =  "000001"
                                         v-cod-ccusto       = "000001". 
     
     
/********************************   retirado para colocar no es0018 - Leonam 18/10
*********************************                   /*devoluªío */          
*********************************             if lookup(docum-est.nat-operacao,"120100,120101,120102,120106,120110,120112,120116,1201X0,1201XA"  + "," +
*********************************                                                "120200,120201,120202,120203,1202a0,1203a1,141000,141001,1410A0" + "," +
*********************************                                                "1410A1,1410X0,1410X1,141100,141101,220100,220102,220103,220104" + "," +
*********************************                                                "220105,220106,220107,220108,220109,220110,220113,220115,2201A0" + "," +
*********************************                                                "2201A1,2201A2,2201A3,2201a4,2201A5,2201A7,2201X0,2201X4,2201XA" + "," +
*********************************                                                "220200,220202,220203,220206,220207,220208,220300,220301,2203A0" + "," +
*********************************                                                "2203A1,2203X0,2203X1,241000,241001,241003,2410A0,2410A1,2410X0" + "," +
*********************************                                                "2410X1,241100,241101,241102,241103,241104,250300,250301") > 0 then do:
*********************************                  assign v-cod-conta-contab = "41110015".           
*********************************                     /*Comercial Variavel  MI-Segur. EletrÀnica*/
*********************************                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "SEC" then  
*********************************                     assign v-cod-ccusto       = "004" + "21045".
*********************************                     /*Comercial Variˇvel  MI - Energia*/
*********************************                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "ENG" then  
*********************************                    assign v-cod-ccusto       = "015" + "21026".
*********************************                     /*Comercial Variavel  MI - Energia Solar*/
*********************************                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "ENS" then  
*********************************                     assign v-cod-ccusto       = "016" + "21028".                     
*********************************                     /*Comercial Variavel MI - Incºndio e Ilumi*/
*********************************                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "FIR" then  
*********************************                     assign v-cod-ccusto       = "010" + "21030".                                         	
*********************************                     /*Comercial Variavel MI - Comunicaªío*/
*********************************                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "TER" then  
*********************************                     assign v-cod-ccusto       = "003" + "21040". 	
*********************************                     /*Comercial Variavel MI-Controle de Acesso*/
*********************************                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "AUT" then  
*********************************                     assign v-cod-ccusto       = "011" + "21044". 		
*********************************                     /*Comercial Variavel  MI - Redes*/
*********************************                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "NET" then  
*********************************                     assign v-cod-ccusto       = "005" + "21048". 	
*********************************              end.
*********************************              
*********************************              if lookup(docum-est.nat-operacao,"1915,19150,194907,194909,194910,194926,194935,194939,194940" + "," +
*********************************                                               "194941,194945,291500,291501,294911,294912,294914,294928,294933" + "," + 
*********************************                                               "294935,294938,294962,294910") > 0 then do:
*********************************                  assign v-cod-conta-contab = "41430020".
*********************************                
*********************************                     /*PΩs-Venda - Comunicaªío*/
*********************************                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "TER" then  
*********************************                     assign v-cod-ccusto       = "003" + "23410".
*********************************                     /*PΩs-Venda - Seguranªa EletrÀnica*/
*********************************                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "SEC" then  
*********************************                     assign v-cod-ccusto       = "004" + "23430".
*********************************                     /*PΩs-Venda - Controle de Acesso*/
*********************************                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "AUT" then  
*********************************                     assign v-cod-ccusto       = "011" + "23435".                     
*********************************                     /*PΩs-Venda - Redes*/
*********************************                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "NET" then  
*********************************                     assign v-cod-ccusto       = "005" + "23440".                                         	
*********************************                     /*PΩs-Venda - Energia Solar*/
*********************************                   if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "ENS" then  
*********************************                     assign v-cod-ccusto       = "016" + "23445". 	
*********************************                     /*PΩs-Venda - Energia*/
*********************************                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "ENG" then  
*********************************                     assign v-cod-ccusto       = "015" + "23496".  
*********************************                 /*PΩs-Venda - Controle de Acesso*/
*********************************                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "FIR" then  
*********************************                     assign v-cod-ccusto       = "010" + "23435".                      
*********************************              end.                                 
*********************************
*********************************   retirado para colocar no es0018 - Leonam 18/10 */

/***********************************devoluªío **********************************/
              EMPTY TEMP-TABLE tt-prog-pont5.
              RUN esp/es0018p.p (INPUT "gk0001":U,
                                 INPUT 5,
                                 INPUT 0,
                                 INPUT "":U,
                                 OUTPUT TABLE tt-prog-pont5).
                                  
              if CAN-FIND(FIRST tt-prog-pont5
                          WHERE tt-prog-pont5.conteudo = docum-est.nat-operacao) then do:

                  assign v-cod-conta-contab = "41110015".           
                     /*Comercial Variavel  MI-Segur. EletrÀnica*/
                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "SEC" then  
                     assign v-cod-ccusto       = "004" + "21045".
                     /*Comercial Variˇvel  MI - Energia*/
                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "ENG" then  
                     assign v-cod-ccusto       = "015" + "21026".
                     /*Comercial Variavel  MI - Energia Solar*/
                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "ENS" then  
                     assign v-cod-ccusto       = "016" + "21028".                     
                     /*Comercial Variavel MI - Incºndio e Ilumi*/
                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "FIR" then  
                     assign v-cod-ccusto       = "010" + "21030".                                         	
                     /*Comercial Variavel MI - Comunicaªío*/
                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "TER" then  
                     assign v-cod-ccusto       = "003" + "21040". 	
                     /*Comercial Variavel MI-Controle de Acesso*/
                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "AUT" then  
                     assign v-cod-ccusto       = "011" + "21044". 		
                     /*Comercial Variavel  MI - Redes*/
                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "NET" then  
                     assign v-cod-ccusto       = "005" + "21048". 	
              end.
              EMPTY TEMP-TABLE tt-prog-pont6.
/*******************************pos venda*********************************/
               RUN esp/es0018p.p (INPUT "gk0001":U,            
                                  INPUT 6,                     
                                  INPUT 0,                     
                                  INPUT "":U,                  
                                  OUTPUT TABLE tt-prog-pont6). 
                                  
              if CAN-FIND(FIRST tt-prog-pont6
                             WHERE tt-prog-pont6.conteudo = docum-est.nat-operacao) then do:

                  assign v-cod-conta-contab       =  "41430020".
                
                     /*PΩs-Venda - Comunicaªío*/
                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "TER" then  
                     assign v-cod-ccusto       = "003" + "23410".
                     /*PΩs-Venda - Seguranªa EletrÀnica*/
                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "SEC" then  
                     assign v-cod-ccusto       = "004" + "23430".
                     /*PΩs-Venda - Controle de Acesso*/
                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "AUT" then  
                     assign v-cod-ccusto       = "011" + "23435".                     
                     /*PΩs-Venda - Redes*/
                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "NET" then  
                     assign v-cod-ccusto       = "005" + "23440".                                         	
                     /*PΩs-Venda - Energia Solar*/
                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "ENS" then  
                     assign v-cod-ccusto       = "016" + "23445". 	
                     /*PΩs-Venda - Energia*/
                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "ENG" then  
                     assign v-cod-ccusto       = "015" + "23496".  
                 /*PΩs-Venda - Controle de Acesso*/
                  if fn-free-accent(upper(trim(ITEM.cod-unid-negoc))) = "FIR" then  
                     assign v-cod-ccusto       = "010" + "23435".                      
              end.                                 
              EMPTY TEMP-TABLE tt-prog-pont7.  
/********************************outras entradas*************************/ 
  
              RUN esp/es0018p.p (INPUT "gk0001":U,
                                 INPUT 7,
                                 INPUT 0,
                                 INPUT "":U,
                                 OUTPUT TABLE tt-prog-pont7).
                                  
              if CAN-FIND(FIRST tt-prog-pont7
                             WHERE tt-prog-pont7.conteudo = docum-est.nat-operacao) then do:
                  assign v-cod-conta-contab = "41540005".  
                  assign v-cod-ccusto       = "00000001".
                  FIND FIRST int-docum-est no-LOCK  
                       WHERE int-docum-est.serie-docto  = docum-est.serie-docto
                         AND int-docum-est.nro-docto    = docum-est.nro-docto
                         AND int-docum-est.cod-emitente = docum-est.cod-emitente
                         AND int-docum-est.nat-operacao = docum-est.nat-operacao NO-ERROR.
                  IF AVAIL int-docum-est THEN
                    ASSIGN v-cod-ccusto = "001" + int-docum-est.cod-ccusto-nf-terc.
              end.
              EMPTY TEMP-TABLE tt-prog-pont8.  
/*****************************Consumo********************************/

   
              RUN esp/es0018p.p (INPUT "gk0001":U,
                                 INPUT 8,
                                 INPUT 0,
                                 INPUT "":U,
                                 OUTPUT TABLE tt-prog-pont8).                                
              if CAN-FIND(FIRST tt-prog-pont8
                             WHERE tt-prog-pont8.conteudo = docum-est.nat-operacao) then do:
                  assign v-cod-conta-contab = "00000000".  
                  assign v-cod-ccusto       = "00000001".

                  if fn-free-accent(upper(trim(item-doc-est.cod-unid-negoc))) = "SEC" then  
                     assign v-cod-ccusto       = "004" + item-doc-est.sc-codigo.
                     /*Comercial Variˇvel  MI - Energia*/
                  if fn-free-accent(upper(trim(item-doc-est.cod-unid-negoc))) = "ENG" then  
                     assign v-cod-ccusto       = "015" + item-doc-est.sc-codigo.
                     /*Comercial Variavel  MI - Energia Solar*/
                  if fn-free-accent(upper(trim(item-doc-est.cod-unid-negoc))) = "ENS" then  
                     assign v-cod-ccusto       = "016" + item-doc-est.sc-codigo.                     
                     /*Comercial Variavel MI - Incºndio e Ilumi*/
                  if fn-free-accent(upper(trim(item-doc-est.cod-unid-negoc))) = "FIR" then  
                     assign v-cod-ccusto       = "010" + item-doc-est.sc-codigo.                                         	
                     /*Comercial Variavel MI - Comunicaªío*/
                  if fn-free-accent(upper(trim(item-doc-est.cod-unid-negoc))) = "TER" then  
                     assign v-cod-ccusto       = "003" + item-doc-est.sc-codigo. 	
                     /*Comercial Variavel MI-Controle de Acesso*/
                  if fn-free-accent(upper(trim(item-doc-est.cod-unid-negoc))) = "AUT" then  
                     assign v-cod-ccusto       = "011" + item-doc-est.sc-codigo. 		
                     /*Comercial Variavel  MI - Redes*/
                  if fn-free-accent(upper(trim(item-doc-est.cod-unid-negoc))) = "NET" then  
                     assign v-cod-ccusto       = "005" + item-doc-est.sc-codigo. 
                  if fn-free-accent(upper(trim(item-doc-est.cod-unid-negoc))) = "ADM" then  
                     assign v-cod-ccusto       = "001" + item-doc-est.sc-codigo.                      
                  assign v-cod-conta-contab = item-doc-est.ct-codigo. 
              end.

              /* RCS - Itens da nota de entrada (Recebimento)*/
              CREATE tt-item-nota-fiscal.
              ASSIGN tt-item-nota-fiscal.cod-estabel          = docum-est.cod-estabel
                     tt-item-nota-fiscal.cod-emitente         = docum-est.cod-emitente
                     tt-item-nota-fiscal.nr-nota-fis          = docum-est.nro-docto      
                     tt-item-nota-fiscal.serie                = docum-est.serie-docto
                              
                     tt-item-nota-fiscal.it-codigo            = v-cod-item
                     tt-item-nota-fiscal.nr-seq-fat           = item-doc-est.sequencia
                     tt-item-nota-fiscal.DNEItemValue         = STRING(round(item-doc-est.preco-total[1],2))
                     tt-item-nota-fiscal.quantity             = STRING(i-nro-itens)
                    // tt-item-nota-fiscal.unit                 = fn-free-accent(upper(trim(it-nota-fisc.un-fatur[1])))
                     tt-item-nota-fiscal.peso-liq-fat         = STRING(v-qtd-peso-liq)
                     tt-item-nota-fiscal.quantityCubedWeight  = 0 // v-qtd-peso-cubado
                     tt-item-nota-fiscal.peso-bruto           = STRING(round(v-qtd-peso-liq /*v-qtd-peso-bruto*/,4))
                     tt-item-nota-fiscal.cubageValue          = TRIM(STRING(0.0001,">>>>>>>>>9.9999")) // v-qtd-volumes
                     tt-item-nota-fiscal.quantityVolume       = i-nro-itens 
                     tt-item-nota-fiscal.costCenterCode       = v-cod-ccusto       /* v-cod-ccusto         */
                     tt-item-nota-fiscal.accountingAccount    = v-cod-conta-contab /* v-cod-conta-contab   */
                     tt-item-nota-fiscal.shippingCanceled     = NO
                     tt-item-nota-fiscal.ICMSCreditStatus     = NO
                     tt-item-nota-fiscal.taxStatus1           = NO
                     tt-item-nota-fiscal.taxStatus2           = NO
                     tt-item-nota-fiscal.taxStatus3           = NO.

/*             put STREAM s-arquivo                                                                                                                                                                           */
/*                 "160"                                                 format "x(03)"             /*  1 - TpRegistro        */                                                                              */
/*                 "A"                                                   format "x(01)"             /*  2 - FlOperacao        */                                                                              */
/*                 1                                                     format "9"                 /*  3 - TpParceiroComercial             */                                                                */
/*                 STRING(estabelec.cod-emitente)                        FORMAT "x(14)"             /*  3 - ParceiroComercial               */                                                                */
/*                 STRING(INT(docum-est.nro-docto),"999999999999")       format "x(12)"             /*  4 - CdNota            */                                                                              */
/*                 upper(trim(docum-est.serie-docto))                    format "x(03)"             /*  5 - CdSerie           */                                                                              */
/*                 item-doc-est.sequencia                                format "999"               /*  6 - NoNtaItem         */                                                                              */
/*                 v-cod-item                                            format "x(20)"             /*  7 - CdItem            */                                                                              */
/*                 round(item-doc-est.preco-total[1],2)  * 100           format "999999999999"      /*  8 - VrNtaItem         */                                                                              */
/*                 round(v-qtd-peso-liq /*v-qtd-peso-bruto*/,4) * 10000  format "999999999999999"   /*  9 - QtPesoBruto       */                                                                              */
/*                 round(v-qtd-peso-liq /*v-qtd-peso-bruto*/,4) * 10000  format "999999999999999"   /* 10 - QtPesoCubado      */                                                                              */
/*                 round(v-qtd-peso-liq /*v-qtd-peso-liq*/,4)   * 10000  format "999999999999999"   /* 11 - QtPesoLiquido     */                                                                              */
/*                 i-nro-itens /*v-qtd-volumes */                        format "9999"              /* 12 - QtVolume          */                                                                              */
/*                 /*round(v-qtd-peso-cubado,4)*/ 0                      format "9999999999"        /* 13 - VrCubagem         */                                                                              */
/*                 v-cod-conta-contab                                    FORMAT "9999999999999999"  /* 14 - CdContaContabil   */                                                                              */
/*                 v-cod-ccusto                                          format "9999999999"        /* 15 - CdCentroCusto     */                                                                              */
/*                 round(item-doc-est.quantidade,4) * 100                format "999999999999999"   /* 16 - QtItem            */                                                                              */
/*                 space(3)                                                                         /* 17 - DsUnItem          */                                                                              */
/*                 0                                                     format "999999999999999"   /* 18 - VrFretePgCliTab   */                                                                              */
/*                 0                                                     format "999999999999999"   /* 19 - VrFretePgCliente  */                                                                              */
/*                 0                                                     FORMAT "9"                 /* 20 - StCreditoICMS     */                                                                              */
/*                 0                                                     FORMAT "9"                 /* 21 - StCreditoImposto1 */                                                                              */
/*                 0                                                     FORMAT "9"                 /* 22 - StCreditoImposto2 */                                                                              */
/*                 0                                                     FORMAT "9"                 /* 23 - StCreditoImposto3 */                                                                              */
/*                 v-des-tipo-carga                                      FORMAT "x(10)"             /* 24 - TxObservacao - Utilizado para filtrar tipo de carga no relat´rio de embarques, chamado IR87345 */ */
/*                 item-doc-est.nat-operacao                             FORMAT "x(6)"                                                                                                                        */
/*                 skip.                                                                                                                                                                                      */
      end. /* for each it-docum-est of docum-est NO-LOCK, */

        IF NOT VALID-HANDLE(h-gkapi0012) THEN
            RUN esp/gko/gkapi012.p persistent set h-gkapi0012.
        
        RUN integrarNotaFiscal IN h-gkapi0012 (INPUT TABLE tt-nota-fiscal,
                                               INPUT TABLE tt-item-nota-fiscal).

END PROCEDURE. /*imprimi-nf-entrada-arquivo*/

PROCEDURE itemGKO:

    EMPTY TEMP-TABLE tt-material.

    /*********************** LAYOUT - 150 ***********************/
    CREATE tt-material.
    ASSIGN tt-material.desc-item             = substring(item.desc-item,1,40)
           tt-material.it-codigo             = v-cod-item
           tt-material.itemType              = 1 /* Ser† fixo como material sempre? Tem momentos que ser† serviáo? */
           tt-material.altura                = STRING(IF item.altura  > 0 THEN item.altura  ELSE 0.1)               
           tt-material.largura               = STRING(IF item.largura > 0 THEN item.largura ELSE 0.1)              
           tt-material.comprim               = STRING(IF item.comprim > 0 THEN item.comprim ELSE 0.1)              
           tt-material.cod-unid-negoc        = ITEM.cod-unid-negoc /* Ver como enviar a unidade de neg¢cio quando for reenvio, pois n∆o ter† a nota dispon°vel */
           tt-material.fm-cod-com            = SUBSTRING(item.fm-cod-com,1,4)             
           tt-material.cod-ean               = item-mat.cod-ean    WHEN AVAIL item-mat       
           tt-material.class-fiscal          = item.class-fiscal.
 
    RUN esp/gko/gkapi012.p persistent set h-gkapi0012.
    RUN integrarMaterial IN h-gkapi0012 (INPUT TABLE tt-material).


END PROCEDURE.


RETURN "OK".



