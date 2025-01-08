/***********************************************************************
**  Programa..: ESP/REP/ESREP008RP.P
**  Autor.....: Giovane Oliveira
**  Data......: FEVEREIRO/2006 - Desenvolvimento
**  Descricao.: Erros das Notas Fiscais
**  Vers∆o....: 001 07/02/2006
**                  Desenvolvimento Programa
************************************************************************/
{include/i-prgvrs.i ESREP008 2.04.00.002}

/****************************  Definitions  ****************************/
{esp/rep/esrep008tt.i}

{utp/ut-glob.i}
{include/i-rpvar.i}
{upc/btb910za-upc.i}
{include/i-epc200.i ft0904o}

def var d-qtde     like saldo-terc.quantidade NO-UNDO.
def var d-valor    AS DECIMAL     NO-UNDO.
def var val-unit   as dec format ">>>>,>>9.99" NO-UNDO.
def var de-val-liq as dec format ">>>>,>>9.99" NO-UNDO.
def var de-tot-nat as dec format ">>>>,>>9.99" NO-UNDO.
def var de-tot-emi as dec format ">>>>,>>9.99" NO-UNDO.
def var de-tot-ger as dec format ">>>>,>>9.99" NO-UNDO.
def var da-data as DATE NO-UNDO.

DEFINE VARIABLE h-cd9500            AS HANDLE                 NO-UNDO.
DEFINE VARIABLE i-cont              AS INTEGER                NO-UNDO.
DEFINE VARIABLE de-vl-contab        AS DECIMAL                NO-UNDO.
DEFINE VARIABLE lContaFtPorCliente  AS LOGICAL                NO-UNDO.
DEFINE VARIABLE l-ems5              AS LOGICAL                NO-UNDO.
DEFINE VARIABLE l-ret-fat           AS LOGICAL                NO-UNDO.
DEFINE VARIABLE l-funcao-iss-retido AS LOGICAL                NO-UNDO.
DEFINE VARIABLE l-diferenca-cambial AS LOGICAL  INITIAL YES   NO-UNDO.
DEFINE VARIABLE de-val-difal        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dt-prazo            AS DATE        NO-UNDO.
DEF VAR c-chave-bem AS CHAR NO-UNDO.
DEF VAR c-narr-aux  AS CHAR NO-UNDO.

/****************************  Temp-Tables  ****************************/
def buffer b-comp        for componente.
def buffer b-saldo-terc  for saldo-terc.
def buffer b-nota-fatura for nota-fiscal.
def buffer b-it-fatura   for it-nota-fisc.
def buffer b-sumar-rec   for sumar-ft.


def temp-table tt-comp
    field tipo         AS INTEGER
    FIELD referencia   AS CHARACTER 
    field cod-emitente like saldo-terc.cod-emitente
    field it-codigo    like saldo-terc.it-codigo 
    field descricao    as char format "X(36)"
    field nat-operacao like saldo-terc.nat-operacao
    FIELD cod-estabel  LIKE saldo-terc.cod-estabel
    field nro-docto    like saldo-terc.nro-docto
    field serie        like saldo-terc.serie
    field sequencia    LIKE saldo-terc.sequencia
    field dt-emis-nota like nota-fiscal.dt-emis-nota label "Data Emis"
    field dt-retorno   like saldo-terc.dt-retorno label "Data Docto"
    field quantidade   like saldo-terc.quantidade label "Quantidade"
    field val-unit     as dec format ">>>>,>>9.99" label "Preco Unit"
    field val-liq      as dec format ">>>>,>>9.99" label "Preco s/Imp"
    field vl-venda     as dec format ">>>>,>>9.99" label "Valor Venda"
    field vl-ipi       as dec format ">>>>,>>9.99" label "Valor IPI"
    field vl-icms      as dec format ">>>>,>>9.99" label "Valor ICMS"
    field val-difal    as dec format ">>>>,>>9.99" label "Valor DIFAL"

    field narrativa    like nar-it-nota.narrativa
    field observ-nota  like nota-fiscal.observ-nota
    FIELD usuario      AS CHARACTER FORMAT "x(30)"
    FIELD centro-custo AS CHARACTER FORMAT "x(30)"
    FIELD conta-deb    AS CHARACTER FORMAT "x(30)"
    FIELD valor-deb    as dec format ">>>>,>>9.99" label "Valor Deb"
    FIELD conta-cre    AS CHARACTER FORMAT "x(30)"
    FIELD valor-cre    as dec format ">>>>,>>9.99" label "Valor Cre"
    index tt-comp is primary cod-emitente it-codigo serie nro-docto tipo nat-operacao.


DEF TEMP-TABLE tt-conta  NO-UNDO
    FIELD nro-docto      LIKE saldo-terc.nro-docto
    FIELD serie-docto    LIKE saldo-terc.serie-docto
    FIELD cod-emitente   LIKE saldo-terc.cod-emitente
    FIELD nat-operacao   LIKE saldo-terc.nat-operacao
    FIELD conta-contabil AS CHAR FORMAT "x(40)"
    FIELD it-codigo      LIKE movto-estoq.it-codigo
    FIELD sequencia      LIKE movto-estoq.sequen-nf
    FIELD de-debito      AS DECIMAL
    FIELD de-credito     AS DECIMAL
    INDEX conta          conta-contabil it-codigo ASCENDING
    INDEX docto          nro-docto serie-docto cod-emitente nat-operacao it-codigo conta-contabil.

DEF TEMP-TABLE tt-contas-terc NO-UNDO
    FIELD conta          AS CHARACTER
    INDEX conta          conta.

def temp-table w-item  no-undo
    field nr-sequencia like it-nota-fisc.nr-seq-fat
    field desconto     like it-nota-fisc.vl-tot-item
    field vl-tot-item  like it-nota-fisc.vl-tot-item.

DEF BUFFER b-tt-comp FOR tt-comp.

/****************************  Frames       ****************************/
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.


create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

assign c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Saldos Terceiros por Natureza"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''.

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i &pagesize="0"}

    run utp/ut-acomp.p persistent set h-acomp.  

    IF  NOT VALID-HANDLE(h-cd9500) THEN
        RUN cdp/cd9500.p PERSISTENT SET h-cd9500.

    ASSIGN lContaFtPorCliente  = CAN-FIND(FIRST funcao NO-LOCK WHERE funcao.cd-funcao = "spp-ContaFtCli":U AND funcao.ativo)
           l-ems5              = CAN-FIND(FIRST funcao NO-LOCK WHERE funcao.cd-funcao = "adm-fgl-ems-5.00" AND funcao.ativo AND funcao.log-1)
           l-funcao-iss-retido = CAN-FIND(FIRST funcao NO-LOCK WHERE funcao.cd-funcao = "spp-iss-retido":U AND funcao.ativo).


    /* Busca as contas que s∆o utilizadas para os saldos em poder de terceiros */
    FOR FIRST ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "esrep008rp"
        AND   ponto-programa.ponto         = 1,
        EACH  conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        CREATE tt-contas-terc.
        ASSIGN tt-contas-terc.conta = conteudo-programa.conteudo.
    END.


    IF  tt-param.analit-sint THEN DO:
        RUN pi-analitico.
    END.
    ELSE DO:
        RUN pi-sintetico.
    END.

    IF  VALID-HANDLE(h-cd9500) THEN
        DELETE OBJECT h-cd9500.

    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
END.


PROCEDURE pi-analitico:
    RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").

    FOR EACH tt-conta:
        DELETE tt-conta.
    END.

    FOR EACH  saldo-terc NO-LOCK
        WHERE saldo-terc.cod-estabel  >= tt-param.cod-estab-ini
          AND saldo-terc.cod-estabel  <= tt-param.cod-estab-fim
          AND saldo-terc.cod-emitente >= tt-param.ini-cod-emitente
          AND saldo-terc.cod-emitente <= tt-param.fim-cod-emitente
          AND saldo-terc.nat-operacao >= tt-param.ini-nat-operacao
          AND saldo-terc.nat-operacao <= tt-param.fim-nat-operacao
          AND saldo-terc.it-codigo    >= tt-param.ini-it-codigo
          AND saldo-terc.it-codigo    <= tt-param.fim-it-codigo,
        FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = saldo-terc.it-codigo:

        IF  NOT tt-param.saldo-zero AND saldo-terc.quantidade = 0 THEN
            NEXT.

        IF  NOT tt-param.notas-transf AND saldo-terc.tipo-sal-terc = 3 /* Transferància */ THEN
            NEXT.

        FIND FIRST componente OF saldo-terc NO-LOCK
            WHERE  componente.dt-retorno >= tt-param.data-ini
            AND    componente.dt-retorno <= tt-param.data-fim NO-ERROR.
        IF  AVAIL  componente THEN DO:

            RUN pi-acompanhar IN h-acomp (INPUT saldo-terc.cod-estabel + " - " + STRING(saldo-terc.cod-emitente) + " - " + saldo-terc.it-codigo + " - " + saldo-terc.serie + " - " + saldo-terc.nro-docto).


            FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao = saldo-terc.nat-operacao NO-ERROR.

            FIND FIRST ped-fiscal NO-LOCK
                 WHERE ped-fiscal.cod-estabel = saldo-terc.cod-estabel
                   AND ped-fiscal.serie       = saldo-terc.serie
                   AND ped-fiscal.nr-nota-fis = saldo-terc.nro-docto NO-ERROR.

            FIND FIRST item-doc-est NO-LOCK
                 WHERE item-doc-est.serie-docto  = saldo-terc.serie-docto
                   AND item-doc-est.nro-docto    = saldo-terc.nro-docto
                   AND item-doc-est.cod-emitente = saldo-terc.cod-emitente
                   AND item-doc-est.nat-operacao = saldo-terc.nat-operacao
                   AND item-doc-est.it-codigo    = saldo-terc.it-codigo 
                   AND item-doc-est.sequencia    = saldo-terc.sequencia NO-ERROR.

            FIND FIRST it-nota-fisc NO-LOCK
                WHERE  it-nota-fisc.cod-estabel = saldo-terc.cod-estabel
                AND    it-nota-fisc.serie       = saldo-terc.serie
                AND    it-nota-fisc.nr-nota-fis = saldo-terc.nro-docto
                AND    it-nota-fisc.it-codigo   = saldo-terc.it-codigo
                AND    it-nota-fisc.nr-seq-fat  = saldo-terc.sequencia NO-ERROR.

            FIND FIRST nota-fiscal OF it-nota-fisc NO-ERROR.

            FIND FIRST estabelec NO-LOCK
                WHERE  estabelec.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.

            ASSIGN da-data = (DATE(MONTH(saldo-ter.dt-retorno),28,YEAR(saldo-ter.dt-retorno)) + 4) - DAY(DATE(MONTH(saldo-ter.dt-retorno),28,YEAR(saldo-terc.dt-retorno)) + 4).

            FIND LAST pr-it-per NO-LOCK
                WHERE pr-it-per.it-codigo   = saldo-terc.it-codigo
                AND   pr-it-per.cod-estabel = saldo-terc.cod-estabel
                AND   pr-it-per.periodo    <= da-data NO-ERROR.
            IF  AVAIL pr-it-per AND pr-it-per.val-unit-mat-m[1] <> 0 THEN DO:
                ASSIGN val-unit    = pr-it-per.val-unit-mat-m[1] +
                                     pr-it-per.val-unit-mob-m[1] +
                                     pr-it-per.val-unit-ggf-m[1]
                       de-val-liq  = val-unit.
            END.
            ELSE DO:
               ASSIGN val-unit   = (componente.preco-total[1] + componente.valor-ipi[1]) / componente.quantidade
                      de-val-liq = (componente.preco-total[1] - componente.valor-icm[1]) / componente.quantidade.
            END.
            ASSIGN de-val-difal = 0.
            FOR EACH ITEM-NF-ADC                                          /* ICMS DIFAL */
                WHERE ITEM-NF-ADC.cod-estab = nota-fiscal.cod-estabel
                AND ITEM-NF-ADC.cod-serie = nota-fiscal.serie
                AND ITEM-NF-ADC.cod-nota-fis = nota-fiscal.nr-nota-fis
                AND item-nf-adc.cod-natur-operac = nota-fiscal.nat-operacao
                AND item-nf-adc.num-seq-item-nf  = it-nota-fisc.nr-seq-fat
                AND item-nf-adc.cod-item         = it-nota-fisc.it-codigo NO-LOCK:

/*                 PUT "valor icms DIFAL -1- " NOTA-FISCAL.NR-NOTA-FIS " " IT-nota-fisc.it-codigo */
/*                     item-nf-adc.val-livre-4 " "                                                */
/*                     item-nf-adc.val-livre-3 " "                                                */
/*                     de-val-liq                                                                 */
/*                      SKIP.                                                                     */

                ASSIGN de-val-difal = de-val-difal +  item-nf-adc.val-livre-4  +
                                                      item-nf-adc.val-livre-3 +
                                                  DEC(item-nf-adc.cod-livre-4).

/*                 PUT "valor icms DIFAL -1a- " NOTA-FISCAL.NR-NOTA-FIS " " IT-nota-fisc.it-codigo */
/*                     item-nf-adc.val-livre-4 " "                                                 */
/*                     item-nf-adc.val-livre-3 " "                                                 */
/*                     de-val-liq                                                                  */
/*                      SKIP.                                                                      */

            END.

            CREATE tt-comp.
            ASSIGN tt-comp.tipo         = 1
                   tt-comp.referencia   = saldo-terc.nro-docto
                   tt-comp.cod-emitente = saldo-terc.cod-emitente
                   tt-comp.it-codigo    = saldo-terc.it-codigo
                   tt-comp.descricao    = item.descricao-1 + item.descricao-2
                   tt-comp.nat-operacao = saldo-terc.nat-operacao
                   tt-comp.cod-estabel  = saldo-terc.cod-estabel
                   tt-comp.nro-docto    = saldo-terc.nro-docto
                   tt-comp.serie        = saldo-terc.serie
                   tt-comp.sequencia    = saldo-terc.sequencia
                   tt-comp.dt-emis-nota = IF AVAIL nota-fiscal THEN nota-fiscal.dt-emis-nota ELSE ?
                   tt-comp.dt-retorno   = componente.dt-retorno
                   tt-comp.quantidade   = componente.quantidade
                   tt-comp.val-unit     = val-unit
                   tt-comp.val-liq      = de-val-liq
                   TT-COMP.VAL-DIFAL    = de-val-difal.

            ASSIGN c-narr-aux = "".

            IF  AVAIL ped-fiscal THEN DO:

                run prgint/utb/utb742za.py persistent set h_api_ccusto.
                    
                EMPTY TEMP-TABLE tt_log_erro.
                run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,  /* EMPRESA EMS2 */
                                                           input  "",                   /* CODIGO DO PLANO CCUSTO */
                                                           input  ped-fiscal.sc-codigo, /* CCUSTO */
                                                           input  today,                /* DATA DE TRANSACAO */
                                                           output v_des_titulo_ccusto,  /* DESCRICAO DO CCUSTO */
                                                           output table tt_log_erro).   /* ERROS */
                delete object h_api_ccusto.

                ASSIGN tt-comp.centro-custo = ped-fiscal.sc-codigo + "-" + v_des_titulo_ccusto.

                FIND FIRST usuar_mestre NO-LOCK
                     WHERE usuar_mestre.cod_usuario = ped-fiscal.usuario-magnus NO-ERROR.

                ASSIGN tt-comp.usuario = ped-fiscal.usuario-magnus + "-" + IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "".

                FIND FIRST it-ped-fiscal NO-LOCK
                     WHERE it-ped-fiscal.nr-pedido = ped-fiscal.nr-pedido
                       AND it-ped-fiscal.it-codigo = it-nota-fisc.it-codigo 
                       AND it-ped-fiscal.vl-unit   = it-nota-fisc.vl-preuni
                       AND it-ped-fiscal.seq * 10  = it-nota-fisc.nr-seq-fat NO-ERROR.
                IF NOT AVAIL it-ped-fiscal THEN
                   FIND FIRST it-ped-fiscal NO-LOCK
                        WHERE it-ped-fiscal.nr-pedido = ped-fiscal.nr-pedido
                          AND it-ped-fiscal.it-codigo = it-nota-fisc.it-codigo 
                          AND it-ped-fiscal.vl-unit   = it-nota-fisc.vl-preuni NO-ERROR.
        
                IF  AVAIL it-ped-fiscal THEN DO:
                    ASSIGN c-chave-bem = substr(it-ped-fiscal.char-1, 79, 35).
                    
                    IF  NUM-ENTRIES(c-chave-bem,";") = 3 THEN
                        ASSIGN c-narr-aux = " - Bem: " + ENTRY(2,c-chave-bem,";") + "/" + ENTRY(3,c-chave-bem,";") + " - Cta: " + ENTRY(1,c-chave-bem,";").
                END.
            END.

            IF  AVAIL natur-oper AND natur-oper.tipo = 2 OR NOT AVAIL natur-oper THEN DO:
                IF  AVAIL it-nota-fisc THEN DO:
                    FIND FIRST nar-it-not NO-LOCK
                        WHERE  nar-it-not.cod-estabel  = it-nota-fisc.cod-estabel
                        AND    nar-it-not.serie        = it-nota-fisc.serie
                        AND    nar-it-not.nr-nota-fis  = it-nota-fisc.nr-nota-fis
                        AND    nar-it-not.it-codigo    = it-nota-fisc.it-codigo
                        AND    nar-it-not.nr-sequencia = it-nota-fisc.nr-seq-fat NO-ERROR.
                    IF  AVAIL  nar-it-not THEN DO:
                        ASSIGN tt-comp.narrativa = nar-it-not.narrativa.
                    END.

                    IF  AVAIL natur-oper AND natur-oper.tipo = 2 THEN DO:
                        ASSIGN tt-comp.vl-ipi  = it-nota-fisc.vl-ipi-it  / it-nota-fisc.qt-faturada[1] * tt-comp.quantidade
                               tt-comp.vl-icms = it-nota-fisc.vl-icms-it / it-nota-fisc.qt-faturada[1] * tt-comp.quantidade.
                    END.
                END.
            END.
            ELSE DO:
                IF  AVAIL item-doc-est THEN DO:
                    IF  tt-comp.narrativa = "" THEN 
                        ASSIGN tt-comp.narrativa = item-doc-est.narrativa.

                    IF  AVAIL natur-oper AND natur-oper.tipo = 1 THEN DO:
                        ASSIGN tt-comp.vl-ipi  = item-doc-est.valor-ipi[1] / item-doc-est.quantidade * tt-comp.quantidade
                               tt-comp.vl-icms = item-doc-est.valor-icm[1] / item-doc-est.quantidade * tt-comp.quantidade.
                    END.
                END.
            END.

            RUN pi-grade-contabil(INPUT saldo-terc.serie-docto,
                                  INPUT saldo-terc.nro-docto,
                                  INPUT saldo-terc.cod-emitente,
                                  INPUT saldo-terc.nat-operacao,
                                  INPUT saldo-terc.sequencia,
                                  INPUT YES).

            ASSIGN tt-comp.vl-venda  = tt-comp.quantidade * tt-comp.val-liq + tt-comp.vl-ipi + tt-comp.vl-icms.

            ASSIGN tt-comp.narrativa = tt-comp.narrativa + c-narr-aux.
        END.
        
        FOR EACH  b-comp NO-LOCK
            WHERE b-comp.nro-comp     = saldo-terc.nro-docto
              AND b-comp.serie-comp   = saldo-terc.serie
              AND b-comp.cod-emitente = saldo-terc.cod-emitente
              AND b-comp.nat-comp     = saldo-terc.nat-operacao
              AND b-comp.it-codigo    = saldo-terc.it-codigo
              AND b-comp.seq-comp     = saldo-terc.sequencia
              AND b-comp.dt-retorno  >= tt-param.data-ini
              AND b-comp.dt-retorno  <= tt-param.data-fim
              /*AND b-comp.dt-retorno  <= tt-param.data-corte*/,
            /*FIRST b-saldo-terc NO-LOCK OF b-comp*/
            FIRST b-saldo-terc NO-LOCK
            WHERE b-saldo-terc.cod-emitente = b-comp.cod-emitente
              AND b-saldo-terc.serie-docto  = b-comp.serie-comp
              AND b-saldo-terc.nro-docto    = b-comp.nro-comp
              AND b-saldo-terc.nat-operacao = b-comp.nat-comp
              AND b-saldo-terc.it-codigo    = b-comp.it-codigo
              AND b-saldo-terc.cod-refer    = b-comp.cod-refer
              AND b-saldo-terc.sequencia    = b-comp.seq-comp
              BY  b-comp.dt-retorno:

            FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao = b-comp.nat-operacao NO-ERROR.

            FIND FIRST ped-fiscal NO-LOCK
                 WHERE ped-fiscal.cod-estabel = b-saldo-terc.cod-estabel
                   AND ped-fiscal.serie       = b-saldo-terc.serie
                   AND ped-fiscal.nr-nota-fis = b-saldo-terc.nro-docto NO-ERROR.

            find first item-doc-est no-lock 
                 where item-doc-est.serie-docto  = b-comp.serie-docto
                   and item-doc-est.nro-docto    = b-comp.nro-docto
                   and item-doc-est.cod-emitente = b-comp.cod-emitente
                   and item-doc-est.nat-operacao = b-comp.nat-operacao
                   and item-doc-est.it-codigo    = b-comp.it-codigo 
                   AND item-doc-est.sequencia    = b-comp.sequencia no-error.


            FIND FIRST it-nota-fisc NO-LOCK
                WHERE  it-nota-fisc.cod-estabel = b-saldo-terc.cod-estabel
                AND    it-nota-fisc.serie       = b-comp.serie-docto
                AND    it-nota-fisc.nr-nota-fis = b-comp.nro-docto
                AND    it-nota-fisc.it-codigo   = b-comp.it-codigo
                AND    it-nota-fisc.nr-seq-fat  = b-comp.sequencia NO-ERROR.

            FIND FIRST nota-fiscal OF it-nota-fisc NO-ERROR.

            FIND FIRST estabelec NO-LOCK
                WHERE  estabelec.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.

            ASSIGN da-data = (DATE(MONTH(b-comp.dt-retorno),28,YEAR(b-comp.dt-retorno)) + 4) - DAY(DATE(MONTH(b-comp.dt-retorno),28,YEAR(b-comp.dt-retorno)) + 4).

            FIND LAST pr-it-per NO-LOCK
                WHERE pr-it-per.it-codigo   = b-saldo-terc.it-codigo
                AND   pr-it-per.cod-estabel = b-saldo-terc.cod-estabel
                AND   pr-it-per.periodo    <= da-data NO-ERROR.
            IF  AVAIL pr-it-per AND pr-it-per.val-unit-mat-m[1] <> 0 THEN DO:
                ASSIGN val-unit    = pr-it-per.val-unit-mat-m[1] +
                                     pr-it-per.val-unit-mob-m[1] +
                                     pr-it-per.val-unit-ggf-m[1] 
                       de-val-liq  = val-unit.
            END.
            ELSE DO:
               ASSIGN val-unit   = (b-comp.preco-total[1] + b-comp.valor-ipi[1]) / b-comp.quantidade
                      de-val-liq = (b-comp.preco-total[1] - b-comp.valor-icm[1]) / b-comp.quantidade.
            END.
            ASSIGN de-val-difal = 0.
            FOR EACH ITEM-NF-ADC                                          /* ICMS DIFAL */
                WHERE ITEM-NF-ADC.cod-estab = nota-fiscal.cod-estabel
                AND ITEM-NF-ADC.cod-serie = nota-fiscal.serie
                AND ITEM-NF-ADC.cod-nota-fis = nota-fiscal.nr-nota-fis
                AND item-nf-adc.cod-natur-operac = nota-fiscal.nat-operacao
                AND item-nf-adc.num-seq-item-nf  = it-nota-fisc.nr-seq-fat
                AND item-nf-adc.cod-item         = it-nota-fisc.it-codigo NO-LOCK:

/*                 PUT "valor icms DIFAL -2- " NOTA-FISCAL.NR-NOTA-FIS " " IT-nota-fisc.it-codigo */
/*                     item-nf-adc.val-livre-4 " "                                                */
/*                     item-nf-adc.val-livre-3 " "                                                */
/*                     de-val-liq SKIP.                                                           */

                ASSIGN de-val-difal = de-val-difal +  item-nf-adc.val-livre-4  +
                                                      item-nf-adc.val-livre-3 +
                                                  DEC(item-nf-adc.cod-livre-4).

/*                 PUT "valor icms DIFAL -2a- " NOTA-FISCAL.NR-NOTA-FIS " " IT-nota-fisc.it-codigo */
/*                     item-nf-adc.val-livre-4 " "                                                 */
/*                     item-nf-adc.val-livre-3 " "                                                 */
/*                     de-val-liq SKIP.                                                            */

            END.     
            CREATE tt-comp.
            ASSIGN tt-comp.tipo         = 2
                   tt-comp.referencia   = saldo-terc.nro-docto
                   tt-comp.cod-emitente = b-comp.cod-emitente
                   tt-comp.it-codigo    = b-comp.it-codigo
                   tt-comp.descricao    = item.descricao-1 + item.descricao-2
                   tt-comp.nat-operacao = b-comp.nat-operacao
                   tt-comp.cod-estabel  = saldo-terc.cod-estabel
                   tt-comp.nro-docto    = b-comp.nro-docto
                   tt-comp.serie        = b-comp.serie-docto
                   tt-comp.sequencia    = b-comp.sequencia
                   tt-comp.dt-emis-nota = IF AVAIL nota-fiscal THEN nota-fiscal.dt-emis-nota ELSE ?
                   tt-comp.dt-retorno   = b-comp.dt-retorno
                   tt-comp.quantidade   = b-comp.quantidade
                   tt-comp.val-unit     = val-unit
                   tt-comp.val-liq      = de-val-liq
                   tt-comp.val-difal    = de-val-difal.

            ASSIGN c-narr-aux = "".

            IF  AVAIL ped-fiscal THEN DO:
                run prgint/utb/utb742za.py persistent set h_api_ccusto.
                    
                EMPTY TEMP-TABLE tt_log_erro.
                run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,  /* EMPRESA EMS2 */
                                                           input  "",                   /* CODIGO DO PLANO CCUSTO */
                                                           input  ped-fiscal.sc-codigo, /* CCUSTO */
                                                           input  today,                /* DATA DE TRANSACAO */
                                                           output v_des_titulo_ccusto,  /* DESCRICAO DO CCUSTO */
                                                           output table tt_log_erro).   /* ERROS */
                delete object h_api_ccusto.

                ASSIGN tt-comp.centro-custo = ped-fiscal.sc-codigo + "-" + v_des_titulo_ccusto.

                FIND FIRST usuar_mestre NO-LOCK
                     WHERE usuar_mestre.cod_usuario = ped-fiscal.usuario-magnus NO-ERROR.

                ASSIGN tt-comp.usuario = ped-fiscal.usuario-magnus + "-" + IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "".

                FIND FIRST it-ped-fiscal NO-LOCK
                     WHERE it-ped-fiscal.nr-pedido = ped-fiscal.nr-pedido
                       AND it-ped-fiscal.it-codigo = it-nota-fisc.it-codigo 
                       AND it-ped-fiscal.vl-unit   = it-nota-fisc.vl-preuni
                       AND it-ped-fiscal.seq * 10  = it-nota-fisc.nr-seq-fat NO-ERROR.
                IF NOT AVAIL it-ped-fiscal THEN
                   FIND FIRST it-ped-fiscal NO-LOCK
                        WHERE it-ped-fiscal.nr-pedido = ped-fiscal.nr-pedido
                          AND it-ped-fiscal.it-codigo = it-nota-fisc.it-codigo 
                          AND it-ped-fiscal.vl-unit   = it-nota-fisc.vl-preuni NO-ERROR.
        
                IF  AVAIL it-ped-fiscal THEN DO:
                    ASSIGN c-chave-bem = substr(it-ped-fiscal.char-1, 79, 35).

                    IF  NUM-ENTRIES(c-chave-bem,";") = 3 THEN
                        ASSIGN c-narr-aux = " - Bem: " + ENTRY(2,c-chave-bem,";") + "/" + ENTRY(3,c-chave-bem,";") + " - Cta: " + ENTRY(1,c-chave-bem,";").
                END.
            END.

            IF AVAIL natur-oper AND natur-oper.tipo = 2 OR NOT AVAIL natur-oper THEN DO:
                IF  AVAIL it-nota-fisc THEN DO:
                    IF  AVAIL nota-fiscal THEN
                        ASSIGN tt-comp.observ-nota = nota-fiscal.observ-nota.

                    FIND FIRST nar-it-not NO-LOCK
                        WHERE  nar-it-not.cod-estabel  = it-nota-fisc.cod-estabel
                        AND    nar-it-not.serie        = it-nota-fisc.serie
                        AND    nar-it-not.nr-nota-fis  = it-nota-fisc.nr-nota-fis
                        AND    nar-it-not.it-codigo    = it-nota-fisc.it-codigo
                        AND    nar-it-not.nr-sequencia = it-nota-fisc.nr-seq-fat NO-ERROR.
                    IF  AVAIL nar-it-not THEN DO:
                        ASSIGN tt-comp.narrativa = nar-it-not.narrativa.
                    END.

                    IF AVAIL natur-oper AND natur-oper.tipo = 2 THEN DO:
                        ASSIGN tt-comp.vl-ipi  = it-nota-fisc.vl-ipi-it / it-nota-fisc.qt-faturada[1] * tt-comp.quantidade
                               tt-comp.vl-icms = it-nota-fisc.vl-icms-it / it-nota-fisc.qt-faturada[1] * tt-comp.quantidade.
                    END.
                END.
            END.
            ELSE DO:
                IF  AVAIL item-doc-est THEN DO:
                    IF  tt-comp.narrativa = "" THEN
                        ASSIGN tt-comp.narrativa = item-doc-est.narrativa.

                    IF  AVAIL natur-oper AND natur-oper.tipo = 1 THEN DO:
                        ASSIGN tt-comp.vl-ipi  = item-doc-est.valor-ipi[1] / item-doc-est.quantidade * tt-comp.quantidade
                               tt-comp.vl-icms = item-doc-est.valor-icm[1] / item-doc-est.quantidade * tt-comp.quantidade.
                    END.
                END.
            END.

            ASSIGN tt-comp.vl-venda  = tt-comp.quantidade * tt-comp.val-liq + tt-comp.vl-ipi + tt-comp.vl-icms.

            ASSIGN tt-comp.narrativa = tt-comp.narrativa + c-narr-aux.

            RUN pi-grade-contabil(INPUT b-comp.serie-docto,
                                  INPUT b-comp.nro-docto,
                                  INPUT b-comp.cod-emitente,
                                  INPUT b-comp.nat-operacao,
                                  INPUT b-comp.sequencia,
                                  INPUT YES).
        END.
    END.

    FOR EACH docum-est USE-INDEX dt-tp-estab NO-LOCK
        WHERE docum-est.dt-trans    >= tt-param.data-ini
          AND docum-est.dt-trans    <= tt-param.data-fim
          AND docum-est.cod-estabel >= tt-param.cod-estab-ini
          AND docum-est.cod-estabel <= tt-param.cod-estab-fim:

        FIND FIRST natur-oper
            WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.

        IF  NOT AVAILABLE natur-oper        OR
           (AVAILABLE natur-oper            AND
            NOT natur-oper.log-oper-triang) THEN NEXT.

        FOR EACH item-doc-est OF docum-est NO-LOCK:

            FIND FIRST b-tt-comp
                WHERE b-tt-comp.cod-emitente = item-doc-est.cod-emit-terc
                  AND b-tt-comp.it-codigo    = item-doc-est.it-codigo
                  AND b-tt-comp.serie        = item-doc-est.serie-terc
                  AND b-tt-comp.nro-docto    = item-doc-est.nro-docto-terc
                  AND b-tt-comp.tipo         = 1
                  AND b-tt-comp.nat-operacao = item-doc-est.nat-terc NO-LOCK NO-ERROR.

            IF AVAILABLE b-tt-comp THEN DO:

                RUN pi-acompanhar IN h-acomp (INPUT docum-est.cod-estabel + " - " + STRING(item-doc-est.cod-emitente) + " - " + item-doc-est.it-codigo + " - " + item-doc-est.serie-docto + " - " + item-doc-est.nro-docto).

                FIND FIRST estabelec
                    WHERE  estabelec.cod-estabel = docum-est.cod-estabel NO-LOCK NO-ERROR.

                FIND FIRST ped-fiscal
                    WHERE ped-fiscal.cod-estabel = docum-est.cod-estabel
                    AND   ped-fiscal.serie       = docum-est.serie
                    AND   ped-fiscal.nr-nota-fis = docum-est.nro-docto NO-LOCK NO-ERROR.
        
                ASSIGN c-narr-aux = "".

                IF  AVAIL ped-fiscal THEN DO:
                    FIND FIRST it-ped-fiscal
                        WHERE it-ped-fiscal.nr-pedido = ped-fiscal.nr-pedido NO-LOCK NO-ERROR.
            
                    IF  AVAIL it-ped-fiscal THEN DO:
                        ASSIGN c-chave-bem = substr(it-ped-fiscal.char-1, 79, 35).

                        IF  NUM-ENTRIES(c-chave-bem,";") = 3 THEN
                            ASSIGN c-narr-aux = " - Bem: " + ENTRY(2,c-chave-bem,";") + "/" + ENTRY(3,c-chave-bem,";") + " - Cta: " + ENTRY(1,c-chave-bem,";").
                    END.
                END.

                FIND FIRST item
                    WHERE item.it-codigo = item-doc-est.it-codigo NO-LOCK NO-ERROR.

                CREATE tt-comp.
                ASSIGN tt-comp.tipo         = 2
                       tt-comp.referencia   = b-tt-comp.referencia
                       tt-comp.cod-emitente = item-doc-est.cod-emitente
                       tt-comp.it-codigo    = item-doc-est.it-codigo
                       tt-comp.descricao    = IF AVAILABLE item THEN (item.descricao-1 + item.descricao-2) ELSE "":U
                       tt-comp.nat-operacao = item-doc-est.nat-operacao
                       tt-comp.cod-estabel  = docum-est.cod-estabel
                       tt-comp.nro-docto    = item-doc-est.nro-docto
                       tt-comp.serie        = item-doc-est.serie-docto
                       tt-comp.sequencia    = item-doc-est.sequencia
                       tt-comp.dt-emis-nota = IF AVAIL nota-fiscal THEN nota-fiscal.dt-emis-nota ELSE ?
                       tt-comp.dt-retorno   = docum-est.dt-trans
                       tt-comp.quantidade   = item-doc-est.quantidade
                       tt-comp.val-unit     = (item-doc-est.preco-total[1] + item-doc-est.valor-ipi[1]) / item-doc-est.quantidade
                       tt-comp.val-liq      = (item-doc-est.preco-total[1] - item-doc-est.valor-icm[1]) / item-doc-est.quantidade
                       tt-comp.vl-ipi       = item-doc-est.valor-ipi[1] / item-doc-est.quantidade
                       tt-comp.vl-icms      = item-doc-est.valor-icm[1] / item-doc-est.quantidade
                       tt-comp.narrativa    = item-doc-est.narrativa + c-narr-aux
                       tt-comp.vl-venda     = tt-comp.quantidade * tt-comp.val-liq + tt-comp.vl-ipi + tt-comp.vl-icms.

                RUN pi-grade-contabil(INPUT item-doc-est.serie-docto,
                                      INPUT item-doc-est.nro-docto,
                                      INPUT item-doc-est.cod-emitente,
                                      INPUT item-doc-est.nat-operacao,
                                      INPUT item-doc-est.sequencia,
                                      INPUT NO).
            END.
        END.
    END.

    PUT UNFORMATTED "Estabel;Tipo;Referencia;Natureza;DescNat;Dias Leg;Dias Prazo;Prazo;Fornecedor;Nome;Item;Descriá∆o;Docto;Serie;Dt Docto;Quantidade;Preco Unit;Saldo;Preco s/Imp;Valor Total;Valor IPI;Valor ICMS;Val DIFAL;Usuario;Centro Custo;Narrativa;Observ Nota;Resumo Conta Contab;Valor Deb;Valor Cred;Resumo Conta Contab;Valor Deb;Valor Cred;" SKIP.

    
    FOR EACH tt-comp,
        FIRST item NO-LOCK
        WHERE item.it-codigo = tt-comp.it-codigo 
              BREAK BY tt-comp.cod-emitente
                    BY tt-comp.serie
                    BY tt-comp.nro-docto
                    BY tt-comp.it-codigo
                    BY tt-comp.tipo
                    BY tt-comp.nat-operacao:

        FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao = tt-comp.nat-operacao NO-ERROR.
        FIND FIRST emitente   NO-LOCK WHERE emitente.cod-emitente   = tt-comp.cod-emitente NO-ERROR.
        FIND FIRST int-natur-oper NO-LOCK WHERE int-natur-oper.nat-operacao = natur-oper.nat-operacao NO-ERROR.
        IF AVAIL int-natur-oper THEN
            ASSIGN dt-prazo = ?
                   dt-prazo = tt-comp.dt-emis-nota + (int-natur-oper.dias-legislacao - int-natur-oper.dias-advertencia).

        RUN pi-acompanhar IN h-acomp (INPUT tt-comp.nro-docto).

        IF tt-comp.dt-emis-nota = ? AND
           tt-comp.tipo         = 1 AND 
           tt-comp.nat-operacao = "690100" THEN NEXT.

        IF AVAIL natur-oper AND
                 natur-oper.log-oper-triang = YES AND
                 tt-comp.tipo = 2 
        THEN ASSIGN tt-comp.tipo = 1.

        PUT UNFORMATTED 
            tt-comp.cod-estabel                   ";"
            tt-comp.tipo                          ";" 
            tt-comp.referencia                    ";"
            tt-comp.nat-operacao                  ";"
           (IF AVAIL natur-oper                   
            THEN natur-oper.denominacao           
            ELSE "")                              ";"
           (IF AVAIL int-natur-oper                   
            THEN int-natur-oper.dias-legislacao           
            ELSE 0)                               ";"
           (IF AVAIL int-natur-oper                   
            THEN int-natur-oper.dias-advertencia  
            ELSE 0)                               ";"

           (IF  dt-prazo <= TODAY 
            AND int-natur-oper.dias-legislacao <> 0 
                THEN "Fora Prazo"
            ELSE "Dentro Prazo")                  ";"

            emitente.cod-emitente                 ";"
           (IF AVAIL emitente                     
            THEN emitente.nome-abrev              
            ELSE "")                              ";"
            tt-comp.it-codigo                     ";"         
            tt-comp.descricao                     ";"      
            tt-comp.nro-docto                     ";"         
            tt-comp.serie                         ";"         
            tt-comp.dt-retorno                    ";"         
            tt-comp.quantidade                    ";"         
            tt-comp.val-unit                      ";"         
            tt-comp.val-unit * tt-comp.quantidade ";" 
            tt-comp.val-liq * tt-comp.quantidade  ";" 
            tt-comp.vl-venda                      ";" 
            tt-comp.vl-ipi                        ";" 
            tt-comp.vl-icms                       ";"
            tt-comp.val-difal                     ";"
            tt-comp.usuario                       ";"
            tt-comp.centro-custo                  ";".

        IF  tt-param.narrativa AND item.tipo-contr <> 2 THEN DO:
            PUT UNFORMATTED
                REPLACE(REPLACE(tt-comp.narrativa,CHR(10)," "),CHR(13)," ") ";".
        END.
        ELSE PUT UNFORMATTED "-;".

        IF  tt-param.observacao AND FIRST-OF(tt-comp.nro-docto) THEN DO:
            PUT UNFORMATTED 
                REPLACE(REPLACE(tt-comp.observ-nota,CHR(10)," "),CHR(13)," ") ";".
        END.
        ELSE PUT UNFORMATTED "-;".


        /* Imprime as informaá‰es das Contas de Terceiros, totalizadas.
           Sempre ter† uma Conta de Terceiro e, as vezes, uma contra-partida */
        ASSIGN i-cont = 0.
        FOR EACH  tt-conta NO-LOCK
            WHERE tt-conta.nro-docto    = tt-comp.nro-docto
            AND   tt-conta.serie-docto  = tt-comp.serie
            AND   tt-conta.cod-emitente = tt-comp.cod-emitente
            AND   tt-conta.nat-operacao = tt-comp.nat-operacao
            AND   tt-conta.sequencia    = tt-comp.sequencia
            AND   CAN-FIND(FIRST tt-contas-terc NO-LOCK
                           WHERE tt-contas-terc.conta = SUBSTRING(tt-conta.conta-contabil,1,8))
            BREAK BY tt-conta.conta-contabil:
            IF natur-oper.tipo = 1 THEN
                ASSIGN tt-conta.de-credito =  tt-conta.de-credito + tt-comp.val-difal.
            ELSE
                ASSIGN tt-conta.de-debito  =  tt-conta.de-debito  + tt-comp.val-difal.
            ASSIGN tt-comp.val-difal  = 0.

            ACCUMULATE tt-conta.de-debito  (TOTAL BY tt-conta.conta-contabil).
            ACCUMULATE tt-conta.de-credito (TOTAL BY tt-conta.conta-contabil).

            IF  LAST-OF(tt-conta.conta-contabil) THEN DO:
               
                ASSIGN i-cont = i-cont + 1.
                PUT UNFORMATTED tt-conta.conta-contabil ";"
                                ACCUM TOTAL BY tt-conta.conta-contabil tt-conta.de-debito  ";"
                                ACCUM TOTAL BY tt-conta.conta-contabil tt-conta.de-credito ";".
            END.
        END.

      

        /* Se n∆o teve contas de saldo em poder de terceiros */
        IF  i-cont = 0 THEN
            PUT UNFORMATTED "-;0;0;-;0;0;".

        /* Se n∆o teve conta de contra-partida, imprime ela como "" (branco) e zerada */
        IF  i-cont = 1 THEN
            PUT UNFORMATTED "-;0;0;".

        /* Imprime todas as informaá‰es da Grade Contabil, e Grade de Impostos */
        FOR EACH  tt-conta NO-LOCK
            WHERE tt-conta.nro-docto    = tt-comp.nro-docto
            AND   tt-conta.serie-docto  = tt-comp.serie
            AND   tt-conta.cod-emitente = tt-comp.cod-emitente
            AND   tt-conta.nat-operacao = tt-comp.nat-operacao
            AND   tt-conta.sequencia    = tt-comp.sequencia
            BY    tt-conta.conta-contabil:
            PUT UNFORMATTED tt-conta.conta-contabil ";"
                            tt-conta.de-debito  ";"
                            tt-conta.de-credito ";".
        END.

        PUT UNFORMATTED SKIP.
    END. /* for each tt-comp */

    /*FOR EACH tt-conta BREAK BY tt-conta.conta-contabil:
        PUT UNFORMATTED
            "aaaa;"
            tt-conta.nro-docto      ";"
            tt-conta.conta-contabil ";"
            tt-conta.it-codigo      ";"
            tt-conta.sequencia      ";"
            tt-conta.de-debito      ";"
            tt-conta.de-credito     SKIP.
    END.*/
END.


PROCEDURE pi-sintetico:
    RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").

    for each saldo-terc no-lock
        where saldo-terc.cod-estabel  >= tt-param.cod-estab-ini
          and saldo-terc.cod-estabel  <= tt-param.cod-estab-fim
          and saldo-terc.cod-emitente >= tt-param.ini-cod-emitente
          and saldo-terc.cod-emitente <= tt-param.fim-cod-emitente
          and saldo-terc.nat-operacao >= tt-param.ini-nat-operacao
          and saldo-terc.nat-operacao <= tt-param.fim-nat-operacao
          and saldo-terc.it-codigo    >= tt-param.ini-it-codigo
          and saldo-terc.it-codigo    <= tt-param.fim-it-codigo:

        IF  NOT tt-param.saldo-zero AND saldo-terc.quantidade = 0 THEN
            NEXT.

        IF  NOT tt-param.notas-transf AND saldo-terc.tipo-sal-terc = 3 /* Transferància */ THEN
            NEXT.

        RUN pi-acompanhar IN h-acomp (INPUT saldo-terc.cod-estabel + " - " + STRING(saldo-terc.cod-emitente) + " - " + saldo-terc.it-codigo + " - " + saldo-terc.serie + " - " + saldo-terc.nro-docto).

        
        FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao = saldo-terc.nat-operacao NO-ERROR.

        FIND FIRST ped-fiscal NO-LOCK
             WHERE ped-fiscal.cod-estabel = saldo-terc.cod-estabel
               AND ped-fiscal.serie       = saldo-terc.serie
               AND ped-fiscal.nr-nota-fis = saldo-terc.nro-docto NO-ERROR.

        find first item-doc-est no-lock 
             where item-doc-est.serie-docto = saldo-terc.serie
               and item-doc-est.nro-docto   = saldo-terc.nro-docto
               and item-doc-est.cod-emitente = saldo-terc.cod-emitente
               and item-doc-est.nat-operacao = saldo-terc.nat-operacao
               and item-doc-est.it-codigo    = saldo-terc.it-codigo 
               AND item-doc-est.sequencia    = saldo-terc.sequencia no-error.

        find first it-nota-fisc no-lock where
             it-nota-fisc.cod-estabel = saldo-terc.cod-estabel and
             it-nota-fisc.serie = saldo-terc.serie and
             it-nota-fisc.nr-nota-fis = saldo-terc.nro-docto and
             it-nota-fisc.it-codigo   = saldo-terc.it-codigo and
             it-nota-fisc.nr-seq-fat = saldo-terc.sequencia no-error.

        find first nota-fiscal of it-nota-fisc no-error.


        FIND FIRST estabelec NO-LOCK
            WHERE  estabelec.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.

        find first componente of saldo-terc where
             componente.dt-retorno <= tt-param.data-corte no-lock no-error.
        
        if avail componente then do:
           ASSIGN d-qtde = componente.quantidade.
           for each b-comp no-lock
               where b-comp.nro-comp     = componente.nro-docto
                 and b-comp.serie-comp   = componente.serie-docto
                 and b-comp.cod-emitente = componente.cod-emitente
                 and b-comp.nat-comp     = componente.nat-operacao
                 and b-comp.it-codigo    = componente.it-codigo
                 and b-comp.seq-comp     = componente.sequencia
                 and b-comp.dt-retorno  <= tt-param.data-corte:
               assign d-qtde = d-qtde - b-comp.quantidade.
           end. 

           find item where item.it-codigo = saldo-terc.it-codigo no-lock.

           assign da-data = (date(month(saldo-ter.dt-retorno),28,year(saldo-ter.dt-retorno)) + 4) - day(date(month(saldo-ter.dt-retorno),28,year(saldo-terc.dt-retorno)) + 4).


           find last pr-it-per where
                pr-it-per.it-codigo = saldo-terc.it-codigo     and
                pr-it-per.cod-estabel = saldo-terc.cod-estabel and
                pr-it-per.periodo <= da-data
                no-lock no-error.   

           if avail pr-it-per and pr-it-per.val-unit-mat-m[1] <> 0 then DO:
               assign val-unit = pr-it-per.val-unit-mat-m[1] +
                                 pr-it-per.val-unit-mob-m[1] +
                                 pr-it-per.val-unit-ggf-m[1] 
                      de-val-liq  = val-unit.
           END.
           else DO:
              assign val-unit = (componente.preco-total[1] + 
                                componente.valor-ipi[1]) /
                                componente.quantidade
                     de-val-liq =  (componente.preco-total[1] - componente.valor-icm[1]) / componente.quantidade.
           END.
           ASSIGN de-val-difal = 0.
           FOR EACH ITEM-NF-ADC                                          /* ICMS DIFAL */
               WHERE ITEM-NF-ADC.cod-estab = nota-fiscal.cod-estabel
               AND ITEM-NF-ADC.cod-serie = nota-fiscal.serie
               AND ITEM-NF-ADC.cod-nota-fis = nota-fiscal.nr-nota-fis
               AND item-nf-adc.cod-natur-operac = nota-fiscal.nat-operacao
               AND item-nf-adc.num-seq-item-nf  = it-nota-fisc.nr-seq-fat
               AND item-nf-adc.cod-item         = it-nota-fisc.it-codigo NO-LOCK:

/*                PUT "valor icms DIFAL -3- " NOTA-FISCAL.NR-NOTA-FIS " " IT-nota-fisc.it-codigo */
/*                    item-nf-adc.val-livre-4 " "                                                */
/*                    item-nf-adc.val-livre-3 " "                                                */
/*                    de-val-liq SKIP.                                                           */

               ASSIGN de-val-difal = de-val-difal +  item-nf-adc.val-livre-4 +
                                                     item-nf-adc.val-livre-3 +
                                                 DEC(item-nf-adc.cod-livre-4).

/*                PUT "valor icms DIFAL -3a- " NOTA-FISCAL.NR-NOTA-FIS " " IT-nota-fisc.it-codigo */
/*                    item-nf-adc.val-livre-4 " "                                                 */
/*                    item-nf-adc.val-livre-3 " "                                                 */
/*                    de-val-liq                                                                  */
/*                     SKIP.                                                                      */

           END.

           IF NOT tt-param.saldo-zero AND (d-qtde = 0 OR (d-qtde < 0 AND saldo-terc.quantidade = 0)) then next.

           
           CREATE tt-comp.
           ASSIGN tt-comp.cod-emitente = saldo-terc.cod-emitente
                  tt-comp.it-codigo    = saldo-terc.it-codigo
                  tt-comp.descricao    = item.descricao-1 + item.descricao-2
                  tt-comp.nat-operacao = saldo-terc.nat-operacao
                  tt-comp.cod-estabel  = saldo-terc.cod-estabel
                  tt-comp.nro-docto    = saldo-terc.nro-docto
                  tt-comp.serie        = saldo-terc.serie
                  tt-comp.dt-emis-nota = IF AVAIL nota-fiscal THEN nota-fiscal.dt-emis-nota ELSE ?
                  tt-comp.dt-retorno   = saldo-terc.dt-retorno
                  tt-comp.sequencia    = saldo-terc.sequencia
                  tt-comp.quantidade   = d-qtde
                  tt-comp.val-unit     = val-unit
                  tt-comp.val-liq      = de-val-liq
                  tt-comp.val-difal    = de-val-difal.
           
           IF  AVAIL ped-fiscal THEN DO:
               run prgint/utb/utb742za.py persistent set h_api_ccusto.

               EMPTY TEMP-TABLE tt_log_erro.
               run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,  /* EMPRESA EMS2 */
                                                          input  "",                   /* CODIGO DO PLANO CCUSTO */
                                                          input  ped-fiscal.sc-codigo, /* CCUSTO */
                                                          input  today,                /* DATA DE TRANSACAO */
                                                          output v_des_titulo_ccusto,  /* DESCRICAO DO CCUSTO */
                                                          output table tt_log_erro).   /* ERROS */
               delete object h_api_ccusto.
           
               ASSIGN tt-comp.centro-custo = ped-fiscal.sc-codigo + "-" + v_des_titulo_ccusto.
           
               FIND FIRST usuar_mestre NO-LOCK
                    WHERE usuar_mestre.cod_usuario = ped-fiscal.usuario-magnus NO-ERROR.
                
               ASSIGN tt-comp.usuario = ped-fiscal.usuario-magnus + "-" + IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "".
           END.
           
           IF AVAIL natur-oper AND natur-oper.tipo = 2 OR NOT AVAIL natur-oper THEN DO:
               if avail it-nota-fisc then do:
                  if avail nota-fiscal then
                     assign tt-comp.observ-nota = nota-fiscal.observ-nota.
           
                  find first nar-it-not no-lock where
                       nar-it-not.cod-estabel  = it-nota-fisc.cod-estabel and
                       nar-it-not.serie        = it-nota-fisc.serie and
                       nar-it-not.nr-nota-fis  = it-nota-fisc.nr-nota-fis and
                       nar-it-not.it-codigo    = it-nota-fisc.it-codigo and
                       nar-it-not.nr-sequencia = it-nota-fisc.nr-seq-fat
                       no-error.
                  if avail nar-it-not then do:
                     assign tt-comp.narrativa = nar-it-not.narrativa.
                  end.
           
                  IF AVAIL natur-oper AND natur-oper.tipo = 2 THEN DO:
                      ASSIGN tt-comp.vl-ipi      = /*tt-comp.vl-venda * (it-nota-fisc.aliquota-ipi /100) */ it-nota-fisc.vl-ipi-it / it-nota-fisc.qt-faturada[1] * d-qtde
                             tt-comp.vl-icms     = /*tt-comp.vl-venda * (it-nota-fis.aliquota-icm / 100)*/ it-nota-fisc.vl-icms-it / it-nota-fisc.qt-faturada[1] * d-qtde.
                  END.
               end.
           END.
           ELSE DO:
               IF  AVAIL item-doc-est THEN DO:
                   IF tt-comp.narrativa = "" THEN 
                       assign tt-comp.narrativa = item-doc-est.narrativa.
           
                   IF  AVAIL natur-oper AND natur-oper.tipo = 1 THEN DO:
                       ASSIGN tt-comp.vl-ipi       = /*tt-comp.vl-venda * (it-nota-fisc.aliquota-ipi /100) */ item-doc-est.valor-ipi[1] / item-doc-est.quantidade * d-qtde
                              tt-comp.vl-icms     = /*tt-comp.vl-venda * (it-nota-fisc.aliquota-icm / 100)*/ item-doc-est.valor-icm[1] / item-doc-est.quantidade * d-qtde.
                   END.
               END.
           END.
           
           RUN pi-grade-contabil(INPUT saldo-terc.serie-docto,
                                 INPUT saldo-terc.nro-docto,
                                 INPUT saldo-terc.cod-emitente,
                                 INPUT saldo-terc.nat-operacao,
                                 INPUT saldo-terc.sequencia,
                                 INPUT YES).
           
           ASSIGN tt-comp.vl-venda  = d-qtde * tt-comp.val-liq + tt-comp.vl-ipi + tt-comp.vl-icms.
        END.  /**** if avail componente ********/
    END. /***** for each saldo-terc ******/      

    PUT UNFORMATTED "Estabel;Natureza;DescNat;Dias Leg;Dias Prazo;Prazo;Fornecedor;Nome;Item;Descriá∆o;Docto;Serie;Dt Docto;Quantidade;Preco Unit;Saldo;Preco s/Imp;Valor Total;Valor IPI;Valor ICMS;Val DIFAL;Usuario;Centro Custo;Narrativa;Observ Nota;Resumo Conta Contab;Valor Deb;Valor Cred;Resumo Conta Contab;Valor Deb;Valor Cred;" SKIP.
    
    for each tt-comp,
        first item no-lock where
              item.it-codigo = tt-comp.it-codigo 
              break by tt-comp.nat-operacao
                    by tt-comp.cod-emitente
                    by tt-comp.it-codigo
                    by tt-comp.nro-docto:

        FIND FIRST natur-oper     NO-LOCK WHERE natur-oper.nat-operacao = tt-comp.nat-operacao        NO-ERROR.
        FIND FIRST emitente       NO-LOCK WHERE emitente.cod-emitente = tt-comp.cod-emitente          NO-ERROR.
        FIND FIRST int-natur-oper NO-LOCK WHERE int-natur-oper.nat-operacao = natur-oper.nat-operacao NO-ERROR.
        IF AVAIL int-natur-oper THEN
            ASSIGN dt-prazo = ?
                   dt-prazo = tt-comp.dt-emis-nota + (int-natur-oper.dias-legislacao - int-natur-oper.dias-advertencia).

        RUN pi-acompanhar IN h-acomp (INPUT tt-comp.nro-docto).

        PUT UNFORMATTED 
            tt-comp.cod-estabel                   ";"
            tt-comp.nat-operacao                   ";"
            (IF AVAIL natur-oper                   
             THEN natur-oper.denominacao           
             ELSE "")                              ";"
            (IF AVAIL int-natur-oper                   
             THEN int-natur-oper.dias-legislacao           
             ELSE 0)                               ";"
            (IF AVAIL int-natur-oper                   
             THEN int-natur-oper.dias-advertencia  
             ELSE 0)                               ";"

            (IF  dt-prazo <= TODAY 
             AND int-natur-oper.dias-legislacao <> 0 
                 THEN "Fora Prazo"
             ELSE "Dentro Prazo")                  ";"

            emitente.cod-emitente                  ";"
            (IF AVAIL emitente                     
             THEN emitente.nome-abrev              
             ELSE "")                              ";"
             tt-comp.it-codigo                     ";"         
             tt-comp.descricao                     ";" 
             tt-comp.nro-docto                     ";"         
             tt-comp.serie                         ";"         
             tt-comp.dt-retorno                    ";"         
             tt-comp.quantidade                    ";"         
             tt-comp.val-unit                      ";"         
             tt-comp.val-unit * tt-comp.quantidade ";" 
             tt-comp.val-liq * tt-comp.quantidade  ";" 
             tt-comp.vl-venda                      ";" 
             tt-comp.vl-ipi                        ";" 
             tt-comp.vl-icms                       ";"
             tt-comp.val-difal                     ";"
             tt-comp.usuario                       ";"
             tt-comp.centro-custo                  ";".

        IF tt-param.narrativa AND item.tipo-contr <> 2 THEN DO:
           PUT UNFORMATTED
                REPLACE(REPLACE(tt-comp.narrativa,CHR(10)," "),CHR(13)," ") ";".
        END.
        ELSE PUT UNFORMATTED "-;".

        IF tt-param.observacao AND FIRST-OF(tt-comp.nro-docto) THEN DO:
            PUT UNFORMATTED 
                REPLACE(REPLACE(tt-comp.observ-nota,CHR(10)," "),CHR(13)," ") ";".
        END.
        ELSE PUT UNFORMATTED "-;".


        /* Imprime as informaá‰es das Contas de Terceiros, totalizadas.
           Sempre ter† uma Conta de Terceiro e, as vezes, uma contra-partida */
        ASSIGN i-cont = 0.
        FOR EACH  tt-conta NO-LOCK
            WHERE tt-conta.nro-docto    = tt-comp.nro-docto
            AND   tt-conta.serie-docto  = tt-comp.serie
            AND   tt-conta.cod-emitente = tt-comp.cod-emitente
            AND   tt-conta.nat-operacao = tt-comp.nat-operacao
            AND   tt-conta.sequencia    = tt-comp.sequencia
            AND   CAN-FIND(FIRST tt-contas-terc NO-LOCK
                           WHERE tt-contas-terc.conta = SUBSTRING(tt-conta.conta-contabil,1,8))
            BREAK BY tt-conta.conta-contabil:
            
            IF natur-oper.tipo = 1 THEN
                ASSIGN tt-conta.de-credito =  tt-conta.de-credito + tt-comp.val-difal.
            ELSE
                ASSIGN tt-conta.de-debito  =  tt-conta.de-debito  + tt-comp.val-difal.


            ASSIGN tt-comp.val-difal  = 0.

            ACCUMULATE tt-conta.de-debito  (TOTAL BY tt-conta.conta-contabil).
            ACCUMULATE tt-conta.de-credito (TOTAL BY tt-conta.conta-contabil).

           
            IF  LAST-OF(tt-conta.conta-contabil) THEN DO:
                ASSIGN i-cont = i-cont + 1.
                PUT UNFORMATTED tt-conta.conta-contabil ";"
                                ACCUM TOTAL BY tt-conta.conta-contabil tt-conta.de-debito  ";"
                                ACCUM TOTAL BY tt-conta.conta-contabil tt-conta.de-credito ";".
            END.
        END.

        /* Se n∆o teve contas de saldo em poder de terceiros */
        IF  i-cont = 0 THEN
            PUT UNFORMATTED "-;0;0;-;0;0;".

        /* Se n∆o teve conta de contra-partida, imprime ela como "" (branco) e zerada */
        IF  i-cont = 1 THEN
            PUT UNFORMATTED "-;0;0;".

        /* Imprime todas as informaá‰es da Grade Contabil, e Grade de Impostos */
        FOR EACH  tt-conta NO-LOCK
            WHERE tt-conta.nro-docto    = tt-comp.nro-docto
            AND   tt-conta.serie-docto  = tt-comp.serie
            AND   tt-conta.cod-emitente = tt-comp.cod-emitente
            AND   tt-conta.nat-operacao = tt-comp.nat-operacao
            AND   tt-conta.sequencia    = tt-comp.sequencia
            BY    tt-conta.conta-contabil:
            PUT UNFORMATTED tt-conta.conta-contabil ";"
                            tt-conta.de-debito  ";"
                            tt-conta.de-credito ";".
        END.


        PUT UNFORMATTED SKIP.
    END. /* for each tt-comp   */


    /*FOR EACH tt-conta BREAK BY tt-conta.conta-contabil:
        PUT UNFORMATTED
            "bbbb;"
            tt-conta.nro-docto      ";"
            tt-conta.conta-contabil ";"
            tt-conta.it-codigo      ";"
            tt-conta.sequencia      ";"
            tt-conta.de-debito      ";"
            tt-conta.de-credito     SKIP.
    END.*/
END.



PROCEDURE pi-grade-contabil:
    DEFINE INPUT PARAMETER p-serie-docto   LIKE saldo-terc.serie-docto    NO-UNDO.
    DEFINE INPUT PARAMETER p-nro-docto     LIKE saldo-terc.nro-docto      NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-emitente  LIKE saldo-terc.cod-emitente   NO-UNDO.
    DEFINE INPUT PARAMETER p-nat-operacao  LIKE saldo-terc.nat-operacao   NO-UNDO.
    DEFINE INPUT PARAMETER p-sequencia     LIKE saldo-terc.sequencia      NO-UNDO.
    DEFINE INPUT PARAMETER p-grade-impto   AS LOGICAL                     NO-UNDO.


    FOR EACH  movto-estoq NO-LOCK
        WHERE movto-estoq.serie-docto  = p-serie-docto
        AND   movto-estoq.nro-docto    = p-nro-docto
        AND   movto-estoq.cod-emitente = p-cod-emitente
        AND   movto-estoq.nat-operacao = p-nat-operacao
        AND   movto-estoq.sequen-nf    = p-sequencia:

        CREATE tt-conta.
        ASSIGN tt-conta.nro-docto      = p-nro-docto
               tt-conta.serie-docto    = p-serie-docto
               tt-conta.cod-emitente   = p-cod-emitente
               tt-conta.nat-operacao   = p-nat-operacao
               tt-conta.conta-contabil = movto-estoq.ct-saldo + movto-estoq.sc-saldo
               tt-conta.it-codigo      = movto-estoq.it-codigo
               tt-conta.sequencia      = movto-estoq.sequen-nf.

        IF  movto-estoq.tipo-trans = 1 THEN
            ASSIGN tt-conta.de-debito =  movto-estoq.valor-mat-m[1] +  movto-estoq.valor-mob-m[1] +  movto-estoq.valor-ggf-m[1].
        ELSE
            ASSIGN tt-conta.de-credito =  movto-estoq.valor-mat-m[1] +  movto-estoq.valor-mob-m[1] +  movto-estoq.valor-ggf-m[1].


        CREATE tt-conta.
        ASSIGN tt-conta.nro-docto      = p-nro-docto
               tt-conta.serie-docto    = p-serie-docto
               tt-conta.cod-emitente   = p-cod-emitente
               tt-conta.nat-operacao   = p-nat-operacao
               tt-conta.conta-contabil = movto-estoq.ct-codigo + movto-estoq.sc-codigo
               tt-conta.it-codigo      = movto-estoq.it-codigo
               tt-conta.sequencia      = movto-estoq.sequen-nf.

        IF  movto-estoq.tipo-trans = 1 THEN
            ASSIGN tt-conta.de-credito =  movto-estoq.valor-mat-m[1] +  movto-estoq.valor-mob-m[1] +  movto-estoq.valor-ggf-m[1]
                                          +  movto-estoq.valor-icm
                                          +  movto-estoq.valor-ipi
                                          +  movto-estoq.valor-pis + movto-estoq.val-cofins.
            
        ELSE
            ASSIGN tt-conta.de-debito =  movto-estoq.valor-mat-m[1] +  movto-estoq.valor-mob-m[1] +  movto-estoq.valor-ggf-m[1]
                                         +  movto-estoq.valor-icm
                                         +  movto-estoq.valor-ipi
                                         +  movto-estoq.valor-pis + movto-estoq.val-cofins.


        /* ICMS */
        IF  movto-estoq.valor-icm <> 0 THEN DO:
            CREATE tt-conta.
            ASSIGN tt-conta.nro-docto      = p-nro-docto
                   tt-conta.serie-docto    = p-serie-docto
                   tt-conta.cod-emitente   = p-cod-emitente
                   tt-conta.nat-operacao   = p-nat-operacao
                   tt-conta.conta-contabil = estabelec.ct-icm + estabelec.sc-icm
                   tt-conta.it-codigo      = movto-estoq.it-codigo
                   tt-conta.sequencia      = movto-estoq.sequen-nf.

            IF  movto-estoq.tipo-trans = 1 THEN
                ASSIGN tt-conta.de-debito  = movto-estoq.valor-icm.
            ELSE
                ASSIGN tt-conta.de-credito = movto-estoq.valor-icm.
        END.    

        /* IPI */
        IF  movto-estoq.valor-ipi <> 0 THEN DO:
            CREATE tt-conta.
            ASSIGN tt-conta.nro-docto      = p-nro-docto
                   tt-conta.serie-docto    = p-serie-docto
                   tt-conta.cod-emitente   = p-cod-emitente
                   tt-conta.nat-operacao   = p-nat-operacao
                   tt-conta.conta-contabil = estabelec.ct-ipi + estabelec.sc-ipi
                   tt-conta.it-codigo      = movto-estoq.it-codigo
                   tt-conta.sequencia      = movto-estoq.sequen-nf.

            IF  movto-estoq.tipo-trans = 1 THEN
                ASSIGN tt-conta.de-debito  = movto-estoq.valor-ipi.
            ELSE
                ASSIGN tt-conta.de-credito = movto-estoq.valor-ipi.
        END.

        /* PIS */
        IF  movto-estoq.valor-pis <> 0 THEN DO:
            CREATE tt-conta.
            ASSIGN tt-conta.nro-docto      = p-nro-docto
                   tt-conta.serie-docto    = p-serie-docto
                   tt-conta.cod-emitente   = p-cod-emitente
                   tt-conta.nat-operacao   = p-nat-operacao
                   tt-conta.conta-contabil = estabelec.cod-cta-pis-recup 
                   tt-conta.it-codigo      = movto-estoq.it-codigo
                   tt-conta.sequencia      = movto-estoq.sequen-nf.

            IF  movto-estoq.tipo-trans = 1 THEN
                ASSIGN tt-conta.de-debito  = movto-estoq.valor-pis.
            ELSE
                ASSIGN tt-conta.de-credito = movto-estoq.valor-pis.
        END.

        /* COFINS */
        IF  movto-estoq.val-cofins <> 0 THEN DO:
            CREATE tt-conta.
            ASSIGN tt-conta.nro-docto      = p-nro-docto
                   tt-conta.serie-docto    = p-serie-docto
                   tt-conta.cod-emitente   = p-cod-emitente
                   tt-conta.nat-operacao   = p-nat-operacao
                   tt-conta.conta-contabil = estabelec.cod-cta-cofins-recup
                   tt-conta.it-codigo      = movto-estoq.it-codigo
                   tt-conta.sequencia      = movto-estoq.sequen-nf.

            IF  movto-estoq.tipo-trans = 1 THEN
                ASSIGN tt-conta.de-debito  = movto-estoq.val-cofins.
            ELSE
                ASSIGN tt-conta.de-credito = movto-estoq.val-cofins.
        END.
    END.


    /* Busca a Grade dos Impostos */
    IF p-grade-impto THEN
        RUN pi-grande-impostos.

END PROCEDURE.



PROCEDURE pi-grande-impostos:
    DEFINE VARIABLE r-conta-ft            AS ROWID       NO-UNDO.
    DEFINE VARIABLE de-descto-zfm-pis     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-descto-zfm-cofins  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-vl-descicms        AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-vl-desconto        AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-vl-aux             AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-vl-tot-pis-unid    AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-vl-tot-cofins-unid AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-taxa-pis           AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-taxa-cofins        AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i-cont                AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-estab-ent-fut       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-conta-st-estab      AS CHARACTER   NO-UNDO.


    IF  NOT AVAIL it-nota-fisc OR NOT AVAIL nota-fiscal THEN
        RETURN "NOK":U.

    ASSIGN de-vl-contab = 0.


    IF  SUBSTRING(nota-fiscal.nat-operacao,1,1) = "5"  AND
        estabelec.estado                        = "AM" THEN
        RUN pi-cria-w-item IN THIS-PROCEDURE.

    FIND FIRST fat-duplic NO-LOCK
        WHERE  fat-duplic.cod-estabel = nota-fiscal.cod-estabel
        AND    fat-duplic.serie       = nota-fiscal.serie
        AND    fat-duplic.nr-fatura   = nota-fiscal.nr-fatura NO-ERROR.
    IF  AVAIL  fat-duplic AND fat-duplic.log-impto-retid = YES THEN
        ASSIGN l-ret-fat = YES.
    ELSE
        ASSIGN l-ret-fat = NO.


    FIND FIRST natur-oper NO-LOCK
        WHERE  natur-oper.nat-operacao = it-nota-fisc.nat-operacao
        AND    natur-oper.ind-contabilizacao NO-ERROR.
    IF  AVAIL  natur-oper THEN DO:

        IF  (it-nota-fisc.vl-ipi-it                  = 0  OR
             it-nota-fisc.cd-trib-ipi                = 3) AND /* outras */
            (it-nota-fisc.vl-icms-it                 = 0  OR
             it-nota-fisc.cd-trib-icm                = 3) AND /* outras */
             it-nota-fisc.vl-icmsub-it               = 0  AND
             it-nota-fisc.vl-iss-it                  = 0  AND
             it-nota-fisc.vl-irf-it                  = 0  AND
             DEC(SUBSTR(it-nota-fisc.char-2,76,5))   = 0  AND 
             DEC(SUBSTR(it-nota-fisc.char-2,81,5))   = 0  AND
             it-nota-fisc.val-unit-cofins = 0             AND
             it-nota-fisc.val-unit-pis    = 0             AND
             it-nota-fisc.emite-duplic               = NO THEN
            IF  NOT (INT(SUBSTR(natur-oper.char-1,1,5)) = 1    AND
                     natur-oper.ind-est-qtd             = YES  AND
                     nota-fiscal.int-2                  > 2000 AND
                     it-nota-fisc.nr-nota-ant           > "")  THEN
              NEXT.

        FIND item NO-LOCK
            WHERE item.it-codigo = it-nota-fisc.it-codigo NO-ERROR.

        FIND FIRST emitente NO-LOCK
            WHERE  emitente.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.
        IF  AVAIL  emitente AND VALID-HANDLE(h-cd9500) THEN DO:
            RUN pi-cd9500 IN h-cd9500(INPUT  nota-fiscal.cod-estabel,
                                      INPUT  emitente.cod-gr-cli,
                                      INPUT  ROWID(item),
                                      INPUT  it-nota-fisc.nat-oper,
                                      INPUT  (IF lContaFtPorCliente THEN STRING(nota-fiscal.cod-emitente) ELSE it-nota-fisc.serie),
                                      INPUT  it-nota-fisc.cod-depos,
                                      INPUT  nota-fiscal.cod-canal-venda,
                                      OUTPUT r-conta-ft).
        END.

        FIND FIRST conta-ft NO-LOCK
            WHERE  ROWID(conta-ft) = r-conta-ft NO-ERROR.

        IF  NOT AVAIL conta-ft   OR
            NOT AVAIL natur-oper OR
            NOT AVAIL item       THEN DO:
            {utp/ut-liter.i Grupo_de_Contas_n∆o_Cadastrado}.
            NEXT.
        END.

        
        FIND FIRST w-item NO-LOCK
             WHERE w-item.nr-sequencia = it-nota-fisc.nr-seq-fat NO-ERROR.

        /* DESCONTOS */
        /*{ftp/ft0904.i8} /* desconto de ICMS */*/
        ASSIGN de-descto-zfm-pis    = 0
               de-descto-zfm-cofins = 0.

        IF  natur-oper.log-deduz-desc-zfm-tot-nf  = YES THEN
            ASSIGN de-descto-zfm-pis    = natur-oper.val-perc-desc-pis-zfm    
                   de-descto-zfm-cofins = natur-oper.val-perc-desc-cofins-zfm   .

        ASSIGN de-vl-descicms = (1 - (DEC(SUBSTRING(natur-oper.char-2,66,5)) + de-descto-zfm-pis + de-descto-zfm-cofins) / 100) *
                                (1 - it-nota-fisc.per-des-icms              / 100)
               de-vl-descicms = it-nota-fisc.vl-merc-liq / de-vl-descicms
               de-vl-descicms = de-vl-descicms - it-nota-fisc.vl-merc-liq
               de-vl-descicms = IF  de-vl-descicms < 0 THEN 0 ELSE de-vl-descicms.

        /*{ftp/ft0904.i9} /* descontos dos itens e da nota fiscal */*/
        ASSIGN de-vl-desconto = nota-fiscal.perc-desco1                   +
                                nota-fiscal.perc-desco2                   +
                                it-nota-fisc.per-des-item                 +
                                DECIMAL(SUBSTR(it-nota-fisc.char-1,1,14)) +
                                nota-fiscal.val-pct-desconto-tab-preco    +
                                it-nota-fisc.val-pct-desconto-periodo     + 
                                it-nota-fisc.val-pct-desconto-prazo       +
                                it-nota-fisc.val-pct-desconto-tab-preco   +
                                it-nota-fisc.val-desconto-inform          +
                                nota-fiscal.desc-valor-nota.

        DO  i-cont = 1 TO 5:
            ASSIGN de-vl-desconto = de-vl-desconto + it-nota-fisc.val-desconto[i-cont]. 
        END.


        IF  it-nota-fisc.vl-tot-item  > 0                                           AND
            de-vl-desconto            > 0                                           AND /* ft0904.i9 */
            it-nota-fisc.vl-merc-ori  > (it-nota-fisc.vl-merc-liq + de-vl-descicms) AND
            natur-oper.emite-dupli    = YES                                         AND
            conta-ft.cod-cta-desc + conta-ft.cod-ccusto-desc      <> ""                                          AND /* possui conta cadastrada */
            estabelec.ct-desconto + estabelec.sc-desconto <> ""                                          AND /* possui conta cadastrada */
            (conta-ft.cod-cta-desc + conta-ft.cod-ccusto-desc      = estabelec.ct-desconto + estabelec.sc-desconto) = NO              AND /* partida <> contra */
             nota-fiscal.emite-duplic = YES THEN DO:

            ASSIGN de-vl-contab = it-nota-fisc.vl-merc-ori - it-nota-fisc.vl-merc-liq - de-vl-descicms
                   de-vl-aux    = de-vl-contab.

            RUN pi-ft0904o (INPUT "change_de-vl-desconto",
                            INPUT ROWID(it-nota-fisc),
                            INPUT "de-vl-desconto",
                            INPUT-OUTPUT de-vl-contab).


            {esp/rep/esrep008.i "estabelec.ct-desconto + estabelec.sc-desconto" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
            ASSIGN de-vl-contab = de-vl-contab * -1.
            {esp/rep/esrep008.i "conta-ft.cod-cta-desc + conta-ft.cod-ccusto-desc" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}

            /********AGREGAR DESCONTO NA RECEITA/TRANSITORIA******/
            ASSIGN de-vl-contab = it-nota-fisc.vl-merc-ori - it-nota-fisc.vl-merc-liq - de-vl-descicms
                   de-vl-aux    = de-vl-contab.

            RUN pi-ft0904o (INPUT "change_de-vl-receita",
                            INPUT ROWID(it-nota-fisc),
                            INPUT "de-vl-receita",                               
                            INPUT-OUTPUT de-vl-contab).


            {esp/rep/esrep008.i "conta-ft.ct-recven + conta-ft.sc-recven" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
            ASSIGN de-vl-contab = de-vl-contab * -1.
            {esp/rep/esrep008.i "estabelec.ct-recven + estabelec.sc-recven" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
        END.

        /* RECEITA BRUTA DE VENDAS */
        IF  it-nota-fisc.vl-tot-item > 0 AND
            it-nota-fisc.emite-duplic    AND
            nota-fiscal.emite-duplic     THEN DO:
            RUN pi-vl-contabil. /* ft0708a.i10 */

            
            {esp/rep/esrep008.i "conta-ft.ct-recven + conta-ft.sc-recven" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
            ASSIGN de-vl-contab = de-vl-contab * -1.

            FOR FIRST fat-duplic FIELDS ( mo-negoc cod-esp )
                WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                AND   fat-duplic.serie       = nota-fiscal.serie
                AND   fat-duplic.nr-fatura   = nota-fiscal.nr-fatura NO-LOCK:
            END.

            /* Diferenca de Preáo*/
            IF  nota-fiscal.ind-tip-nota = 3   AND
                l-ems5                   = NO  AND /* Integraá∆o EMS-5 */
                fat-duplic.mo-negoc      > 0   AND
                param-global.modulo-cr   = YES AND
                l-diferenca-cambial            THEN DO:


                /*
                
                N«O EXISTEM REGISTROS NA TABELA conta-cr.
                COMENTADO CONFORME ORIENTAÄ«O DE FABIANO
                
                FIND FIRST conta-cr NO-LOCK
                    WHERE  conta-cr.ep-codigo   = i-ep-codigo-usuario
                    AND    conta-cr.cod-estabel = nota-fiscal.cod-estabel
                    AND    conta-cr.cod-esp     = fat-duplic.cod-esp
                    AND    conta-cr.cod-gr-cli  = emitente.cod-gr-cli NO-ERROR.
                IF  AVAIL conta-cr THEN DO:
                {esp/rep/esrep008.i "conta-cr.conta-var-monetaria" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
                END.
                
                */
            END.
            ELSE DO:
                {esp/rep/esrep008.i "estabelec.ct-recven + estabelec.sc-recven" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"} /*"estabelec.ct-fins-pg"*/
            END.
        END.

        IF  INT(SUBSTR(natur-oper.char-1,1,5)) = 1    AND
            natur-oper.ind-est-qtd             = YES  AND
            nota-fiscal.int-2                  > 2000 AND
            it-nota-fisc.nr-nota-ant           > ""   THEN DO:
            ASSIGN c-estab-ent-fut = it-nota-fisc.cod-estabel.

            /* Localiza nota fiscal Fatura (1a Nota) */
            FIND FIRST b-nota-fatura NO-LOCK
                WHERE  b-nota-fatura.cod-estabel  = c-estab-ent-fut
                AND    b-nota-fatura.serie        = it-nota-fisc.serie-ant
                AND    b-nota-fatura.nr-nota-fis  = it-nota-fisc.nr-nota-ant
                AND    b-nota-fatura.int-2        > 2000  NO-ERROR.

            FIND FIRST b-it-fatura OF b-nota-fatura NO-LOCK
                WHERE  b-it-fatura.it-codigo = it-nota-fisc.it-codigo NO-ERROR.
            IF  AVAIL  b-nota-fatura AND AVAIL b-it-fatura THEN DO:
                FIND FIRST b-sumar-rec NO-LOCK
                    WHERE  b-sumar-rec.cod-estabel = b-nota-fatura.cod-estabel
                    AND    b-sumar-rec.dt-movto    = b-nota-fatura.dt-emis-nota
                    AND    b-sumar-rec.ct-conta    = b-it-fatura.ct-cusven
                    AND    b-sumar-rec.sc-conta    = b-it-fatura.sc-cusven
                    AND    b-sumar-rec.serie       = b-nota-fatura.serie
                    AND    b-sumar-rec.tp-imposto  = 0
                    AND    b-sumar-rec.nr-nota-fis = b-nota-fatura.nr-nota-fis NO-ERROR.
                IF  AVAIL  b-sumar-rec THEN
                    ASSIGN de-vl-contab = IF b-sumar-rec.vl-contab <= it-nota-fisc.vl-tot-item THEN b-sumar-rec.vl-contab
                                          ELSE it-nota-fisc.vl-tot-item - (IF  it-nota-fisc.cd-trib-ipi <> 3 /* outras */ THEN it-nota-fisc.vl-ipi-it ELSE 0).
                ELSE  /* quando nf ainda nao contabilizada */
                    ASSIGN de-vl-contab = it-nota-fisc.vl-tot-item - (IF it-nota-fisc.cd-trib-ipi <> 3 /* outras */ THEN it-nota-fisc.vl-ipi-it ELSE 0).

                {esp/rep/esrep008.i "conta-ft.ct-recven + conta-ft.sc-recven" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
                ASSIGN de-vl-contab = de-vl-contab * (-1).
                {esp/rep/esrep008.i "b-it-fatura.ct-cusven + b-it-fatura.sc-cusven" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"} /* Saida da receita futura */
            END.
        END.


        /* IPI */
        IF  it-nota-fisc.vl-ipi-it    > 0 AND
            it-nota-fisc.cd-trib-ipi <> 3 THEN DO:
            ASSIGN de-vl-contab = it-nota-fisc.vl-ipi-it.
            {esp/rep/esrep008.i "estabelec.ct-ipi-ft + estabelec.sc-ipi-ft" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}

            ASSIGN de-vl-contab = de-vl-contab * (-1).
            {esp/rep/esrep008.i "conta-ft.ct-ipi-ft + conta-ft.sc-ipi-ft" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
        END.


        /* ICMS */
        IF  it-nota-fisc.vl-icms-it   > 0 AND
            it-nota-fisc.cd-trib-icm <> 3 THEN DO:
            ASSIGN de-vl-contab = it-nota-fisc.vl-icms-it.
            {esp/rep/esrep008.i "estabelec.ct-icms-ft + estabelec.sc-icms-ft" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}

            ASSIGN de-vl-contab = de-vl-contab * (-1).
            {esp/rep/esrep008.i "conta-ft.ct-icms-ft + conta-ft.sc-icms-ft" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
        END.

        ASSIGN c-conta-st-estab = "".

        /* ICMSUB ICM DE SUBSTITUICAO TRIBUTARIA E ANTECIPADA */
        IF  it-nota-fisc.vl-icmsub-it > 0 THEN DO:
            ASSIGN de-vl-contab     = it-nota-fisc.vl-icmsub-it
                   c-conta-st-estab = IF natur-oper.log-icms-substto-antecip = YES THEN estabelec.cod-cta-transit-icms-antec + estabelec.cod-ccusto-transit-icms-antec ELSE estabelec.ct-icmsub-ft + estabelec.sc-icmsub-ft.

            {esp/rep/esrep008.i "c-conta-st-estab" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"} /*"estabelec.ct-icmsub-ft"*/
            ASSIGN de-vl-contab = de-vl-contab * (-1).
            {esp/rep/esrep008.i "conta-ft.ct-icmsub-ft + estabelec.sc-icmsub-ft" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
        END.


        /* ISS */
        IF  it-nota-fisc.vl-iss-it > 0 THEN DO:
            ASSIGN de-vl-contab = it-nota-fisc.vl-iss-it.
            {esp/rep/esrep008.i "estabelec.ct-iss + estabelec.sc-iss" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"} /*"estabelec.ct-iss"*/

            ASSIGN de-vl-contab = de-vl-contab * (-1).
            {esp/rep/esrep008.i "conta-ft.ct-iss-ft + conta-ft.sc-iss-ft" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
        END.


        /* IRRF */
        IF  it-nota-fisc.vl-irf-it > 0 THEN DO:
            ASSIGN de-vl-contab = it-nota-fisc.vl-irf-it.
            {esp/rep/esrep008.i "estabelec.ct-recven + estabelec.sc-recven" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"} /*"estabelec.ct-fins-pg"*/

            ASSIGN de-vl-contab = de-vl-contab *  (-1).
            {esp/rep/esrep008.i "conta-ft.ct-ir-ret + conta-ft.sc-ir-ret" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
        END.

        RUN pi-contab-retenc.


        /* PIS */
        ASSIGN de-vl-tot-pis-unid = 0.
        IF  it-nota-fisc.vl-tot-item > 0 AND
            conta-ft.ct-pis-ft + conta-ft.sc-pis-ft <> ""     THEN DO:
            IF  natur-oper.mercado = 1   THEN /*** Percentual PIS ***/
                IF  nota-fiscal.dt-emis-nota < 11/01/2002 THEN
                    ASSIGN de-taxa-pis = DECIMAL(SUBSTR(natur-oper.char-1,76,5)) / 100.
                ELSE  /* Novo tratamento de PIS e COFINS */
                    IF  it-nota-fisc.idi-forma-calc-pis = 2 /* valor por unidade */ THEN DO: /* Calcula valor total do PIS por unidade */
                        ASSIGN de-taxa-pis = 0.
                        IF  INT(SUBSTRING(it-nota-fisc.char-2,96,1)) = 1 THEN /* Tributacao do PIS = Tributado */
                            ASSIGN de-vl-tot-pis-unid = ROUND(it-nota-fisc.qt-faturada[1] * it-nota-fisc.val-unit-pis  ,2).
                        ELSE
                            ASSIGN de-vl-tot-pis-unid = 0.
                    END.
                    ELSE /* calcula PIS por percentual */
                        ASSIGN de-taxa-pis = DECIMAL(SUBSTR(it-nota-fisc.char-2,76,5))
                                            * (100 - IF SUBSTRING(it-nota-fisc.char-2,96,1) = "3"  /* Reduzido */
                                                     OR SUBSTRING(it-nota-fisc.char-2,96,1) = "4"  /* Outros   */ THEN
                                                     DECIMAL(SUBSTR(it-nota-fisc.char-2,86,5))
                                                     ELSE 0)
                                            / 10000.
            ELSE
                ASSIGN de-taxa-pis = natur-oper.perc-pis[2] / 100.


            IF  de-vl-tot-pis-unid > 0 THEN
                ASSIGN de-vl-contab = de-vl-tot-pis-unid.
            ELSE DO:
                ASSIGN de-vl-contab = it-nota-fisc.vl-tot-item
                                      - (IF  SUBSTRING(item.char-1,50,5) = " "    /* Retira PIS/Cofins Subst incorporado */
                                         OR  SUBSTRING(item.char-1,50,5) = "Sim" THEN 
                                         it-nota-fisc.vl-pis + it-nota-fisc.vl-finsocial
                                         ELSE 0)
                                      - (IF natur-oper.tp-oper-terc = 4 THEN it-nota-fisc.vl-icmsubit-e[3] ELSE it-nota-fisc.vl-icmsub-it)
                                      - (IF AVAIL w-item THEN w-item.desconto ELSE 0).

                /* IN306 - IPI integrante base PIS COFINS */ 
                /*{ftp/ft0708a.i12 de-vl-contab natur-oper}*/
                /* Nao inclui o valor no IPI na base das contrib sociais */ 
                IF  it-nota-fisc.cd-trib-ipi        <> 3     AND
                    natur-oper.log-ipi-contrib-social     <> YES THEN
                    ASSIGN de-vl-contab = de-vl-contab - it-nota-fisc.vl-ipi-it - (IF it-nota-fisc.vl-bipiit-e[3] <> 0 THEN it-nota-fisc.vl-ipiit-e[3] ELSE 0).
            
                /* Nao inclui o valor no IPI OUTRAS na base das contrib sociais */
                IF  it-nota-fisc.cd-trib-ipi          = 3     AND
                    SUBSTRING(natur-oper.char-2,16,1) = "1":U AND
                    natur-oper.log-ipi-outras-contrib-social  <> YES THEN
                    ASSIGN de-vl-contab = de-vl-contab - it-nota-fisc.vl-ipi-it - (IF it-nota-fisc.vl-bipiit-e[3] = 0 THEN it-nota-fisc.vl-ipiit-e[3] ELSE 0).


                ASSIGN de-vl-contab = de-vl-contab * de-taxa-pis
                       de-vl-contab = ROUND(de-vl-contab,2).
            END.

            IF  de-vl-contab > 0 THEN DO:
                {esp/rep/esrep008.i "estabelec.ct-pis + estabelec.sc-pis" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"} /*"estabelec.ct-pis"*/
                ASSIGN de-vl-contab = de-vl-contab * (-1).
                {esp/rep/esrep008.i "conta-ft.ct-pis-ft + conta-ft.sc-pis-ft" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
            END.
        END.

        /* COFINS */
        ASSIGN de-vl-tot-cofins-unid = 0.                         
        IF  it-nota-fisc.vl-tot-item > 0 AND conta-ft.ct-cofins-ft + conta-ft.sc-cofins-ft <> "" THEN DO:
            IF  natur-oper.mercado = 1   THEN  /*** Percentual PIS ***/
                IF  nota-fiscal.dt-emis-nota < 11/01/2002 THEN
                    ASSIGN de-taxa-cofins = DECIMAL(SUBSTR(natur-oper.char-1,81,5)) / 100.
                ELSE /* Novo tratamento de PIS e COFINS */
                    IF  it-nota-fisc.idi-forma-calc-cofins = 2 /* valor por unidade */ THEN DO: /* Calcula valor total do COFINS por unidade */
                        ASSIGN de-taxa-cofins = 0.
                        IF  INT(SUBSTRING(it-nota-fisc.char-2,97,1)) = 1 /* Tributacao COFINS = Tributado */ THEN
                            ASSIGN de-vl-tot-cofins-unid = ROUND(it-nota-fisc.qt-faturada[1] * it-nota-fisc.val-unit-cofins,2).
                        ELSE
                            ASSIGN de-vl-tot-cofins-unid = 0.
                    END.
                    ELSE /* calcula COFINS por percentual */
                        ASSIGN de-taxa-cofins = DECIMAL(SUBSTR(it-nota-fisc.char-2,81,5))
                                                * (100 - IF SUBSTR(it-nota-fisc.char-2,97,1) = "3"  /* Reduzido */
                                                         OR SUBSTR(it-nota-fisc.char-2,97,1) = "4"  /* Outros   */ THEN
                                                         DECIMAL(SUBSTR(it-nota-fisc.char-2,91,5))
                                                         ELSE 0)
                                                / 10000.
            ELSE
                ASSIGN de-taxa-cofins = natur-oper.per-fin-soc[2] / 100.

            IF  de-vl-tot-cofins-unid > 0 THEN
                ASSIGN de-vl-contab = de-vl-tot-cofins-unid.
            ELSE DO:
                ASSIGN de-vl-contab = it-nota-fisc.vl-tot-item
                                      - (IF  SUBSTR(item.char-1,50,5) = " "    /* Retira PIS/Cofins Subst incorporado */
                                         OR  SUBSTR(item.char-1,50,5) = "Sim" THEN
                                         it-nota-fisc.vl-pis + it-nota-fisc.vl-finsocial
                                         ELSE 0)
                                      - (IF natur-oper.tp-oper-terc = 4 THEN it-nota-fisc.vl-icmsubit-e[3] ELSE it-nota-fisc.vl-icmsub-it)
                                      - (IF AVAIL w-item THEN w-item.desconto ELSE 0).

                /* IN306 - IPI integrante base PIS COFINS */
                /*{ftp/ft0708a.i12 de-vl-contab natur-oper}*/
                /* Nao inclui o valor no IPI na base das contrib sociais */
                IF  it-nota-fisc.cd-trib-ipi        <> 3     AND
                    natur-oper.log-ipi-contrib-social     <> YES THEN
                    ASSIGN de-vl-contab = de-vl-contab - it-nota-fisc.vl-ipi-it - (IF it-nota-fisc.vl-bipiit-e[3] <> 0 THEN it-nota-fisc.vl-ipiit-e[3] ELSE 0).

                /* Nao inclui o valor no IPI OUTRAS na base das contrib sociais */
                IF  it-nota-fisc.cd-trib-ipi          = 3     AND
                    SUBSTRING(natur-oper.char-2,16,1) = "1":U AND
                    natur-oper.log-ipi-outras-contrib-social  <> YES THEN
                    ASSIGN de-vl-contab = de-vl-contab - it-nota-fisc.vl-ipi-it - (IF it-nota-fisc.vl-bipiit-e[3] = 0 THEN it-nota-fisc.vl-ipiit-e[3] ELSE 0).


                ASSIGN de-vl-contab = de-vl-contab * de-taxa-cofins
                       de-vl-contab = ROUND(de-vl-contab, 2).                  
            END.

            IF  de-vl-contab > 0 THEN DO:
                {esp/rep/esrep008.i "estabelec.ct-fins-pg + estabelec.sc-fins-pg" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"} /*"estabelec.ct-ir-ret"*/
                ASSIGN de-vl-contab = de-vl-contab * (-1).
                {esp/rep/esrep008.i "conta-ft.ct-cofins-ft + conta-ft.sc-cofins-ft" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
            END.
        END.

        /* PIS SUBSTITUTO */
        IF  it-nota-fisc.vl-pis > 0 THEN DO:
            ASSIGN de-vl-contab = it-nota-fisc.vl-pis.
            {esp/rep/esrep008.i "substring(estabelec.char-1,300,20) + substring(estabelec.char-1,320,20)" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
            ASSIGN de-vl-contab = de-vl-contab * (-1).
            {esp/rep/esrep008.i "conta-ft.cod-cta-pis + conta-ft.cod-ccusto-pis" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
        END.

        /* COFINS SUBSTITUTO */
        IF  it-nota-fisc.vl-finsocial > 0 THEN DO:
            ASSIGN de-vl-contab = it-nota-fisc.vl-finsocial.
            {esp/rep/esrep008.i "substring(estabelec.char-1,340,20) + substring(estabelec.char-1,360,20)" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
            ASSIGN de-vl-contab = de-vl-contab * (-1).
            {esp/rep/esrep008.i "conta-ft.cod-cta-cofins + conta-ft.cod-ccusto-cofins" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
        END.

        /* UPC Retená∆o ISS */
        RUN pi-ft0904o (INPUT "retenc_iss",
                        INPUT ROWID(it-nota-fisc),
                        INPUT "de-vl-receita",                               
                        INPUT-OUTPUT de-vl-contab).
    END.

END PROCEDURE.



PROCEDURE pi-cria-w-item:
    def var de-desconto      as decimal no-undo.
    def var de-tot-item      as decimal no-undo.
    def var de-desc-acum     as decimal no-undo.
    def var de-tot-base-icms as decimal no-undo.
    def var de-perc-rest     as decimal no-undo.

    empty temp-table w-item.

    assign de-desconto = 0.
    if  nota-fiscal.emite-duplic then do:
        for each it-nota-fisc of nota-fiscal no-lock:
            assign de-tot-base-icms = de-tot-base-icms + it-nota-fisc.vl-icms-it  
                   de-perc-rest     = it-nota-fisc.pc-restituicao.

            create w-item. 
            assign de-desconto         = round(de-tot-base-icms * de-perc-rest / 100, 2)
                   de-tot-item         = de-tot-item + it-nota-fisc.vl-tot-item
                   w-item.nr-sequencia = it-nota-fisc.nr-seq-fat
                   w-item.vl-tot-item  = it-nota-fisc.vl-tot-item.
        end.
    end.

    for each  w-item exclusive-lock
        break by w-item.nr-sequencia:
        assign w-item.desconto = if  last-of(w-item.nr-sequencia) then (de-desconto - de-desc-acum)
                                 else  round(de-desconto / de-tot-item * w-item.vl-tot-item,2)
               de-desc-acum    = de-desc-acum + w-item.desconto.
    end.
END PROCEDURE.



PROCEDURE pi-vl-contabil:
    /* Tratamento para Notas de Entrega Futura */
    if  int(natur-oper.ind-entfut) + int(natur-oper.ind-est-qtd) > 0 then do:
        if  natur-oper.ind-entfut then /* Nota de Faturamento */
            assign de-vl-contab = it-nota-fisc.vl-tot-item
                                - it-nota-fisc.vl-ipiit-e[3]
                                - it-nota-fisc.vl-icmsit-e[2]
                                - if  avail w-item
                                  then w-item.desconto
                                  else 0.
 
        else /* Nota de Remessa */
            assign de-vl-contab = it-nota-fisc.vl-ipi-it
                                + it-nota-fisc.vl-icmsub-it.
    end.
    else
        assign de-vl-contab = it-nota-fisc.vl-tot-item
                            - if  avail w-item
                              then w-item.desconto
                              else 0.
END.



PROCEDURE pi-contab-retenc:
    /* Retená∆o CSLL */
    IF  it-nota-fisc.val-retenc-csll > 0  AND l-ret-fat THEN DO:
        ASSIGN de-vl-contab = it-nota-fisc.val-retenc-csll.
        {esp/rep/esrep008.i "estabelec.ct-recven + estabelec.sc-recven" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}

        ASSIGN de-vl-contab = de-vl-contab * (-1).
        {esp/rep/esrep008.i "conta-ft.cod-cta-retenc-csll + conta-ft.cod-ccusto-retenc-csll" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
    END.

    /* Retencao PIS/PASEP */
    IF  it-nota-fisc.val-retenc-pis > 0 AND l-ret-fat THEN DO:
        ASSIGN de-vl-contab  = it-nota-fisc.val-retenc-pis.
        {esp/rep/esrep008.i "estabelec.ct-recven + estabelec.sc-recven" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}

        ASSIGN de-vl-contab = de-vl-contab * (-1).
        {esp/rep/esrep008.i "conta-ft.cod-cta-retenc-pis + conta-ft.cod-ccusto-retenc-pis" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
    END.

    /* Retená∆o COFINS */
    IF  it-nota-fisc.val-retenc-cofins > 0 AND l-ret-fat THEN DO:
        ASSIGN de-vl-contab  = it-nota-fisc.val-retenc-cofins.
        {esp/rep/esrep008.i "estabelec.ct-recven + estabelec.sc-recven" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}

        ASSIGN de-vl-contab = de-vl-contab * (-1).
        {esp/rep/esrep008.i "conta-ft.cod-cta-retenc-cofins + conta-ft.cod-ccusto-retenc-cofins" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
    END.

    /* Retená∆o ISS */
    IF  l-funcao-iss-retido AND DEC(TRIM(SUBSTR(it-nota-fisc.char-2,218,14))) > 0 THEN DO:  /* valor de retenáao > que zero */
        ASSIGN de-vl-contab = DEC(TRIM(SUBSTR(it-nota-fisc.char-2,218,14))).
        {esp/rep/esrep008.i "estabelec.ct-recven + estabelec.sc-recven" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
        
        ASSIGN de-vl-contab = de-vl-contab * (-1).
        {esp/rep/esrep008.i "conta-ft.cod-cta-retenc-iss + conta-ft.cod-ccusto-retenc-iss" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
    END.

    /* INSS */
    IF  it-nota-fisc.vl-ir-adic > 0 THEN DO:
        IF  INT(SUBSTR(natur-oper.char-2,71,5)) = 1 THEN DO: /* Indica se possu° INSS na Fonte */
            ASSIGN de-vl-contab  = it-nota-fisc.vl-ir-adic.
            /*Indica se Ç produtor rural*/
            IF  emitente.log-controla-val-max-inss = YES THEN
                ASSIGN de-vl-contab = de-vl-contab + 
                       it-nota-fisc.val-sat +
                       it-nota-fisc.val-senar.

            {esp/rep/esrep008.i "estabelec.ct-recven + estabelec.sc-recven" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
            ASSIGN de-vl-contab = de-vl-contab * (-1).
            {esp/rep/esrep008.i "conta-ft.cod-cta-inss-retid + conta-ft.cod-ccusto-inss-retid" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
        END.
        ELSE DO:
            ASSIGN de-vl-contab  = it-nota-fisc.vl-ir-adic.
            {esp/rep/esrep008.i "estabelec.cod-cta-inss-recolh + estabelec.cod-ccusto-inss-recolh" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}

            ASSIGN de-vl-contab = de-vl-contab * (-1).
            {esp/rep/esrep008.i "conta-ft.cod-cta-inss-retid + conta-ft.cod-ccusto-inss-retid" "de-vl-contab" "it-nota-fisc.cod-unid-negoc"}
        END.
    END.
END PROCEDURE.



PROCEDURE pi-ft0904o:
    DEF INPUT        PARAMETER p-c-cod-evento      AS CHAR     NO-UNDO.
    DEF INPUT        PARAMETER p-r-it-nota-fisc    AS ROWID    NO-UNDO.
    DEF INPUT        PARAMETER p-c-desc-valor      AS CHAR     NO-UNDO.
    DEF INPUT-OUTPUT PARAMETER p-de-valor          AS DECIMAL  NO-UNDO.
    
    IF  p-c-cod-evento = "Change_de-vl-desconto" OR p-c-cod-evento = "Change_de-vl-receita" THEN DO:
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = p-c-cod-evento
               tt-epc.cod-parameter = "rowid_it-nota-fisc"
               tt-epc.val-parameter = string(p-r-it-nota-fisc).
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = p-c-cod-evento
               tt-epc.cod-parameter = p-c-desc-valor
               tt-epc.val-parameter = string(p-de-valor). /* valor do desconto */
        
        IF  p-c-cod-evento = "Change_de-vl-desconto" THEN DO:
            {include/i-epc201.i "Change_de-vl-desconto"}
        END.
        ELSE DO:
            {include/i-epc201.i "Change_de-vl-receita"}
        END.

        /* trata retorno da UPC */
        FIND FIRST tt-epc
             WHERE tt-epc.cod-event     = p-c-cod-evento
             AND   tt-epc.cod-parameter = p-c-desc-valor NO-ERROR.
        IF  AVAIL tt-epc THEN
            ASSIGN p-de-valor = decimal(tt-epc.val-parameter).
    END.
    ELSE DO:
        DEF VAR c-conta-recven        AS CHAR FORMAT "X(40)"            NO-UNDO.
        DEF VAR c-conta-issret        AS CHAR FORMAT "X(17)"            NO-UNDO.
        DEF VAR c-desc-conta          LIKE conta-contab.titulo          NO-UNDO.
    
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = p-c-cod-evento
               tt-epc.cod-parameter = "rowid_it-nota-fisc"
               tt-epc.val-parameter = string(p-r-it-nota-fisc).
    
        {include/i-epc201.i "Retenc_Iss"}
    
        /* trata retorno da UPC */
        FIND FIRST tt-epc
             WHERE tt-epc.cod-event     = p-c-cod-evento
             AND   tt-epc.cod-parameter = "Value_Iss_Retenc" NO-ERROR.
        IF  AVAIL tt-epc THEN DO:
            FIND FIRST it-nota-fisc NO-LOCK WHERE ROWID(it-nota-fisc) = p-r-it-nota-fisc NO-ERROR.
    
            IF AVAIL it-nota-fisc THEN DO:
                FIND nota-fiscal WHERE nota-fiscal.cod-estabel = it-nota-fisc.cod-estabel
                                   AND nota-fiscal.serie       = it-nota-fisc.serie
                                   AND nota-fiscal.nr-nota-fis = it-nota-fisc.nr-nota-fis NO-LOCK NO-ERROR.
    
                ASSIGN c-conta-recven = ENTRY(1,tt-epc.val-parameter,";")
                       c-conta-issret = ENTRY(2,tt-epc.val-parameter,";")
                       p-de-valor     = decimal(ENTRY(3,tt-epc.val-parameter,";")).
    
                {esp/rep/esrep008.i "c-conta-recven" "p-de-valor" "it-nota-fisc.cod-unid-negoc"}
                ASSIGN p-de-valor = p-de-valor *  (-1).
                {esp/rep/esrep008.i "c-conta-issret" "p-de-valor" "it-nota-fisc.cod-unid-negoc"}
            END.
        END.
    END.

    EMPTY TEMP-TABLE tt-epc.
    /* ftp/ft0904o.p */
END PROCEDURE.
