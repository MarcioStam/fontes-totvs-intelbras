/*----------------------------------------------------------------------
**  Programa..: esp/ftp/esftp066rp.p
**  Autor.....: Rubia Oliveira
**  Data......: Maráo/2016
**  Descricao.: Separaá∆o de itens para embarque por transportadora - WMS
-----------------------------------------------------------------------*/
DEFINE BUFFER empresa FOR mgcad.empresa.
{include/i-prgvrs.i esftp066 2.00.00.000}

/*---------------------------  Variaveis    ---------------------------*/

{include/i-rpvar.i}
{utp/ut-glob.i}

{include/tt-edit.i}

DEFINE VARIABLE h-acomp         AS HANDLE       NO-UNDO.
DEFINE VARIABLE l-it-dep-fat    AS LOGICAL      NO-UNDO.
DEFINE VARIABLE cList           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cListEmbarque   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cListNF         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lSepara-mg      AS LOGICAL      NO-UNDO.
DEFINE VARIABLE vValTotalNota   LIKE nota-fiscal.vl-tot-nota NO-UNDO.
DEFINE VARIABLE vqtTotalVol     AS INT /*LIKE nota-fiscal.nr-volumes */ NO-UNDO.
DEF VAR l-volta                 AS LOG.
DEFINE VARIABLE l-retorno-astec AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-deposito      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cRastreabilidade AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cTipoVolume      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-depos      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-ean13      AS CHARACTER   COLUMN-LABEL "Cod.EAN" NO-UNDO.
DEFINE VARIABLE c-transp AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-ativa-log      AS LOGICAL     NO-UNDO.
ASSIGN cRastreabilidade = "Com Rastreabilidade;Sem Rastreabilidade;Ambos":U
       cTipoVolume      = "Padrao;Fracionada;Padrao e Fracionado":U.
DEF BUFFER b-nota-fiscal        FOR nota-fiscal.
/*---------------------------  Temp-Tables  ---------------------------*/

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino             AS INTEGER
    FIELD arquivo             AS CHARACTER FORMAT "x(35)":U
    FIELD usuario             AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec           AS DATE
    FIELD hora-exec           AS INTEGER
    FIELD nr-embarque         LIKE pre-fatur.cdd-embarq
    FIELD tipo-volume         AS INTEGER
    FIELD cod-estabel         AS CHAR
    FIELD tipo-funcao         AS INTEGER.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
   FIELD raw-digita         AS RAW.

DEFINE TEMP-TABLE tt-item NO-UNDO
    FIELD separa-mg         AS LOGICAL
    FIELD nome-transp       LIKE nota-fiscal.nome-transp
    FIELD estado            LIKE nota-fiscal.estado
    FIELD it-codigo         LIKE it-dep-fat.it-codigo
    FIELD desc-item         LIKE ITEM.desc-item
    FIELD cod-refer         LIKE ped-item.cod-refer
    FIELD un                LIKE ITEM.un
    FIELD deposito          LIKE it-dep-fat.cod-depos
    FIELD localizacao       LIKE it-dep-fat.cod-localiz
    FIELD pedido            LIKE it-dep-fat.nr-pedcli
    FIELD qt-alocada        LIKE it-pre-fat.qt-alocada
    FIELD l-fracionado      AS LOG
    FIELD nr-serie          LIKE it-dep-fat.nr-serlot
    FIELD cod-cli-dif       LIKE cli-difer.cod-emitente

    /* EMBARQUE */          
    FIELD cdd-embarque      LIKE it-dep-fat.cdd-embarq
    FIELD nr-resumo         LIKE it-dep-fat.nr-resumo    
    FIELD nome-abrev        LIKE it-dep-fat.nome-abrev   
    FIELD nr-pedcli         LIKE it-pre-fat.nr-pedcli    
    FIELD nr-embarque       LIKE it-dep-fat.nr-embarque 

    /* NOTA */
    FIELD cod-estabel       LIKE nota-fiscal.cod-estabel
    FIELD serie             LIKE nota-fiscal.serie      
    FIELD nr-nota-fis       LIKE nota-fiscal.nr-nota-fis

    FIELD nr-seq-fat        LIKE it-nota-fisc.nr-seq-fat
    FIELD nota-classif      LIKE nota-fiscal.nr-nota-fis
    FIELD obs-cli-difer     AS CHAR
    FIELD sequencia         AS INTEGER
    FIELD qt-item           AS INTEGER COLUMN-LABEL "CAIXA FATOR"
    INDEX idx-item separa-mg nome-transp it-codigo cod-refer deposito localizacao nr-serie cod-cli-dif.


DEFINE BUFFER bf-item FOR tt-item.


DEFINE TEMP-TABLE tt-pre-fatur NO-UNDO
    FIELD nr-embarque       LIKE pre-fatur.cdd-embarq
    FIELD nr-resumo         LIKE pre-fatur.nr-resumo
    FIELD nome-abrev        LIKE pre-fatur.nome-abrev
    FIELD nr-pedcli         LIKE pre-fatur.nr-pedcli
    INDEX id-pre-fatur IS PRIMARY UNIQUE nr-embarque nr-resumo nome-abrev nr-pedcli.


DEFINE TEMP-TABLE ttEmbarques NO-UNDO
    FIELD separa-mg         AS LOGICAL
    FIELD nome-transp       LIKE nota-fiscal.nome-transp
    FIELD estado            LIKE nota-fiscal.estado
    FIELD nr-embarque       LIKE pre-fatur.cdd-embarq
    FIELD cod-cli-dif       LIKE cli-difer.cod-emitente
    INDEX idx-emb IS PRIMARY UNIQUE separa-mg nome-transp estado cod-cli-dif nr-embarque.


DEFINE TEMP-TABLE ttNota-fiscal NO-UNDO
    FIELD separa-mg         AS LOGICAL
    FIELD nome-transp       LIKE nota-fiscal.nome-transp
    FIELD estado            LIKE nota-fiscal.estado
    FIELD cod-estabel       LIKE nota-fiscal.cod-estabel
    FIELD serie             LIKE nota-fiscal.serie
    FIELD nr-nota-fis       LIKE nota-fiscal.nr-nota-fis
    FIELD vl-tot-nota       LIKE nota-fiscal.vl-tot-nota
    FIELD nr-volumes        LIKE nota-fiscal.nr-volumes
    FIELD cod-cli-dif       LIKE cli-difer.cod-emitente
    INDEX id-nota cod-estabel serie nr-nota-fis
    INDEX transp-nota IS PRIMARY separa-mg nome-transp nr-nota-fis.

DEFINE TEMP-TABLE tt-pedido-astec
    FIELD nr-nota-fis  AS CHARACTER FORMAT "x(7)" COLUMN-LABEL "Nota Fiscal"
    FIELD serie        AS CHARACTER FORMAT "x(1)" COLUMN-LABEL "Serie"
    FIELD nr-pedcli    AS CHARACTER FORMAT "x(10)" COLUMN-LABEL "Pedido"
    FIELD nr-volumes   AS CHARACTER FORMAT "x(7)" COLUMN-LABEL "Nr.Volumes"
    FIELD nome-transp  AS CHARACTER FORMAT "x(15)" COLUMN-LABEL "Transportadora"
INDEX ch_ped nr-nota-fis nr-pedcli.


DEFINE TEMP-TABLE tt-estado
    FIELD estado            AS CHAR FORMAT "x(02)".

DEFINE TEMP-TABLE tt-item-rast NO-UNDO
    FIELD it-codigo LIKE item.it-codigo
    INDEX chItem AS PRIMARY
        it-codigo.

DEFINE TEMP-TABLE tt-notaOrigem LIKE nota-fiscal.

DEF VAR i-cont              AS INT.
DEF VAR c-est               AS CHAR.
DEF VAR de-qt-alocada       LIKE it-pre-fat.qt-alocada.

DEF VAR x-cli-difer     AS INT.
DEF VAR c-nr-nota-fis   LIKE nota-fiscal.nr-nota-fis.
DEF VAR c-serie         LIKE nota-fiscal.serie.
DEFINE VARIABLE c-obs-cli-difer AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-mensagem      AS CHARACTER   NO-UNDO.

FORM 
    tt-item.nome-transp 
    WITH FRAME f-nome-transp SIDE-LABELS STREAM-IO WIDTH 132.

FORM 
    tt-item.estado
    " - "
    unid-feder.no-estado NO-LABEL 
    WITH FRAME f-estado STREAM-IO SIDE-LABELS WIDTH 132.


FORM tt-pedido-astec.nr-pedcli   
     tt-pedido-astec.nr-nota-fis 
     tt-pedido-astec.serie       
     tt-pedido-astec.nr-volumes  
     tt-pedido-astec.nome-transp
WITH FRAME f-detalhe-astec WIDTH 132 64 DOWN STREAM-IO NO-ATTR-SPACE.

/*---------------------------  ParÉmetros   ---------------------------*/

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

ASSIGN l-ativa-log = NO.
CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita NO-LOCK:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

/* TRATATIVA REFERENTE A INTEGRACAO MFT X WMS*/
/* Temp-Tables para WMS */
{wmp/wm9000.i}
{method/dbotterr.i}

DEF BUFFER b-integra-mft-wms    FOR integra-mft-wms.
DEFINE VARIABLE c-cod-integra   LIKE integra-mft-wms.cod-integra  NO-UNDO.
DEFINE VARIABLE i-seqWmDoctoIt AS INTEGER   INIT 10  NO-UNDO.

/*---------------------------  Frames       ---------------------------*/
FIND FIRST param-global NO-LOCK.
FIND FIRST empresa      NO-LOCK WHERE empresa.ep-codigo = param-global.empresa-pri.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Separaá∆o de Itens por Embarque"
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE ''
       c-programa     = "esftp066"
       c-versao       = "2.00"
       c-revisao      = "000".

{include/i-rpcab.i}

/*---------------------------  Main Block   ---------------------------*/
run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Imprimindo...").

/* Coloquei estas linhas no programa - Clayton Antunes */
DEF VAR i-nome-programa AS CHAR.
DEF VAR i-ponto AS INT.
DEF VAR i-sequencia AS INT.
DEF VAR i-conteudo AS CHAR.
{esp/es0018.i}
       
DEF TEMP-TABLE tt-prog-ponto-tmp
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.   

DEF BUFFER b-ponto-programa FOR ponto-programa.

FOR EACH b-ponto-programa WHERE 
         b-ponto-programa.nome-programa = "esftp066":
    RUN esp\es0018p.p (INPUT b-ponto-programa.nome-programa,
                       INPUT b-ponto-programa.ponto,
                       INPUT i-sequencia,
                       INPUT i-conteudo,
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    FOR EACH TT-PROG-PONTO:
        CREATE tt-prog-ponto-tmp.
        BUFFER-COPY TT-PROG-PONTO TO tt-prog-ponto-tmp.
    END.
END.

FOR EACH item-rast FIELDS(it-codigo data-ini data-fim) NO-LOCK 
    WHERE item-rast.data-ini  <= TODAY
    AND   item-rast.data-fim   > TODAY:
    CREATE tt-item-rast.         
    ASSIGN tt-item-rast.it-codigo = item-rast.it-codigo.
END.

run pi-acompanhar in h-acomp (input "Buscando dados...").

{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

FOR EACH tt-notaOrigem:
    DELETE tt-notaOrigem.
END.

ASSIGN c-transp = "".
bl_valida:
FOR EACH  pre-fatur NO-LOCK     
    WHERE pre-fatur.cdd-embarq = tt-param.nr-embarque,
    EACH it-pre-fat NO-LOCK OF pre-fatur:
    FOR FIRST nota-fiscal
        WHERE nota-fiscal.cdd-embarq     = pre-fatur.cdd-embarq
        AND   nota-fiscal.nr-resumo      = pre-fatur.nr-resumo
        AND   nota-fiscal.nome-ab-cli    = pre-fatur.nome-abrev
        AND   nota-fiscal.nr-pedcli      = pre-fatur.nr-pedcli
        AND   nota-fiscal.cod-estabel    = tt-param.cod-estabel
        AND   nota-fiscal.dt-cancela     = ? NO-LOCK:

        IF nota-fiscal.idi-sit-nf-eletro <> 3 THEN DO:
            ASSIGN c-mensagem = "Nota n∆o autorizada! Estab: " + nota-fiscal.cod-estabel + " Serie: " + nota-fiscal.serie + " Nota: " + nota-fiscal.nr-nota-fis + ".".
            PUT c-mensagem FORMAT 'x(256)' SKIP.
            LEAVE bl_valida.
        END.

        IF nota-fiscal.dt-confirma = ? THEN DO:
            ASSIGN c-mensagem = "Nota n∆o atualizada no estoque! Estab: " + nota-fiscal.cod-estabel + " Serie: " + nota-fiscal.serie + " Nota: " + nota-fiscal.nr-nota-fis + ".".
            PUT c-mensagem FORMAT 'x(256)' SKIP.
            LEAVE bl_valida.
        END.

        FOR FIRST devol-cli
            WHERE  devol-cli.cod-estabel  = nota-fiscal.cod-estabel
            AND    devol-cli.serie        = nota-fiscal.serie
            AND    devol-cli.nr-nota-fis  = nota-fiscal.nr-nota-fis
            AND    devol-cli.nr-sequencia = it-pre-fat.nr-sequencia
            AND    devol-cli.it-codigo    = it-pre-fat.it-codigo NO-LOCK: END.
        IF AVAIL devol-cli THEN DO:
            ASSIGN c-mensagem = "Nota devolvida! Estab: " + nota-fiscal.cod-estabel + " Serie: " + nota-fiscal.serie + " Nota: " + nota-fiscal.nr-nota-fis + " Item: " + it-pre-fat.it-codigo +  ".".
            PUT c-mensagem FORMAT 'X(256)' SKIP.
            LEAVE bl_valida.
        END.
        
        IF c-transp <> "" AND c-transp <> nota-fiscal.nome-transp THEN DO:
            ASSIGN c-mensagem = "Existem notas com transportadoras diferentes.(" + c-transp + " e " + nota-fiscal.nome-transp + ")" .
            PUT c-mensagem FORMAT 'X(256)' SKIP.
            LEAVE bl_valida.
        END.

        ASSIGN c-transp = nota-fiscal.nome-transp.


    END. /* FOR FIRST nota-fiscal NO-LOCK */
END.

IF c-mensagem = "" THEN DO:
    /* opá‰es */
    CASE  tt-param.tipo-volume :
        WHEN 1 THEN /*PADR«O*/
            RUN pi-gera-tt-item (INPUT NO).
    
        WHEN 2 THEN /*FRACIONADO*/
            RUN pi-gera-tt-item (INPUT YES).
    
        WHEN 3 THEN DO: /*AMBOS*/
            RUN pi-gera-tt-item (INPUT NO).
            RUN pi-gera-tt-item (INPUT YES).
        END.
    END.
    
    IF l-ativa-log  THEN
        PUT "11 " 
            " tt-param.cod-estabel "  tt-param.cod-estabel
            " tt-param.nr-embarque "  tt-param.nr-embarque SKIP.

    ASSIGN c-transp = "".
    FOR EACH  nota-fiscal
        WHERE nota-fiscal.cod-estabel = tt-param.cod-estabel
        AND   nota-fiscal.cdd-embarq  = tt-param.nr-embarque NO-LOCK,
        FIRST natur-oper
        WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-LOCK:
    
        IF l-ativa-log  THEN
            PUT "11-1 " SKIP.
    
        {esinc/es0004.i} /*ValidaNaturezasImpress∆oNFs*/
        
        ASSIGN c-transp = nota-fiscal.nome-transp.
    
        IF l-ativa-log  THEN
            PUT "11-2 " SKIP.
    
        IF natur-oper.log-oper-triang THEN DO:
    
            FOR FIRST b-nota-fiscal
                WHERE b-nota-fiscal.cdd-embarq  = nota-fiscal.cdd-embarq
                AND   b-nota-fiscal.nr-resumo   = nota-fiscal.nr-resumo
                AND   b-nota-fiscal.nome-ab-cli = nota-fiscal.nome-ab-cli
                AND   b-nota-fiscal.nr-pedcli   = ""
                AND   b-nota-fiscal.cod-estabel = tt-param.cod-estabel
                AND   b-nota-fiscal.dt-cancela  = ? NO-LOCK:
    
                ASSIGN c-transp = b-nota-fiscal.nome-transp.
            END. /* FOR FIRST b-nota-fiscal NO-LOCK */
        END. /* IF natur-oper.log-oper-triang THEN DO: */
    
        IF AVAIL b-nota-fiscal THEN DO:
    
            FIND FIRST tt-notaOrigem
                WHERE tt-notaOrigem.cod-estabel  = b-nota-fiscal.cod-estabel
                AND   tt-notaOrigem.serie        = b-nota-fiscal.serie
                AND   tt-notaOrigem.nr-nota-fis  = b-nota-fiscal.nr-nota-fis  NO-LOCK NO-ERROR.
    
            IF NOT AVAIL tt-notaOrigem THEN DO:
    
                IF l-ativa-log  THEN
                    PUT "11-3 " SKIP.
    
                CREATE tt-notaOrigem.
                ASSIGN tt-notaOrigem.nome-transp  = b-nota-fiscal.nome-transp 
                       tt-notaOrigem.nat-operacao = b-nota-fiscal.nat-operacao
                       tt-notaOrigem.cod-emitente = b-nota-fiscal.cod-emitente
                       tt-notaOrigem.estado       = b-nota-fiscal.estado     
                       tt-notaOrigem.cod-estabel  = b-nota-fiscal.cod-estabel
                       tt-notaOrigem.serie        = b-nota-fiscal.serie      
                       tt-notaOrigem.nr-nota-fis  = b-nota-fiscal.nr-nota-fis
                       tt-notaOrigem.vl-tot-nota  = b-nota-fiscal.vl-tot-nota
                       tt-notaOrigem.nr-volumes   = b-nota-fiscal.nr-volumes 
                       tt-notaOrigem.nome-abrev   = b-nota-fiscal.nome-ab-cli.
            END. /*  IF NOT AVAIL tt-notaOrigem THEN DO: */
        END. /* IF AVAIL b-nota-fiscal THEN DO: */
        ELSE DO:
    
            IF AVAIL nota-fiscal THEN DO:
    
                FIND FIRST tt-notaOrigem
                    WHERE tt-notaOrigem.cod-estabel  = nota-fiscal.cod-estabel 
                    AND   tt-notaOrigem.serie        = nota-fiscal.serie       
                    AND   tt-notaOrigem.nr-nota-fis  = nota-fiscal.nr-nota-fis  NO-LOCK NO-ERROR.
    
                IF NOT AVAIL tt-notaOrigem THEN DO:
    
                IF l-ativa-log  THEN
                    PUT "11-4 " SKIP.
    
                    CREATE tt-notaOrigem.
                    ASSIGN tt-notaOrigem.nome-transp  = nota-fiscal.nome-transp 
                           tt-notaOrigem.nat-operacao = nota-fiscal.nat-operacao
                           tt-notaOrigem.cod-emitente = nota-fiscal.cod-emitente
                           tt-notaOrigem.estado       = nota-fiscal.estado     
                           tt-notaOrigem.cod-estabel  = nota-fiscal.cod-estabel
                           tt-notaOrigem.serie        = nota-fiscal.serie      
                           tt-notaOrigem.nr-nota-fis  = nota-fiscal.nr-nota-fis
                           tt-notaOrigem.vl-tot-nota  = nota-fiscal.vl-tot-nota
                           tt-notaOrigem.nr-volumes   = nota-fiscal.nr-volumes 
                           tt-notaOrigem.nome-abrev   = nota-fiscal.nome-ab-cli
                           tt-notaOrigem.nome-ab-cli  = nota-fiscal.nome-ab-cli.
                END. /*  IF NOT AVAIL tt-notaOrigem THEN DO: */
                ELSE DO:
                    ASSIGN tt-notaOrigem.nome-abrev   = nota-fiscal.nome-ab-cli 
                           tt-notaOrigem.nome-ab-cli  = nota-fiscal.nome-ab-cli.
                END.
            END. /* IF AVAIL nota-fiscal THEN DO: */
        END. /* IF NOT AVAIL b-nota-fiscal THEN DO: */
    END. /* FOR EACH  nota-fiscal NO-LOCK */
END.

IF l-ativa-log  THEN
    PUT "12 " SKIP.

/*********** Transportadora informada ***********/

run pi-acompanhar in h-acomp (input "Imprimindo...").

EMPTY TEMP-TABLE ttWm-docto.
EMPTY TEMP-TABLE ttWm-docto-itens.

/* INTEGRACAO MFT X WMS INTEGRACAO MFT X WMS INTEGRACAO MFT X WMS INTEGRACAO MFT X WMS INTEGRACAO MFT X WMS */
FOR EACH deposito
    WHERE deposito.log-gera-wms = YES NO-LOCK:

    /* analisar virgula */
    FOR EACH tt-item:

        IF INDEX(tt-item.deposito,deposito.cod-depos) <> 0 THEN 
            ASSIGN tt-item.deposito = deposito.cod-depos.
    END. /* FOR EACH tt-item: */
END. /* FOR EACH deposito */
/* INTEGRACAO MFT X WMS INTEGRACAO MFT X WMS INTEGRACAO MFT X WMS INTEGRACAO MFT X WMS INTEGRACAO MFT X WMS */

IF l-ativa-log  THEN
    PUT "22 " SKIP.

IntegraWMS: DO TRANSACTION
    ON ERROR  UNDO IntegraWMS, LEAVE IntegraWMS
    ON QUIT   UNDO IntegraWMS, LEAVE IntegraWMS
    ON ENDKEY UNDO IntegraWMS, LEAVE IntegraWMS
    ON STOP   UNDO IntegraWMS, LEAVE IntegraWMS:

    FOR EACH tt-item NO-LOCK
        BREAK  BY tt-item.separa-mg 
              BY tt-item.nome-transp  
              BY tt-item.l-fracionado
              BY tt-item.estado
              BY tt-item.cod-cli-dif 
              BY tt-item.nota-classif
              BY tt-item.deposito
              BY tt-item.sequencia
              BY tt-item.it-codigo
        WITH STREAM-IO WIDTH 132:

        IF l-ativa-log  THEN
            PUT "23 " tt-item.it-codigo "  "  tt-item.estado " " tt-item.nome-transp SKIP.

        IF FIRST-OF(tt-item.nome-transp) AND FIRST-OF(tt-item.l-fracionado) THEN DO:

            PUT "     Funá∆o:" IF tt-param.tipo-funcao = 2 THEN "Relat¢rio" ELSE "Integraá∆o" FORMAT "x(19)":U AT 20
               "   Volumes:":U
               ENTRY(tt-param.tipo-volume,     cTipoVolume,      ";":U) FORMAT "x(20)":U AT 60 SKIP.

           DISPLAY tt-item.nome-transp WITH FRAME f-nome-transp.
        END. /* IF FIRST-OF(tt-item.nome-transp) THEN DO: */

        IF l-ativa-log  THEN
            PUT "INTEGRACAO MFT X WMS " tt-item.it-codigo "  "  tt-item.estado " " tt-item.nome-transp FORMAT 'x(100)' SKIP.

        FIND FIRST deposito
            WHERE INDEX(tt-item.deposito,deposito.cod-depos) <> 0
            AND   deposito.log-gera-wms = YES NO-LOCK NO-ERROR.

        /*IF tt-item.qt-item = 0 THEN DO:
            PUT "Erro WMS: item " + tt-item.it-codigo + " n∆o possui cadastro de caixa! (FT0305)"   FORMAT 'x(200)' SKIP.
            UNDO IntegraWMS, LEAVE IntegraWMS.
        END.*/

        IF AVAIL deposito THEN DO:

            IF l-ativa-log  THEN
                PUT "INTEGRACAO MFT X WMS - 2" FORMAT 'x(100)' SKIP.

            ASSIGN i-seqWmDoctoIt = 10.

            IF  tt-item.qt-item <> 0
            AND tt-item.qt-alocada MODULO tt-item.qt-item = 0 THEN DO:

                IF l-ativa-log  THEN
                    PUT "INTEGRACAO MFT X WMS - 3" FORMAT 'x(100)' SKIP.

                FIND FIRST transporte WHERE transporte.nome-abrev = tt-item.nome-transp NO-LOCK NO-ERROR.

                IF AVAIL transporte THEN DO:

                    FIND FIRST int-transporte WHERE int-transporte.cod-transp = transporte.cod-transp NO-LOCK NO-ERROR.

                    IF AVAIL int-transporte THEN DO:

                        IF l-ativa-log  THEN
                            PUT "INTEGRACAO MFT X WMS - 4 " tt-item.cdd-embarque " " tt-item.estado FORMAT 'x(100)' SKIP.

                        IF int-transporte.separa-uf = YES THEN DO:

                            IF l-ativa-log  THEN
                                PUT "Separa uf testestes" string(tt-item.cdd-embarque) "-" + tt-item.estado FORMAT 'x(100)' SKIP.

                            ASSIGN c-cod-integra  = ''.

                            IF l-ativa-log  THEN
                                PUT "Separa uf2 testestestes " string(tt-item.cdd-embarque) "-" + tt-item.estado FORMAT 'x(100)' SKIP.

                            FIND LAST b-integra-mft-wms
                                WHERE b-integra-mft-wms.cod-integra = STRING(STRING(tt-item.cdd-embarque) + '-' + tt-item.estado) NO-LOCK NO-ERROR.

                            IF NOT AVAIL b-integra-mft-wms THEN DO:

                                CREATE integra-mft-wms.
                                ASSIGN integra-mft-wms.usuario-integra  = c-seg-usuario
                                       integra-mft-wms.hora-integra     = STRING(TIME,'hh:mm')
                                       integra-mft-wms.dt-integra       = TODAY
                                       integra-mft-wms.seq-integra      = 1
                                       integra-mft-wms.cod-integra      = STRING(STRING(tt-item.cdd-embarque) + '-' + tt-item.estado)
                                       c-cod-integra                    = integra-mft-wms.cod-integra.

                                IF l-ativa-log  THEN
                                    PUT "Separa uf3 c-cod-integra " c-cod-integra FORMAT 'x(100)' SKIP.
                            END. /* IF NOT AVAIL b-integra-mft-wms THEN DO: */
                            ELSE DO: 

                                ASSIGN c-cod-integra = string(string(tt-item.cdd-embarque) + '-' + tt-item.estado).

                                IF l-ativa-log  THEN
                                    PUT "Separa uf4 c-cod-integra " c-cod-integra FORMAT 'x(100)' SKIP.
                            END.

                            RUN pi-ttWMS.
                        END. /* IF int-transporte.separa-uf = YES THEN DO: */
                        ELSE DO:

                            ASSIGN c-cod-integra  = ''.

                            FIND LAST b-integra-mft-wms
                                WHERE b-integra-mft-wms.cod-integra = string(tt-item.cdd-embarque) NO-LOCK NO-ERROR.

                            IF NOT AVAIL b-integra-mft-wms THEN DO:

                                CREATE integra-mft-wms.
                                ASSIGN integra-mft-wms.usuario-integra  = c-seg-usuario
                                       integra-mft-wms.hora-integra     = STRING(TIME,'hh:mm')
                                       integra-mft-wms.dt-integra       = TODAY
                                       integra-mft-wms.seq-integra      = 1
                                       integra-mft-wms.cod-integra      = string(tt-item.cdd-embarque)
                                       c-cod-integra                    = integra-mft-wms.cod-integra.
                            END. /* IF NOT AVAIL b-integra-mft-wms THEN DO: */
                            ELSE
                                ASSIGN c-cod-integra = STRING(tt-item.cdd-embarque).

                            RUN pi-ttWMS.
                        END. /* IF int-transporte.separa-uf = NO THEN DO: */
                    END. /* IF AVAIL int-transporte THEN DO: */
                    ELSE DO:

                        ASSIGN c-cod-integra  = ''.

                        FIND LAST b-integra-mft-wms
                            WHERE b-integra-mft-wms.cod-integra = string(tt-item.cdd-embarque) NO-LOCK NO-ERROR.

                        IF NOT AVAIL b-integra-mft-wms THEN DO:

                            CREATE integra-mft-wms.
                            ASSIGN integra-mft-wms.usuario-integra  = c-seg-usuario
                                   integra-mft-wms.hora-integra     = STRING(TIME,'hh:mm')
                                   integra-mft-wms.dt-integra       = TODAY
                                   integra-mft-wms.seq-integra      = 1
                                   integra-mft-wms.cod-integra      = string(tt-item.cdd-embarque)
                                   c-cod-integra                    = integra-mft-wms.cod-integra.
                        END. /* IF NOT AVAIL b-integra-mft-wms THEN DO: */
                        ELSE
                            ASSIGN c-cod-integra = string(tt-item.cdd-embarque).

                        RUN pi-ttWMS.
                    END. /* IF NOT AVAIL int-transporte THEN DO: */
                END. /* IF AVAIL transporte THEN DO: */
            END. /* IF tt-param.tipo-volume = 2 THEN DO: */
            ELSE DO:

                ASSIGN c-cod-integra  = ''.

                FIND LAST b-integra-mft-wms
                    WHERE b-integra-mft-wms.cod-integra = STRING(STRING(tt-item.cdd-embarque) + '-FRAC') NO-LOCK NO-ERROR.

                IF NOT AVAIL b-integra-mft-wms THEN DO:

                    CREATE integra-mft-wms.
                    ASSIGN integra-mft-wms.usuario-integra  = c-seg-usuario
                           integra-mft-wms.hora-integra     = STRING(TIME,'hh:mm')
                           integra-mft-wms.dt-integra       = TODAY
                           integra-mft-wms.seq-integra      = 1
                           integra-mft-wms.cod-integra      = string(string(tt-item.cdd-embarque) + '-FRAC')
                           c-cod-integra                    = integra-mft-wms.cod-integra.
                END. /* IF NOT AVAIL b-integra-mft-wms THEN DO: */
                ELSE
                    ASSIGN c-cod-integra = STRING(STRING(tt-item.cdd-embarque) + '-FRAC').

                RUN pi-ttWMS.
            END. /* IF tt-param.tipo-volume = 1 THEN DO: */
        END. /* IF AVAIL deposito THEN DO: */
        ELSE
            ASSIGN c-cod-integra = ''.

        IF (FIRST-OF(tt-item.cod-cli-dif) AND tt-item.cod-cli-dif  <> 0) OR
            (FIRST-OF(tt-item.nota-classif) AND tt-item.nota-classif <> "") THEN DO:

           PUT SKIP (1) 'Clientes diferenciados: '.

           FIND FIRST emitente
               WHERE emitente.cod-emitente = tt-item.cod-cli-dif NO-LOCK NO-ERROR.

           FIND FIRST cli-difer
               WHERE cli-difer.cod-emitente = tt-item.cod-cli-dif NO-LOCK NO-ERROR.

           PUT tt-item.cod-cli-dif " - " emitente.nome-abrev skip.
           PUT "Observaá∆o: ".

           RUN pi-print-editor(INPUT TRIM(tt-item.obs-cli-difer), INPUT 118).

           FOR EACH tt-editor:
               PUT tt-editor.conteudo FORMAT 'x(132)' AT 13 SKIP.
           END.

           PUT " " SKIP.
        END.

        FIND item-mat WHERE item-mat.it-codigo = tt-item.it-codigo NO-LOCK NO-ERROR.

        IF AVAIL item-mat THEN
           ASSIGN c-cod-ean13 = item-mat.cod-ean.
        ELSE
           ASSIGN c-cod-ean13 = "".


        IF tt-item.l-fracionado THEN DO:
            DISPLAY tt-item.it-codigo FORMAT "9999999"
                    STRING(tt-item.desc-item) FORMAT  'x(35)' COLUMN-LABEL "Descriá∆o"
                    tt-item.un
                    tt-item.qt-alocada
                    tt-item.deposito  + (IF tt-item.deposito = "b2c" THEN " E-commercer" ELSE "") @ tt-item.deposito FORMAT "x(15)"
                    tt-item.localizacao
                    tt-item.pedido
                    c-cod-ean13     FORMAT "x(13)"
                    tt-item.qt-item FORMAT ">>>9"    COLUMN-LABEL "Fator"
                WITH WIDTH 132 STREAM-IO DOWN WITH FRAME a.
                
        END.
        ELSE DO:
            DISPLAY tt-item.it-codigo FORMAT "9999999"
                    STRING(tt-item.desc-item) FORMAT  'x(35)' COLUMN-LABEL "Descriá∆o"
                    tt-item.un
                    tt-item.qt-alocada
                    tt-item.deposito  + (IF tt-item.deposito = "b2c" THEN " E-commercer" ELSE "") @ tt-item.deposito FORMAT "x(15)"
                    tt-item.localizacao
                    tt-item.pedido
                    c-cod-ean13     FORMAT "x(13)"
                    tt-item.qt-item FORMAT ">>>9"    COLUMN-LABEL "Fator"
                WITH WIDTH 132 STREAM-IO DOWN WITH FRAME b.
                
        END.

        IF (LAST-OF(tt-item.cod-cli-dif) AND tt-item.cod-cli-dif  <> 0)
        OR (LAST-OF(tt-item.nota-classif) AND tt-item.nota-classif <> "") THEN DO:

            PUT SKIP (1) 'Embarques: ' SKIP.

            ASSIGN cList = ''.

            FOR EACH ttEmbarques
                WHERE ttEmbarques.nome-transp = tt-item.nome-transp
                AND   ttEmbarques.cod-cli-dif = tt-item.cod-cli-dif
                NO-LOCK BREAK BY ttEmbarques.nr-embarque:

                IF FIRST-OF(ttEmbarques.nr-embarque) THEN
                    ASSIGN cList = cList + (IF cList <> '' THEN ', ' ELSE '') + STRING(ttEmbarques.nr-embarque).
            END.

            RUN pi-print-editor(INPUT cList, INPUT 132).

            FOR EACH tt-editor:
                PUT tt-editor.conteudo FORMAT 'x(132)' SKIP.
            END.

            PUT SKIP (1) 'Notas fiscais: ' SKIP.

            ASSIGN cList         = ""
                   vValTotalNota = 0
                   vQtTotalVol   = 0.

            FOR EACH ttNota-fiscal
                WHERE ttNota-fiscal.nome-transp = tt-item.nome-transp
                AND   ttNota-fiscal.cod-cli-dif = tt-item.cod-cli-dif
                NO-LOCK BREAK BY ttNota-fiscal.nr-nota-fis:

                IF tt-item.nota-classif = "" OR tt-item.nota-classif = ttNota-fiscal.nr-nota-fis THEN DO:

                    IF FIRST-OF(ttNota-fiscal.nr-nota-fis) THEN
                        ASSIGN cList = cList + (IF cList <> '' THEN ', ' ELSE '') + TRIM(ttNota-fiscal.nr-nota-fis).

                    ASSIGN vValTotalNota = vValTotalNota + ttNota-fiscal.vl-tot-nota
                           vqtTotalVol   = vqtTotalVol   + int(ttNota-fiscal.nr-volumes).
                END.
            END.

            RUN pi-print-editor(INPUT cList, INPUT 132).

            FOR EACH tt-editor:
                PUT tt-editor.conteudo FORMAT 'x(132)' SKIP.
            END.

            PUT FILL("-",130) FORMAT "X(132)".
        END.

        IF LAST-OF(tt-item.nome-transp) THEN DO:

            PUT SKIP (1) 'Total de Embarques da Transportadora: ' SKIP.    
            ASSIGN cListEmbarque = ''.

            FOR EACH ttEmbarques
                WHERE ttEmbarques.nome-transp = tt-item.nome-transp
                NO-LOCK BREAK BY ttEmbarques.nr-embarque:

                IF FIRST-OF(ttEmbarques.nr-embarque) THEN
                    ASSIGN cListEmbarque = cListEmbarque + (IF cListEmbarque <> '' THEN ', ' ELSE '') + STRING(ttEmbarques.nr-embarque).
            END.

            RUN pi-print-editor(INPUT cListEmbarque, INPUT 132).

            FOR EACH tt-editor:
                PUT tt-editor.conteudo FORMAT 'x(132)' SKIP.
            END.

            PUT SKIP (1) 'Total de Notas fiscais da Transportadora: ' SKIP.

            ASSIGN cListNF         = ""
                   vValTotalNota = 0
                   vQtTotalVol   = 0.

            FOR EACH ttNota-fiscal
                WHERE ttNota-fiscal.nome-transp = tt-item.nome-transp
                NO-LOCK BREAK BY ttNota-fiscal.nr-nota-fis:

                IF FIRST-OF(ttNota-fiscal.nr-nota-fis) THEN
                    ASSIGN cListNF = cListNF + (IF cListNF <> '' THEN ', ' ELSE '') + TRIM(ttNota-fiscal.nr-nota-fis).

                ASSIGN vValTotalNota = vValTotalNota + ttNota-fiscal.vl-tot-nota
                       vqtTotalVol   = vqtTotalVol   + int(ttNota-fiscal.nr-volumes).
            END.

            RUN pi-print-editor(INPUT cListNF, INPUT 132).

            FOR EACH tt-editor:
                PUT tt-editor.conteudo FORMAT 'x(132)' SKIP.
            END.
        END.

        IF LAST-OF(tt-item.nome-transp) THEN DO:

           ASSIGN cListNF = ""
                  vValTotalNota = 0
                  vqtTotalVol   = 0. 

           FOR EACH ttNota-fiscal
               WHERE ttNota-fiscal.separa-mg   = tt-item.separa-mg
               AND   ttNota-fiscal.nome-transp = tt-item.nome-transp
               NO-LOCK BREAK BY ttNota-fiscal.nr-nota-fis:

               ASSIGN cListNF       = (cListNF + (IF cListNF <> '' THEN ', ' ELSE '') + TRIM(ttNota-fiscal.nr-nota-fis))
                      vValTotalNota = vValTotalNota + ttNota-fiscal.vl-tot-nota
                      vqtTotalVol   = vqtTotalVol   + int(ttNota-fiscal.nr-volumes).
            END.
            PUT SKIP(2)
                "Valor Total Notas...: " vValTotalNota SKIP
                "Quant Total Volumes.: " vQtTotalVol   SKIP(2).
        END.
    END. /* For each tt-item */

    /*FOR EACH ttWm-docto:
        MESSAGE 'ttWm-docto.cod-estabel      ' ttWm-docto.cod-estabel      skip
                'ttWm-docto.num-docto        ' ttWm-docto.num-docto        skip
                'ttWm-docto.num-docto-origem ' ttWm-docto.num-docto-origem skip
                'ttWm-docto.dt-implan-docto  ' ttWm-docto.dt-implan-docto  skip
                'ttwm-docto.id-docto         ' ttwm-docto.id-docto         skip
                'ttWm-docto.ind-sit-docto    ' ttWm-docto.ind-sit-docto    skip
                'ttWm-docto.ind-tipo-trans   ' ttWm-docto.ind-tipo-trans   skip
                'ttWm-docto.ind-origem-docto ' ttWm-docto.ind-origem-docto skip
                'ttWm-docto.cod-depos        ' ttWm-docto.cod-depos        skip
                'ttWm-docto.alteracao        ' ttWm-docto.alteracao        skip
                'ttWm-docto.cdd-embarq       ' ttWm-docto.cdd-embarq       skip
                'ttWm-docto.nr-resumo        ' ttWm-docto.nr-resumo
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.*/

    
    /*FOR EACH ttWm-docto-itens:
        MESSAGE 'ttWm-docto-itens.cod-estabel      ' ttWm-docto-itens.cod-estabel     skip
                'ttWm-docto-itens.num-docto        ' ttWm-docto-itens.num-docto       skip
                'ttWm-docto-itens.cod-item         ' ttWm-docto-itens.cod-item        skip
                'ttWm-docto-itens.qtd-item         ' ttWm-docto-itens.qtd-item        skip
                'ttWm-docto-itens.num-seq-item     ' ttWm-docto-itens.num-seq-item    skip
                'ttWm-docto-itens.nr-pedcli        ' ttWm-docto-itens.nr-pedcli       skip
                'ttWm-docto-itens.nome-abrev       ' ttWm-docto-itens.nome-abrev      skip
                'ttWm-docto-itens.cdd-embarq       ' ttWm-docto-itens.cdd-embarq      skip
                'ttWm-docto-itens.nr-resumo        ' ttWm-docto-itens.nr-resumo       skip
                'ttWm-docto-itens.nr-pedido        ' ttWm-docto-itens.nr-pedido       skip
                'ttwm-docto-itens.id-docto         ' ttwm-docto-itens.id-docto        skip
                'ttWm-docto-itens.ind-sit-movto    ' ttWm-docto-itens.ind-sit-movto   skip
                'ttWm-docto-itens.dt-atualizacao   ' ttWm-docto-itens.dt-atualizacao  skip
                'ttWm-docto-itens.alteracao        ' ttWm-docto-itens.alteracao       skip
                'ttWm-docto-itens.gera-sugestao    ' ttWm-docto-itens.gera-sugestao   skip
                'ttWm-docto-itens.log-pedido-exp   ' ttWm-docto-itens.log-pedido-exp
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.*/

    EMPTY TEMP-TABLE RowErrors.

    FIND FIRST ttWm-docto       NO-LOCK NO-ERROR.
    FIND FIRST ttWm-docto-itens NO-LOCK NO-ERROR.

    IF AVAIL ttWm-docto AND AVAIL ttWm-docto-itens THEN
        RUN esp/wmp/eswmpapi001.p (INPUT-OUTPUT TABLE ttWm-docto,
                                   INPUT-OUTPUT TABLE ttWm-docto-itens,
                                   OUTPUT TABLE RowErrors).

    IF l-ativa-log  THEN
        PUT "Funcao" string(tt-param.tipo-funcao) FORMAT 'x(100)' SKIP.

    IF tt-param.tipo-funcao = 2 THEN
        UNDO IntegraWMS, LEAVE IntegraWMS.

    IF  CAN-FIND(FIRST RowErrors) THEN DO:
    IF l-ativa-log  THEN
        PUT "erro" string(tt-param.tipo-funcao) FORMAT 'x(100)' SKIP.
        FOR EACH rowErrors
            WHERE RowErrors.ErrorType <> "INTERNAL"
            AND RowErrors.ErrorSubType = "Error":U:
            PUT 'Erro WMS: ' + string(RowErrors.ErrorNumber) + ' ' + RowErrors.errorDescription   FORMAT 'x(200)' SKIP.
        END. /* FOR EACH rowErrors */

        PAGE.        
        UNDO IntegraWMS, LEAVE IntegraWMS.
    END. /* IF  CAN-FIND(FIRST RowErrors) THEN DO: */
    ELSE
        PAGE.
END. /*fim bloco transaá∆o*/
  
IF CAN-FIND(FIRST tt-pedido-astec) THEN
    PUT "Notas ASTEC:" SKIP
        "------------" SKIP
        "" SKIP.

FOR EACH tt-pedido-astec:
    disp tt-pedido-astec.nr-pedcli   
         tt-pedido-astec.nr-nota-fis 
         tt-pedido-astec.serie       
         tt-pedido-astec.nr-volumes  
         tt-pedido-astec.nome-transp
    WITH FRAME f-detalhe-astec.
    DOWN WITH FRAME f-detalhe-astec.
END.


Marca_Impres:
DO TRANSACTION:
  FOR EACH tt-pre-fatur NO-LOCK,
      FIRST pre-fatur EXCLUSIVE-LOCK
      WHERE pre-fatur.cdd-embarq  = tt-pre-fatur.nr-embarque
      AND   pre-fatur.nr-resumo   = tt-pre-fatur.nr-resumo
      AND   pre-fatur.nome-abrev  = tt-pre-fatur.nome-abrev
      AND   pre-fatur.nr-pedcli   = tt-pre-fatur.nr-pedcli
      ON ERROR UNDO Marca_Impres, LEAVE Marca_Impres:

      ASSIGN pre-fatur.pick-impresso = YES.
  END.

  FOR EACH ttNota-fiscal NO-LOCK USE-INDEX id-nota:
      FIND int-nota-fiscal
          WHERE int-nota-fiscal.cod-estab   = ttNota-fiscal.cod-estab
          AND   int-nota-fiscal.serie       = ttNota-fiscal.serie
          AND   int-nota-fiscal.nr-nota-fis = ttNota-fiscal.nr-nota-fis EXCLUSIVE-LOCK NO-ERROR.

      IF NOT AVAILABLE int-nota-fiscal THEN DO:

         CREATE int-nota-fiscal.
         ASSIGN int-nota-fiscal.cod-estab   = ttNota-fiscal.cod-estab
                int-nota-fiscal.serie       = ttNota-fiscal.serie
                int-nota-fiscal.nr-nota-fis = ttNota-fiscal.nr-nota-fis.
      END.

      ASSIGN int-nota-fiscal.log-impr-separacao = YES.
  END.
END.

PROCEDURE piMostraEstados:
    DEFINE INPUT PARAMETER p-nome-transp LIKE nota-fiscal.nome-transp.

    FOR EACH tt-estado:

        FOR EACH bf-item
            WHERE bf-item.nome-transp = p-nome-transp
            AND   bf-item.estado      = tt-estado.estado
            AND   bf-item.cod-cli-dif = 0 NO-LOCK BREAK BY bf-item.nome-transp
            WITH STREAM-IO WIDTH 132:

            IF FIRST-OF(bf-item.nome-transp) THEN DO:

               DISPLAY bf-item.nome-transp @ tt-item.nome-transp
                       WITH FRAME f-nome-transp.

               FIND FIRST unid-feder
                   WHERE unid-feder.estado = bf-item.estado NO-LOCK NO-ERROR.


               DISPLAY bf-item.estado @ tt-item.estado
                       unid-feder.no-estado 
                       WITH FRAME f-estado.
            END.

            DISPLAY bf-item.it-codigo
                    STRING(bf-item.desc-item) FORMAT  'x(42)' COLUMN-LABEL "Descriá∆o"
                    bf-item.un
                    bf-item.qt-alocada
                    bf-item.deposito + (IF tt-item.deposito = "b2c" THEN " E-commercer" ELSE "") @ tt-item.deposito FORMAT "x(15)"
                    bf-item.localizacao
                    bf-item.pedido
                    WITH WIDTH 132 STREAM-IO.
        END.

        PUT SKIP (1) 'Clientes diferenciados: ' SKIP.

        FOR EACH bf-item
            WHERE bf-item.nome-transp = p-nome-transp
            AND   bf-item.estado      = tt-estado.estado
            AND   bf-item.cod-cli-dif <> 0 NO-LOCK BREAK BY bf-item.nome-transp
            WITH STREAM-IO WIDTH 132:

            IF FIRST-OF(bf-item.nome-transp) THEN DO:

               DISPLAY bf-item.nome-transp @ tt-item.nome-transp
                       WITH FRAME f-nome-transp.

               FIND FIRST unid-feder
                   WHERE unid-feder.estado = bf-item.estado NO-LOCK NO-ERROR.

               DISPLAY bf-item.estado @ tt-item.estado
                       unid-feder.no-estado 
                       WITH FRAME f-estado.
            END.

            DISPLAY bf-item.it-codigo
                STRING(bf-item.desc-item) FORMAT  'x(42)' COLUMN-LABEL "Descriá∆o"
                bf-item.un
                bf-item.qt-alocada
                bf-item.deposito + (IF tt-item.deposito = "b2c" THEN " E-commercer" ELSE "") @ tt-item.deposito format "x(15)"
                bf-item.localizacao
                bf-item.pedido
                WITH WIDTH 132 STREAM-IO.
        END.

        FOR EACH bf-item
            WHERE bf-item.nome-transp = p-nome-transp
            AND   bf-item.estado      = tt-estado.estado
            NO-LOCK BREAK BY bf-item.nome-transp WITH STREAM-IO WIDTH 132:

            IF LAST-OF(bf-item.nome-transp) THEN DO:

               PUT SKIP (1) 'Embarques: ' SKIP.

               ASSIGN cList = ''.

               FOR EACH ttEmbarques
                   WHERE ttEmbarques.nome-transp = bf-item.nome-transp
                   AND   ttEmbarques.estado      = bf-item.estado NO-LOCK:

                   ASSIGN cList = cList + (IF cList <> '' THEN ', ' ELSE '') + STRING(ttEmbarques.nr-embarque).
               END.

               RUN pi-print-editor(INPUT cList, INPUT 132).

               FOR EACH tt-editor:
                   PUT tt-editor.conteudo FORMAT 'x(132)' SKIP.
               END.

               PUT SKIP (1) 'Notas fiscais: ' SKIP.

               ASSIGN cList         = ""
                      vValTotalNota = 0
                      vQtTotalVol   = 0.

               FOR EACH ttNota-fiscal
                   WHERE ttNota-fiscal.nome-transp = bf-item.nome-transp
                   AND   ttNota-fiscal.estado      = bf-item.estado NO-LOCK:

                   ASSIGN cList         = (cList + (IF cList <> '' THEN ', ' ELSE '') + TRIM(ttNota-fiscal.nr-nota-fis))
                          vValTotalNota = vValTotalNota + ttNota-fiscal.vl-tot-nota
                          vqtTotalVol   = vqtTotalVol   + int(ttNota-fiscal.nr-volumes).
               END.

               RUN pi-print-editor(INPUT cList, INPUT 132).

               FOR EACH tt-editor:
                   PUT tt-editor.conteudo FORMAT 'x(132)' SKIP.
               END.

               PUT SKIP(2)
                   "Valor Total Notas...: " vValTotalNota SKIP
                   "Quant Total Volumes.: " vQtTotalVol   SKIP(2).

               PAGE. 
            END.
        END.
    END.
END PROCEDURE.

RUN pi-finalizar in h-acomp.

{include/i-rpclo.i}

RETURN "OK".

/*-----------------------  Internal Procedures  -----------------------*/
{include/pi-edit.i}

PROCEDURE defineAstec:

   ASSIGN l-retorno-astec = NO.

   IF AVAIL ped-venda AND AVAIL tt-notaOrigem AND tt-notaOrigem.nome-transp <> "Sedex"
       AND (ped-venda.tp-pedido = "99" OR ped-venda.tp-pedido = "9" OR ped-venda.tp-pedido = "94") THEN DO:

       FIND tt-pedido-astec
           WHERE tt-pedido-astec.nr-pedcli   = ped-venda.nr-pedcli
           AND   tt-pedido-astec.nr-nota-fis = tt-notaOrigem.nr-nota-fis
           NO-LOCK NO-ERROR.

       IF NOT AVAIL tt-pedido-astec THEN DO:

           CREATE tt-pedido-astec.
           ASSIGN tt-pedido-astec.nr-pedcli   = ped-venda.nr-pedcli
                  tt-pedido-astec.nr-nota-fis = tt-notaOrigem.nr-nota-fis
                  tt-pedido-astec.serie       = tt-notaOrigem.serie
                  tt-pedido-astec.nr-volumes  = tt-notaOrigem.nr-volumes
                  tt-pedido-astec.nome-transp = tt-notaOrigem.NOme-transp.
       END.

       ASSIGN l-retorno-astec = YES.
   END.
END PROCEDURE.

PROCEDURE pi-ttWMS:

    IF l-ativa-log  THEN
        PUT "INTEGRACAO MFT X WMS - passagem parametros c-cod-integra2 " + c-cod-integra FORMAT 'x(200)' SKIP.

    IF c-cod-integra <> '' THEN DO:

        IF l-ativa-log  THEN
            PUT "INTEGRACAO MFT X WMS - DENTRO c-cod-integra" FORMAT 'x(200)'  SKIP.

        FIND FIRST item-uni-estab
            WHERE item-uni-estab.it-codigo   = tt-item.it-codigo
            AND   item-uni-estab.cod-estabel = tt-item.cod-estabel
            AND   item-uni-estab.nr-linha    = 20 NO-LOCK NO-ERROR.

        IF AVAIL item-uni-estab THEN
            NEXT.

        FIND FIRST item WHERE item.it-codigo = tt-item.it-codigo NO-LOCK NO-ERROR.

        IF AVAIL item AND item.tipo-contr = 4 THEN
            NEXT.

        FIND FIRST integra-mft-wms-notas
            WHERE integra-mft-wms-notas.cod-integra = c-cod-integra 
            AND   integra-mft-wms-notas.cdd-embarq  = tt-item.cdd-embarque
            AND   integra-mft-wms-notas.cod-estabel = tt-item.cod-estabel
            AND   integra-mft-wms-notas.serie       = tt-item.serie      
            AND   integra-mft-wms-notas.nr-nota-fis = tt-item.nr-nota-fis
            AND   integra-mft-wms-notas.nr-resumo   = tt-item.nr-resumo  
            AND   integra-mft-wms-notas.nome-abrev  = tt-item.nome-abrev 
            AND   integra-mft-wms-notas.nr-pedcli   = tt-item.nr-pedcli  
            AND   integra-mft-wms-notas.nr-embarque = tt-item.nr-embarque
            AND   integra-mft-wms-notas.nr-seq-fat  = i-seqWmDoctoIt
            AND   integra-mft-wms-notas.it-codigo   = tt-item.it-codigo  NO-LOCK NO-ERROR.

        IF NOT AVAIL integra-mft-wms-notas THEN DO:

            IF l-ativa-log  THEN
                PUT "INTEGRACAO MFT X WMS - criando ttables" FORMAT 'x(200)'  SKIP.


            CREATE integra-mft-wms-notas.
            ASSIGN integra-mft-wms-notas.cod-integra  = c-cod-integra 
                   integra-mft-wms-notas.cdd-embarq   = tt-item.cdd-embarque
                   integra-mft-wms-notas.cod-estabel  = tt-item.cod-estabel
                   integra-mft-wms-notas.serie        = tt-item.serie      
                   integra-mft-wms-notas.nr-nota-fis  = tt-item.nr-nota-fis
                   integra-mft-wms-notas.nr-resumo    = tt-item.nr-resumo  
                   integra-mft-wms-notas.nome-abrev   = tt-item.nome-abrev 
                   integra-mft-wms-notas.nr-pedcli    = tt-item.nr-pedcli  
                   integra-mft-wms-notas.nr-embarque  = tt-item.nr-embarque
                   integra-mft-wms-notas.nr-seq-fat   = i-seqWmDoctoIt
                   integra-mft-wms-notas.it-codigo    = tt-item.it-codigo  
                   integra-mft-wms-notas.l-fracionado = IF tt-item.qt-item <> 0 AND tt-item.qt-alocada MODULO tt-item.qt-item <> 0 THEN YES ELSE IF tt-item.qt-item = 0 THEN YES ELSE NO.
                   integra-mft-wms-notas.qtd-integra  = tt-item.qt-alocada.


            /* Controle das notas atualizadas no estoque porem pendentes de atualizacao com o WMS */
            FOR EACH int-wms-nf-atualiz EXCLUSIVE-LOCK
                WHERE int-wms-nf-atualiz.cod-estabel = tt-item.cod-estabel
                  and int-wms-nf-atualiz.serie       = tt-item.serie      
                  and int-wms-nf-atualiz.nr-nota-fis = tt-item.nr-nota-fis:
                  DELETE int-wms-nf-atualiz.
            END.

            FIND FIRST ttWm-docto
              WHERE ttWm-docto.cod-estabel       = tt-item.cod-estabel  
              AND   ttWm-docto.num-docto         = c-cod-integra
              AND   ttWm-docto.num-docto-origem  = c-cod-integra + "|" + tt-item.nome-transp
              AND   ttWm-docto.dt-implan-docto   = TODAY NO-LOCK NO-ERROR.

            IF NOT AVAIL ttWm-docto THEN DO:

                CREATE ttWm-docto.
                ASSIGN ttWm-docto.cod-estabel       = tt-item.cod-estabel
                       ttWm-docto.num-docto         = c-cod-integra
                       ttWm-docto.num-docto-origem  = c-cod-integra + "|" + tt-item.nome-transp
                       ttWm-docto.dt-implan-docto   = TODAY
                       ttwm-docto.id-docto          = 0   
                       ttWm-docto.ind-sit-docto     = 1   
                       ttWm-docto.ind-tipo-trans    = 2   
                       ttWm-docto.ind-origem-docto  = 5   
                       ttWm-docto.cod-depos         = tt-item.deposito
                       ttWm-docto.alteracao         = NO
                       ttWm-docto.cdd-embarq        = 0
                       ttWm-docto.nr-resumo         = 0.
            END. /* IF NOT AVAIL ttWm-docto THEN DO: */

            FIND FIRST ttWm-docto-itens
                WHERE ttWm-docto-itens.cod-estabel = tt-item.cod-estabel
                AND   ttWm-docto-itens.num-docto   = c-cod-integra      
                AND   ttWm-docto-itens.cod-item    = tt-item.it-codigo  NO-LOCK NO-ERROR.

            IF AVAIL ttWm-docto-itens THEN
                ASSIGN ttWm-docto-itens.qtd-item       = ttWm-docto-itens.qtd-item + tt-item.qt-alocada.
            ELSE DO:

                CREATE ttWm-docto-itens.
                ASSIGN ttWm-docto-itens.cod-estabel     = tt-item.cod-estabel
                       ttWm-docto-itens.num-docto       = c-cod-integra
                       ttWm-docto-itens.cod-item        = tt-item.it-codigo
                       ttWm-docto-itens.qtd-item        = tt-item.qt-alocada
                       ttWm-docto-itens.num-seq-item    = i-seqWmDoctoIt
                       ttWm-docto-itens.nr-pedcli       = tt-item.nr-pedcli
                       ttWm-docto-itens.nome-abrev      = tt-item.nome-abrev
                       ttWm-docto-itens.cdd-embarq      = 0
                       ttWm-docto-itens.nr-resumo       = tt-item.nr-resumo
                       ttWm-docto-itens.nr-pedido       = 0 
                       ttwm-docto-itens.id-docto        = 0 
                       ttWm-docto-itens.ind-sit-movto   = 1 
                       ttWm-docto-itens.dt-atualizacao  = TODAY
                       ttWm-docto-itens.alteracao       = NO
                       ttWm-docto-itens.gera-sugestao   = YES
                       ttWm-docto-itens.log-pedido-exp  = IF tt-item.qt-item <> 0 AND tt-item.qt-alocada MODULO tt-item.qt-item <> 0 THEN YES ELSE NO
                       i-seqWmDoctoIt                   = i-seqWmDoctoIt + 10.
            END. /* IF NOT AVAIL ttWm-docto-itens THEN */
        END. /* IF NOT AVAIL integra-mft-wms-notas THEN DO: */
        ELSE 
            PUT 'ERRO WMS: Embarque ' + STRING(tt-item.cdd-embarque) + ' j† integrado ao WMS!' FORMAT 'x(200)' SKIP.

    END. /* IF c-cod-integra <> 0 THEN DO: */
    /* INTEGRACAO MFT X WMS INTEGRACAO MFT X WMS INTEGRACAO MFT X WMS INTEGRACAO MFT X WMS INTEGRACAO MFT X WMS */
END PROCEDURE.

PROCEDURE piCentral:
    DEFINE INPUT PARAMETER c-refer      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER c-depos      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER c-localiz    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER c-serie      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER d-qt-aloc    AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAMETER d-nrembarque AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAMETER c-estabel    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER c-item       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER c-pedcli     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER d-ccdembarq  AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAMETER nr-seq-fat   AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER i-resumo     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER c-nome-abrev AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-fracionado AS LOGICAL   NO-UNDO.

    FOR FIRST item-uni-estab
        WHERE  item-uni-estab.it-codigo   = c-item
        AND    item-uni-estab.cod-estabel = c-estabel
        AND    item-uni-estab.nr-linha    = 20 NO-LOCK:

        FOR EACH estrutura
            WHERE estrutura.it-codigo     = c-item
            AND   estrutura.data-inicio  <= TODAY
            AND   estrutura.data-termino >= TODAY NO-LOCK:

            IF l-ativa-log  THEN
                PUT "10-5a - " c-refer " - " c-depos " - " c-localiz " - " c-serie " - "  d-qt-aloc " - " c-item " - " c-transp " - " x-cli-difer SKIP.

            FIND FIRST tt-item
                WHERE tt-item.nome-transp  = (IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp)
                AND   tt-item.estado       = tt-notaOrigem.estado
                AND   tt-item.it-codigo    = estrutura.es-codigo
                AND   tt-item.cod-refer    = c-refer
                AND   INDEX(c-depos,tt-item.deposito) <> 0
                AND   tt-item.cod-cli-dif  = x-cli-difer
                AND   tt-item.nr-nota-fis  = tt-notaOrigem.nr-nota-fis
                AND   tt-item.l-fracionado = p-fracionado NO-ERROR.

            IF NOT AVAIL tt-item THEN DO:
                IF l-ativa-log THEN
                    PUT 'cria tt-item3' SKIP.

                CREATE tt-item.
                ASSIGN tt-item.nome-transp   = IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp
                       tt-item.estado        = tt-notaOrigem.estado 
                       tt-item.it-codigo     = estrutura.es-codigo
                       tt-item.cod-refer     = c-refer
                       tt-item.deposito      = c-depos
                       tt-item.pedido        = c-pedcli
                       tt-item.localizacao   = IF c-localiz <> "" THEN SUBSTRING(c-localiz,1,10) ELSE ""
                       tt-item.qt-alocada    = d-qt-aloc * estrutura.quant-usada
                       tt-item.cod-cli-dif   = x-cli-difer
                       tt-item.cdd-embarque  = d-ccdembarq  
                       tt-item.nr-resumo     = i-resumo
                       tt-item.nome-abrev    = c-nome-abrev
                       tt-item.nr-pedcli     = c-pedcli
                       tt-item.nr-embarque   = d-nrembarque
                       tt-item.cod-estabel   = c-estabel
                       tt-item.serie         = c-serie
                       tt-item.nr-nota-fis   = tt-notaOrigem.nr-nota-fis
                       tt-item.nr-seq-fat    = nr-seq-fat
                       tt-item.nota-classif  = IF can-find(FIRST filial-cliente WHERE filial-cliente.cnpj = nota-fiscal.cgc) THEN c-nr-nota-fis ELSE ""
                       tt-item.qt-item       = IF AVAIL item-caixa THEN item-caixa.qt-item ELSE 0
                       tt-item.obs-cli-difer = c-obs-cli-difer.

                FOR FIRST item
                    WHERE item.it-codigo = tt-item.it-codigo NO-LOCK:

                    ASSIGN tt-item.desc-item = ITEM.desc-item
                           tt-item.un        = ITEM.un.
                END.

                /* Sequància do Item na impress∆o */
                FOR FIRST seq-item
                    WHERE  seq-item.it-codigo = tt-item.it-codigo NO-LOCK:

                    ASSIGN tt-item.sequencia = IF AVAIL seq-item THEN seq-item.sequencia ELSE 999999.
                END.
            END.
            ELSE
                ASSIGN tt-item.qt-alocada = tt-item.qt-alocada + (d-qt-aloc * estrutura.quant-usada).

            ASSIGN tt-item.l-fracionado = IF  tt-item.qt-item <> 0 THEN tt-item.qt-alocada MODULO tt-item.qt-item <> 0  ELSE IF tt-item.qt-item = 0 THEN YES ELSE NO.
        END. /* estrutura */
    END. /* item-uni-estab */
END PROCEDURE.



PROCEDURE pi-busca-nota-pelo-nr-pedido-do-item:

    FIND FIRST ped-ent NO-LOCK
        WHERE ped-ent.nome-abrev   = it-pre-fat.nome-abrev
          AND ped-ent.nr-pedcli    = it-pre-fat.nr-pedcli
          AND ped-ent.nr-sequencia = it-pre-fat.nr-sequencia
          AND ped-ent.it-codigo    = it-pre-fat.it-codigo
          AND ped-ent.cod-refer    = it-pre-fat.cod-refer
          AND ped-ent.nr-entrega   = it-pre-fat.nr-entrega  NO-ERROR.

    IF  AVAIL ped-ent THEN DO:
        FIND FIRST it-nota-fisc NO-LOCK
            WHERE it-nota-fisc.nome-ab-cli = ped-ent.nome-abrev
              AND it-nota-fisc.nr-pedcli   = ped-ent.nr-pedcli
              AND it-nota-fisc.nr-seq-ped  = ped-ent.nr-sequencia
              AND it-nota-fisc.it-codigo   = ped-ent.it-codigo
              AND it-nota-fisc.cod-refer   = ped-ent.cod-refer NO-ERROR.

        FIND nota-fiscal NO-LOCK OF it-nota-fisc
            WHERE nota-fiscal.cdd-embarq = it-pre-fat.cdd-embarq NO-ERROR.

        IF  AVAIL nota-fiscal THEN
            ASSIGN c-transp = nota-fiscal.nome-transp.
    END.

    RETURN "OK".
End.

PROCEDURE pi-gera-tt-item:

    DEF INPUT PARAM p-fracionado AS LOG NO-UNDO.

    FOR EACH  pre-fatur NO-LOCK     
        WHERE pre-fatur.cdd-embarq = tt-param.nr-embarque,
        EACH it-pre-fat NO-LOCK OF pre-fatur:
    
        IF l-ativa-log  THEN
           PUT "1 " pre-fatur.cdd-embarq  SKIP
                    pre-fatur.nr-resumo   SKIP
                    pre-fatur.nome-abrev  SKIP
                    pre-fatur.nr-pedcli   SKIP
                    tt-param.cod-estabel  SKIP.
    
        ASSIGN c-transp             = ""
               tt-param.cod-estabel =  pre-fatur.cod-estabel.
    
        /*validaá∆o da transportadora passa a ser da NF pois ela j† esta gerada e pode ser alterada na nota*/
        FOR FIRST nota-fiscal
            WHERE nota-fiscal.cdd-embarq     = pre-fatur.cdd-embarq
            AND   nota-fiscal.nr-resumo      = pre-fatur.nr-resumo
            AND   nota-fiscal.nome-ab-cli    = pre-fatur.nome-abrev
            //AND   nota-fiscal.nr-pedcli      = pre-fatur.nr-pedcli
            AND   nota-fiscal.cod-estabel    = tt-param.cod-estabel
            AND   nota-fiscal.dt-cancela     = ? NO-LOCK:
    
            ASSIGN c-transp = nota-fiscal.nome-transp.
    
            IF l-ativa-log  THEN
                PUT "1.5 " nota-fiscal.nr-nota-fis " - " nota-fiscal.nome-transp  SKIP.
        END. /* FOR FIRST nota-fiscal NO-LOCK */
        
        IF  NOT AVAIL nota-fiscal THEN
            RUN pi-busca-nota-pelo-nr-pedido-do-item.

        IF l-ativa-log  THEN DO:
            IF AVAIL nota-fiscal THEN
                PUT "2 " nota-fiscal.nat-operacao " " nota-fiscal.nr-nota-fis  SKIP.
        END.
    
        FIND natur-oper WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-LOCK NO-ERROR.
    
        IF AVAIL natur-oper AND natur-oper.log-oper-triang THEN DO:
            FOR FIRST b-nota-fiscal
                WHERE b-nota-fiscal.cdd-embarq     = pre-fatur.cdd-embarq
                AND   b-nota-fiscal.nr-resumo      = pre-fatur.nr-resumo
                AND   b-nota-fiscal.nome-ab-cli    = nota-fiscal.nome-ab-cli
                AND   b-nota-fiscal.nr-pedcli     = ""
                AND   b-nota-fiscal.cod-estabel    = tt-param.cod-estabel
                AND   b-nota-fiscal.dt-cancela     = ? NO-LOCK:
    
                ASSIGN c-transp = b-nota-fiscal.nome-transp.
            END. /* FOR FIRST b-nota-fiscal NO-LOCK */
        END. /* IF AVAIL natur-oper AND natur-oper.log-oper-triang THEN DO: */
    
        IF AVAIL b-nota-fiscal THEN DO:
    
            IF l-ativa-log  THEN
                PUT "3 - Existe b-nota-fiscal" SKIP.
    
            FIND FIRST tt-notaOrigem
                WHERE tt-notaOrigem.cod-estabel  = b-nota-fiscal.cod-estabel 
                AND   tt-notaOrigem.serie        = b-nota-fiscal.serie       
                AND   tt-notaOrigem.nr-nota-fis  = b-nota-fiscal.nr-nota-fis  NO-LOCK NO-ERROR.
            
            IF NOT AVAIL tt-notaOrigem THEN DO:
    
                CREATE tt-notaOrigem.
                ASSIGN tt-notaOrigem.nome-transp  = b-nota-fiscal.nome-transp 
                       tt-notaOrigem.nat-operacao = b-nota-fiscal.nat-operacao
                       tt-notaOrigem.cod-emitente = b-nota-fiscal.cod-emitente
                       tt-notaOrigem.estado       = b-nota-fiscal.estado     
                       tt-notaOrigem.cod-estabel  = b-nota-fiscal.cod-estabel
                       tt-notaOrigem.serie        = b-nota-fiscal.serie      
                       tt-notaOrigem.nr-nota-fis  = b-nota-fiscal.nr-nota-fis
                       tt-notaOrigem.vl-tot-nota  = b-nota-fiscal.vl-tot-nota
                       tt-notaOrigem.nr-volumes   = b-nota-fiscal.nr-volumes 
                       tt-notaOrigem.nome-abrev   = b-nota-fiscal.nome-ab-cli.
            END. /*  IF NOT AVAIL tt-notaOrigem THEN DO: */
    
        END. /* IF AVAIL b-nota-fiscal THEN DO: */
        ELSE DO:
    
            IF l-ativa-log  THEN
                PUT "3 - N∆o Existe b-nota-fiscal" SKIP.
    
            IF AVAIL nota-fiscal THEN DO:
    
                IF l-ativa-log THEN
                    PUT nota-fiscal.idi-sit-nf-eletro.
                IF l-ativa-log THEN
                    PUT AVAIL nota-fiscal.
                /*
                IF nota-fiscal.idi-sit-nf-eletro <> 3 THEN DO:
    
                    IF l-ativa-log THEN
                        PUT "entrou".
    
                    ASSIGN c-mensagem = "Nota n∆o autorizada! Estab: " + nota-fiscal.cod-estabel + " Serie: " + nota-fiscal.serie + " Nota: " + nota-fiscal.nr-nota-fis + ".".
                    PUT c-mensagem FORMAT 'x(256)' SKIP.
                    NEXT.
                END.
    
                IF nota-fiscal.dt-confirma = ? THEN DO:
    
                    IF l-ativa-log THEN
                        PUT "entrou".
    
                    ASSIGN c-mensagem = "Nota n∆o atualizada no estoque! Estab: " + nota-fiscal.cod-estabel + " Serie: " + nota-fiscal.serie + " Nota: " + nota-fiscal.nr-nota-fis + ".".
                    PUT c-mensagem FORMAT 'x(256)' SKIP.
                    NEXT.
                END.

                FOR FIRST devol-cli
                    WHERE  devol-cli.cod-estabel  = nota-fiscal.cod-estabel
                    AND    devol-cli.serie        = nota-fiscal.serie
                    AND    devol-cli.nr-nota-fis  = nota-fiscal.nr-nota-fis
                    AND    devol-cli.nr-sequencia = it-pre-fat.nr-sequencia
                    AND    devol-cli.it-codigo    = it-pre-fat.it-codigo NO-LOCK: END.
    
                IF AVAIL devol-cli THEN DO:
                    ASSIGN c-mensagem = "Nota devolvida! Estab: " + nota-fiscal.cod-estabel + " Serie: " + nota-fiscal.serie + " Nota: " + nota-fiscal.nr-nota-fis + " Item: " + it-pre-fat.it-codigo +  ".".
                    PUT c-mensagem FORMAT 'X(256)' SKIP.
                    NEXT.
                END.
                */
    
                FIND FIRST tt-notaOrigem
                    WHERE tt-notaOrigem.cod-estabel  = nota-fiscal.cod-estabel 
                    AND   tt-notaOrigem.serie        = nota-fiscal.serie       
                    AND   tt-notaOrigem.nr-nota-fis  = nota-fiscal.nr-nota-fis  NO-LOCK NO-ERROR.
    
                IF NOT AVAIL tt-notaOrigem THEN DO: 
    
                    CREATE tt-notaOrigem.
                    ASSIGN tt-notaOrigem.nome-transp  = nota-fiscal.nome-transp 
                           tt-notaOrigem.nat-operacao = nota-fiscal.nat-operacao
                           tt-notaOrigem.cod-emitente = nota-fiscal.cod-emitente
                           tt-notaOrigem.estado       = nota-fiscal.estado     
                           tt-notaOrigem.cod-estabel  = nota-fiscal.cod-estabel
                           tt-notaOrigem.serie        = nota-fiscal.serie      
                           tt-notaOrigem.nr-nota-fis  = nota-fiscal.nr-nota-fis
                           tt-notaOrigem.vl-tot-nota  = nota-fiscal.vl-tot-nota
                           tt-notaOrigem.nr-volumes   = nota-fiscal.nr-volumes 
                           tt-notaOrigem.nome-abrev   = nota-fiscal.nome-ab-cli.
                END. /*  IF NOT AVAIL tt-notaOrigem THEN DO: */
            END. /* IF AVAIL nota-fiscal THEN DO: */
            ELSE
                NEXT.
        END. /* IF NOT AVAIL b-nota-fiscal THEN DO: */
    
        IF l-ativa-log  THEN
            PUT "4" SKIP.
    
        FIND CURRENT tt-notaOrigem NO-LOCK NO-ERROR.
   
        IF AVAIL tt-notaOrigem THEN DO:
    
            IF l-ativa-log  THEN
               PUT "5" SKIP.
    
            FOR FIRST ped-venda NO-LOCK
                WHERE ped-venda.nr-pedcli  = pre-fatur.nr-pedcli
                AND   ped-venda.nome-abrev = pre-fatur.nome-abrev:
            END. /* FOR FIRST ped-venda NO-LOCK */
    
            IF l-ativa-log  THEN
               PUT "5a" SKIP.
    
            IF  NOT AVAIL tt-notaOrigem AND NOT AVAIL ped-venda THEN
                NEXT.
    
            IF l-ativa-log  THEN
               PUT "5b" SKIP.
    
            IF  AVAIL tt-notaOrigem THEN DO:
    
                FOR FIRST natur-oper
                    WHERE natur-oper.nat-operacao = tt-notaOrigem.nat-operacao NO-LOCK:
                END.
    
                {esinc/es0004.i} /*ValidaNaturezasImpress∆oNFs*/
            END. /* IF  AVAIL tt-notaOrigem THEN DO: */
            ELSE DO:
                FOR FIRST natur-oper
                    WHERE natur-oper.nat-operacao = ped-venda.nat-operacao NO-LOCK:
                END.
    
                {esinc/es0004a.i} /*ValidaNaturezasImpress∆oNFs*/
            END. /* IF NOT AVAIL tt-notaOrigem THEN DO: */
    
            IF l-ativa-log  THEN
                PUT "6" SKIP.   
    
            RUN defineAstec.
    
            IF l-ativa-log  THEN
                PUT "6a" SKIP.   
    
            /********* Achar Cliente diferenciado *************/ 
            ASSIGN x-cli-difer      = 0
                   c-nr-nota-fis    = ""
                   c-obs-cli-difer  = ""
                   c-serie          = "".
    
            FOR EACH cli-difer
                WHERE cli-difer.cod-emitente = tt-notaOrigem.cod-emitente NO-LOCK:
    
                IF x-cli-difer = 0 AND CAN-FIND(FIRST tt-prog-ponto-tmp
                                                WHERE tt-prog-ponto-tmp.conteudo = cli-difer.cc-codigo
                                                AND tt-prog-ponto-tmp.ponto    = 1) THEN DO:
    
                    ASSIGN x-cli-difer     = cli-difer.cod-emitente
                           c-nr-nota-fis   = tt-notaOrigem.nr-nota-fis 
                           c-serie         = tt-notaOrigem.serie       
                           c-obs-cli-difer = cli-difer.descricao.
                END.
            END.
    
            IF l-ativa-log  THEN
                PUT "7" SKIP.   
      
            ASSIGN l-it-dep-fat = NO.
    
            FOR EACH it-dep-fat
                WHERE it-dep-fat.cdd-embarq   = it-pre-fat.cdd-embarq
                AND   it-dep-fat.nr-resumo    = it-pre-fat.nr-resumo
                AND   it-dep-fat.nome-abrev   = it-pre-fat.nome-abrev
                AND   it-dep-fat.nr-pedcli    = it-pre-fat.nr-pedcli
                AND   it-dep-fat.nr-sequencia = it-pre-fat.nr-sequencia
                AND   it-dep-fat.nr-entrega   = it-pre-fat.nr-entrega
                AND   it-dep-fat.it-codigo    = it-pre-fat.it-codigo
                NO-LOCK USE-INDEX ch-deposito:
    
                IF l-ativa-log  THEN
                    PUT "8" SKIP.   
    
                IF pre-fatur.nat-operacao BEGINS "7":U THEN DO:
    
                    IF l-ativa-log  THEN
                        PUT "8a" SKIP.   
    
                    FIND FIRST emitente
                        WHERE emitente.nome-abrev = pre-fatur.nome-abrev NO-LOCK NO-ERROR.
    
                    IF AVAILABLE emitente THEN DO:
    
                        FIND FIRST int-emitente
                            WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    
                        IF AVAILABLE int-emitente AND int-emitente.tipo-embalagem <> "":U THEN DO:
    
                            FIND FIRST embalag
                                WHERE embalag.embalagem = int-emitente.tipo-embalagem NO-LOCK NO-ERROR.
    
                            IF AVAILABLE embalag THEN
    
                                FIND FIRST item-caixa
                                    WHERE item-caixa.it-codigo  = it-dep-fat.it-codigo
                                    AND   item-caixa.fm-codigo  = ?
                                    AND   item-caixa.fm-cod-com = ?
                                    AND   item-caixa.sigla-emb BEGINS embalag.sigla-emb NO-LOCK NO-ERROR.
                        END. /* IF AVAILABLE int-emitente AND int-emitente.tipo-embalagem <> "":U THEN DO: */
                        ELSE DO:
    
                            FIND FIRST item-caixa
                                WHERE item-caixa.it-codigo  = it-dep-fat.it-codigo
                                AND   item-caixa.fm-codigo  = ?
                                AND   item-caixa.fm-cod-com = ?
                                AND   item-caixa.sigla-emb BEGINS "E":U NO-LOCK NO-ERROR.
    
                            FIND FIRST embalag
                                WHERE embalag.sigla-emb = item-caixa.sigla-emb NO-LOCK NO-ERROR.
    
                            IF NOT AVAILABLE embalag THEN DO:
    
                                FOR EACH embalag
                                    WHERE embalag.embalagem BEGINS "EMB":U
                                    AND   embalag.emite-roman NO-LOCK BREAK BY embalag.volume:
    
                                    FIND FIRST item-caixa
                                        WHERE item-caixa.it-codigo  = it-dep-fat.it-codigo
                                        AND   item-caixa.fm-codigo  = ?
                                        AND   item-caixa.fm-cod-com = ?
                                        AND   item-caixa.sigla-emb BEGINS embalag.sigla-emb NO-LOCK NO-ERROR.
                                END. /* FOR EACH embalag */
                            END. /* IF NOT AVAILABLE embalag THEN DO: */
                        END. /* IF NOT AVAILABLE int-emitente OR int-emitente.tipo-embalagem = "":U THEN DO: */
                    END. /* IF AVAILABLE emitente THEN DO: */
    
                    IF AVAILABLE item-caixa THEN DO:
                        IF l-ativa-log  THEN
                            PUT "8a1" SKIP.   
    
                        IF  p-fracionado AND it-dep-fat.qt-alocada MODULO item-caixa.qt-item = 0 THEN
                            NEXT.
    
                        IF NOT p-fracionado AND it-dep-fat.qt-alocada MODULO item-caixa.qt-item <> 0 AND
                            it-dep-fat.qt-alocada < item-caixa.qt-item THEN
                            NEXT.
                    END. /* IF AVAILABLE item-caixa THEN DO: */
                END. /* IF pre-fatur.nat-operacao BEGINS "7":U THEN DO: */
                ELSE DO:
    
                    IF l-ativa-log  THEN
                        PUT "8b " it-dep-fat.it-codigo SKIP.   
    
                    FIND FIRST item-caixa
                         WHERE item-caixa.it-codigo   = it-dep-fat.it-codigo
                           AND item-caixa.fm-codigo   = ?
                           AND item-caixa.fm-cod-com  = ?
                           AND item-caixa.sigla-emb  >= "A" NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE item-caixa THEN DO:
    
                        IF l-ativa-log  THEN
                            PUT "8b- " it-dep-fat.it-codigo SKIP.   
    
                        FIND FIRST item-caixa
                             WHERE item-caixa.it-codigo  = it-dep-fat.it-codigo
                               AND item-caixa.fm-codigo  = ?
                               AND item-caixa.fm-cod-com = ?
                               AND item-caixa.sigla-emb BEGINS "E":U NO-LOCK NO-ERROR.
                    END. /* IF NOT AVAILABLE item-caixa THEN DO: */
    
                    IF AVAILABLE item-caixa THEN DO:
                        IF l-ativa-log  THEN
                            PUT "8b1" SKIP.   
    
                        IF  p-fracionado AND it-dep-fat.qt-alocada MODULO item-caixa.qt-item = 0 THEN
                            NEXT.
    
                        IF  NOT p-fracionado AND it-dep-fat.qt-alocada MODULO item-caixa.qt-item <> 0 AND
                            it-dep-fat.qt-alocada < item-caixa.qt-item THEN
                            NEXT.
                    END. /* IF AVAILABLE item-caixa THEN DO: */
                    ELSE
                        IF l-ativa-log  THEN
                            PUT "8b-- " it-dep-fat.it-codigo SKIP.   
    
                    IF  NOT p-fracionado AND NOT AVAIL item-caixa THEN
                        NEXT.                    
                END. /* IF pre-fatur.nat-operacao NOT BEGINS "7":U THEN DO: */
    
    
                IF l-ativa-log  THEN
                    PUT "9" SKIP.   
    
                ASSIGN l-it-dep-fat = YES.
    
                FIND FIRST tt-item
                    WHERE tt-item.separa-mg     = lSepara-mg
                    AND   tt-item.nome-transp   = (IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp)
                    AND   tt-item.estado        = tt-notaOrigem.estado
                    AND   tt-item.it-codigo     = it-dep-fat.it-codigo
                    AND   tt-item.cod-refer     = it-dep-fat.cod-refer
                    AND   tt-item.deposito      = it-dep-fat.cod-depos
                    AND   tt-item.localizacao   = SUBSTRING(it-dep-fat.cod-localiz,1,10)
                    AND   tt-item.nr-serie      = it-dep-fat.nr-serlot
                    AND   tt-item.cod-cli-dif   = x-cli-difer
                    AND   tt-item.nr-nota-fis   = tt-notaOrigem.nr-nota-fis 
                    AND   tt-item.l-fracionado  = p-fracionado NO-ERROR.
    
                IF NOT AVAILABLE tt-item THEN DO:
    
                    IF l-ativa-log THEN
                        PUT 'cria tt-item' SKIP.
    
                    CREATE tt-item.
                    ASSIGN tt-item.separa-mg     = lSepara-mg
                           tt-item.nome-transp   = IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp
                           tt-item.estado        = tt-notaOrigem.estado      
                           tt-item.it-codigo     = it-dep-fat.it-codigo
                           tt-item.cod-refer     = it-dep-fat.cod-refer
                           tt-item.deposito      = it-dep-fat.cod-depos
                           tt-item.pedido        = it-dep-fat.nr-pedcli
                           tt-item.localizacao   = SUBSTRING(it-dep-fat.cod-localiz,1,10)
                           tt-item.nr-serie      = it-dep-fat.nr-serlot
                           tt-item.qt-alocada    = IF NOT AVAILABLE item-caixa  THEN 
                                                        it-dep-fat.qt-alocada ELSE (IF  p-fracionado
                                                                                    THEN it-dep-fat.qt-alocada MODULO item-caixa.qt-item
                                                                                    ELSE it-dep-fat.qt-alocada - (it-dep-fat.qt-alocada MODULO item-caixa.qt-item)) /*it-dep-fat.qt-alocada*/
    
                           tt-item.cod-cli-dif   = x-cli-difer
                           tt-item.cdd-embarque  = it-dep-fat.cdd-embarq  
                           tt-item.nr-resumo     = it-dep-fat.nr-resumo   
                           tt-item.nome-abrev    = it-dep-fat.nome-abrev  
                           tt-item.nr-pedcli     = it-dep-fat.nr-pedcli   
                           tt-item.nr-embarque   = it-dep-fat.nr-embarque 
                           tt-item.cod-estabel   = it-dep-fat.cod-estabel
                           tt-item.serie         = tt-notaOrigem.serie       
                           tt-item.nr-nota-fis   = tt-notaOrigem.nr-nota-fis 
                           tt-item.nr-seq-fat    = it-dep-fat.nr-sequencia
                           tt-item.nota-classif  = IF CAN-FIND(FIRST filial-cliente WHERE filial-cliente.cnpj = nota-fiscal.cgc) THEN c-nr-nota-fis ELSE ""
                           tt-item.qt-item       = IF AVAIL item-caixa THEN item-caixa.qt-item ELSE 0
                           tt-item.obs-cli-difer = c-obs-cli-difer.
    
                    FIND item WHERE ITEM.it-codigo = tt-item.it-codigo NO-LOCK NO-ERROR.
    
                    IF AVAILABLE item THEN
                        ASSIGN tt-item.desc-item = item.desc-item
                               tt-item.un        = item.un.
    
                    /* Sequància do Item na impress∆o */
                    FIND FIRST seq-item
                        WHERE  seq-item.it-codigo = tt-item.it-codigo NO-LOCK NO-ERROR.
    
                    IF AVAIL seq-item THEN
                        ASSIGN tt-item.sequencia = IF AVAIL seq-item THEN seq-item.sequencia ELSE 999999.
                END. /* IF NOT AVAILABLE tt-item THEN DO: */
                ELSE
                    ASSIGN tt-item.qt-alocada = tt-item.qt-alocada +
                                                (IF NOT AVAILABLE item-caixa THEN
                                                    it-dep-fat.qt-alocada ELSE (IF p-fracionado
                                                                                THEN it-dep-fat.qt-alocada MODULO item-caixa.qt-item
                                                                                ELSE it-dep-fat.qt-alocada - (it-dep-fat.qt-alocada MODULO item-caixa.qt-item))) /*it-dep-fat.qt-alocada*/ .
    
                ASSIGN tt-item.l-fracionado = IF tt-item.qt-item <> 0 THEN tt-item.qt-alocada MODULO tt-item.qt-item <> 0 ELSE IF tt-item.qt-item = 0 THEN YES ELSE NO.
    
                RUN piCentral(INPUT it-dep-fat.cod-refer,
                              INPUT it-dep-fat.cod-depos,
                              INPUT it-dep-fat.cod-localiz,
                              INPUT it-dep-fat.nr-serlot,
                              INPUT it-dep-fat.qt-alocada,
                              INPUT it-dep-fat.nr-embarque,
                              INPUT it-dep-fat.cod-estabel,
                              INPUT it-dep-fat.it-codigo,
                              INPUT it-dep-fat.nr-pedcli,
                              INPUT it-dep-fat.cdd-embarq,
                              INPUT it-dep-fat.nr-sequencia,
                              INPUT it-dep-fat.nr-resumo,
                              INPUT it-dep-fat.nome-abrev,
                              INPUT p-fracionado).
            END.  /* FOR EACH it-dep-fat NO-LOCK */
        
            IF l-ativa-log  THEN
                PUT "10" SKIP.   
    
            IF NOT l-it-dep-fat THEN DO:
                
                IF l-ativa-log  THEN
                    PUT "10-1" SKIP.   
    
                IF pre-fatur.nat-operacao BEGINS "7":U THEN DO:
    
                    FIND FIRST emitente WHERE emitente.nome-abrev = pre-fatur.nome-abrev NO-LOCK NO-ERROR.
    
                    IF AVAILABLE emitente THEN DO:
    
                        FIND FIRST int-emitente
                            WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    
                        IF l-ativa-log  THEN
                            PUT "10-2" SKIP.   
    
                        IF AVAILABLE int-emitente AND int-emitente.tipo-embalagem <> "":U THEN DO:
    
                            FIND FIRST embalag WHERE embalag.embalagem = int-emitente.tipo-embalagem NO-LOCK NO-ERROR.
    
                            IF AVAILABLE embalag THEN
    
                                FIND FIRST item-caixa
                                    WHERE item-caixa.it-codigo  = it-pre-fat.it-codigo
                                    AND   item-caixa.fm-codigo  = ?
                                    AND   item-caixa.fm-cod-com = ?
                                    AND   item-caixa.sigla-emb BEGINS embalag.sigla-emb NO-LOCK NO-ERROR.
                        END. /* IF AVAILABLE int-emitente AND int-emitente.tipo-embalagem <> "":U THEN DO: */
                        ELSE DO:
    
                            FIND FIRST item-caixa
                                WHERE item-caixa.it-codigo  = it-pre-fat.it-codigo
                                  AND item-caixa.fm-codigo  = ?
                                  AND item-caixa.fm-cod-com = ?
                                  AND item-caixa.sigla-emb BEGINS "E":U NO-LOCK NO-ERROR.
    
                            FIND FIRST embalag WHERE embalag.sigla-emb = item-caixa.sigla-emb NO-LOCK NO-ERROR.
                            IF NOT AVAILABLE embalag THEN DO:
    
                                FOR EACH embalag
                                    WHERE embalag.embalagem BEGINS "EMB":U
                                    AND   embalag.emite-roman NO-LOCK BREAK BY embalag.volume:
    
                                    FIND FIRST item-caixa
                                        WHERE item-caixa.it-codigo  = it-pre-fat.it-codigo
                                        AND   item-caixa.fm-codigo  = ?
                                        AND   item-caixa.fm-cod-com = ?
                                        AND   item-caixa.sigla-emb BEGINS embalag.sigla-emb NO-LOCK NO-ERROR.
                                END. /* FOR EACH embalag */
                            END. /* IF NOT AVAILABLE embalag THEN DO: */
                        END. /* IF NOT AVAILABLE int-emitente OR int-emitente.tipo-embalagem = "":U THEN DO: */
                    END. /* IF AVAILABLE emitente THEN DO: */
    
                    IF l-ativa-log  THEN
                        PUT "10-3" SKIP.
    
                    IF AVAILABLE item-caixa THEN DO:
    
                        IF  p-fracionado AND it-pre-fat.qt-alocada MODULO item-caixa.qt-item = 0 THEN
                            NEXT.
    
                        IF  NOT p-fracionado AND it-pre-fat.qt-alocada MODULO item-caixa.qt-item <> 0 AND
                            it-pre-fat.qt-alocada < item-caixa.qt-item THEN
                            NEXT.
                    END. /* IF AVAILABLE item-caixa THEN DO: */
                END. /* IF pre-fatur.nat-operacao BEGINS "7":U THEN DO: */
                ELSE DO:
    
                    IF l-ativa-log  THEN
                        PUT "10-1b" SKIP.   
    
                    FIND FIRST item-caixa
                         WHERE item-caixa.it-codigo   = it-pre-fat.it-codigo
                           AND item-caixa.fm-codigo   = ?
                           AND item-caixa.fm-cod-com  = ?
                           AND item-caixa.sigla-emb  >= "A" NO-LOCK NO-ERROR.
                    IF NOT AVAIL item-caixa THEN DO:
    
                        FIND FIRST item-caixa
                             WHERE item-caixa.it-codigo  = it-pre-fat.it-codigo
                               AND item-caixa.fm-codigo  = ?
                               AND item-caixa.fm-cod-com = ?
                               AND item-caixa.sigla-emb BEGINS "E":U NO-LOCK NO-ERROR.
                    END. /* IF NOT AVAIL item-caixa THEN DO: */
    
                    IF AVAILABLE item-caixa THEN DO:
    
                        IF  p-fracionado AND it-pre-fat.qt-alocada MODULO item-caixa.qt-item = 0 THEN
                            NEXT.
    
                        IF  NOT p-fracionado AND it-pre-fat.qt-alocada MODULO item-caixa.qt-item <> 0 AND
                            it-pre-fat.qt-alocada < item-caixa.qt-item THEN
                            NEXT.
                    END. /* IF AVAIL item-caixa THEN DO: */
    
                    IF  NOT p-fracionado AND NOT AVAIL item-caixa THEN
                        NEXT.
                END. /* IF pre-fatur.nat-operacao NOT BEGINS "7":U THEN DO: */
    
                IF l-ativa-log  THEN
                    PUT "10-4" SKIP.   
    
                ASSIGN c-cod-depos = "".
    
                FOR EACH fat-ser-lote
                   WHERE fat-ser-lote.cod-estabel = tt-notaOrigem.cod-estabel
                     AND fat-ser-lote.serie       = tt-notaOrigem.serie
                     AND fat-ser-lote.nr-nota-fis = tt-notaOrigem.nr-nota-fis
                     AND fat-ser-lote.it-codigo   = it-pre-fat.it-codigo
                     AND fat-ser-lote.cod-refer   = it-pre-fat.cod-refer NO-LOCK:
    
                    ASSIGN c-cod-depos = c-cod-depos  + fat-ser-lote.cod-depos + ",".
                END. /* FOR EACH fat-ser-lote */
    
                IF l-ativa-log  THEN
                    PUT "10-5 CREATE tt-item " it-pre-fat.it-codigo SKIP.   
    
                FIND FIRST tt-item
                     WHERE tt-item.nome-transp  = (IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp)
                       AND tt-item.estado       = tt-notaOrigem.estado
                       AND tt-item.it-codigo    = it-pre-fat.it-codigo
                       AND tt-item.cod-refer    = it-pre-fat.cod-refer
                       AND INDEX(c-cod-depos,tt-item.deposito) <> 0
                       AND tt-item.cod-cli-dif  = x-cli-difer
                       AND tt-item.nr-nota-fis  = tt-notaOrigem.nr-nota-fis
                       AND tt-item.l-fracionado = p-fracionado NO-ERROR.
    
                IF NOT AVAILABLE tt-item THEN DO:
                    CREATE tt-item.
                    ASSIGN tt-item.separa-mg     = lSepara-mg
                           tt-item.nome-transp   = IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp
                           tt-item.estado        = tt-notaOrigem.estado 
                           tt-item.it-codigo     = it-pre-fat.it-codigo
                           tt-item.cod-refer     = it-pre-fat.cod-refer
                           tt-item.deposito      = c-cod-depos
                           tt-item.pedido        = it-pre-fat.nr-pedcli
                           tt-item.qt-alocada    = IF NOT AVAILABLE item-caixa THEN it-pre-fat.qt-alocada ELSE (IF  p-fracionado THEN it-pre-fat.qt-alocada MODULO item-caixa.qt-item ELSE it-pre-fat.qt-alocada - (it-pre-fat.qt-alocada MODULO item-caixa.qt-item)) /*it-pre-fat.qt-alocada*/
                           tt-item.cdd-embarque  = it-pre-fat.cdd-embarq  
                           tt-item.nr-resumo     = it-pre-fat.nr-resumo   
                           tt-item.nome-abrev    = it-pre-fat.nome-abrev  
                           tt-item.nr-pedcli     = it-pre-fat.nr-pedcli   
                           tt-item.nr-embarque   = it-pre-fat.nr-embarque 
                           tt-item.cod-estabel   = pre-fatur.cod-estabel
                           tt-item.serie         = tt-notaOrigem.serie       
                           tt-item.nr-nota-fis   = tt-notaOrigem.nr-nota-fis 
                           tt-item.nr-seq-fat    = it-pre-fat.nr-sequencia
                           tt-item.cod-cli-dif   = x-cli-difer
                           tt-item.nota-classif  = IF CAN-FIND(FIRST filial-cliente WHERE filial-cliente.cnpj = nota-fiscal.cgc) THEN c-nr-nota-fis ELSE ""
                           tt-item.qt-item       = IF AVAIL item-caixa THEN item-caixa.qt-item ELSE 0
                           tt-item.obs-cli-difer = c-obs-cli-difer.
        
                    FIND item
                        WHERE item.it-codigo = tt-item.it-codigo NO-LOCK NO-ERROR.
    
                    IF  AVAILABLE item THEN
                        ASSIGN tt-item.desc-item    = ITEM.desc-item
                               tt-item.un           = ITEM.un.
        
                    /* Sequància do Item na impress∆o */
                    FIND FIRST seq-item
                        WHERE  seq-item.it-codigo = tt-item.it-codigo NO-LOCK NO-ERROR.
    
                    ASSIGN tt-item.sequencia = IF AVAIL seq-item THEN seq-item.sequencia ELSE 999999.
                END. /* IF NOT AVAILABLE tt-item THEN DO: */
                ELSE
                    ASSIGN tt-item.qt-alocada = tt-item.qt-alocada +
                                                (IF NOT AVAILABLE item-caixa THEN
                                                 it-pre-fat.qt-alocada ELSE (IF  p-fracionado THEN 
                                                     it-pre-fat.qt-alocada MODULO item-caixa.qt-item
                                                     ELSE it-pre-fat.qt-alocada - (it-pre-fat.qt-alocada MODULO item-caixa.qt-item))) /*it-pre-fat.qt-alocada*/ .
    
                ASSIGN tt-item.l-fracionado = IF  tt-item.qt-item <> 0 THEN tt-item.qt-alocada MODULO tt-item.qt-item <> 0 ELSE IF tt-item.qt-item = 0 THEN YES ELSE NO.

                IF l-ativa-log  THEN
                    PUT "10-50 " it-pre-fat.it-codigo SKIP.   
    
                /* Centrais */
                RUN piCentral(INPUT it-pre-fat.cod-refer,
                              INPUT c-cod-depos,
                              INPUT "",
                              INPUT tt-notaOrigem.serie,
                              INPUT it-pre-fat.qt-alocada,
                              INPUT it-pre-fat.nr-embarque,
                              INPUT pre-fatur.cod-estabel,
                              INPUT it-pre-fat.it-codigo,
                              INPUT it-pre-fat.nr-pedcli,
                              INPUT it-pre-fat.cdd-embarq,
                              INPUT it-pre-fat.nr-sequencia,
                              INPUT it-pre-fat.nr-resumo,
                              INPUT it-pre-fat.nome-abrev,
                              INPUT p-fracionado).
    
            END. /* NOT l-it-dep-fat */
            
            FOR EACH tt-item
               WHERE tt-item.l-fracionado = NO:

                FIND FIRST bf-item
                     WHERE bf-item.nome-transp  = tt-item.nome-transp 
                     AND   bf-item.estado       = tt-item.estado      
                     AND   bf-item.it-codigo    = tt-item.it-codigo   
                     AND   bf-item.cod-refer    = tt-item.cod-refer   
                     AND   bf-item.deposito     = tt-item.deposito    
                     AND   bf-item.cod-cli-dif  = tt-item.cod-cli-dif 
                     AND   bf-item.nr-nota-fis  = tt-item.nr-nota-fis
                     AND   bf-item.l-fracionado = tt-item.l-fracionado
                     AND   ROWID(bf-item)      <> ROWID(tt-item) NO-ERROR.
                IF AVAIL bf-item THEN DO:
                   ASSIGN tt-item.qt-alocada = tt-item.qt-alocada + bf-item.qt-alocada.
                   DELETE bf-item.
                END.

            END.
            

/*             OUTPUT TO c:\temp\teste.txt.                    */
/*             FOR EACH tt-item:                               */
/*                 DISP tt-item WITH WIDTH 320 STREAM-IO DOWN. */
/*             END.                                            */
/*             OUTPUT CLOSE.                                   */
    
            IF l-ativa-log  THEN
                PUT "10-6" SKIP.   
    
            FIND FIRST tt-pre-fatur
                 WHERE tt-pre-fatur.nr-embarque  = pre-fatur.cdd-embarq
                   AND tt-pre-fatur.nr-resumo    = pre-fatur.nr-resumo
                   AND tt-pre-fatur.nome-abrev   = pre-fatur.nome-abrev
                   AND tt-pre-fatur.nr-pedcli    = pre-fatur.nr-pedcli NO-LOCK NO-ERROR.
    
            IF NOT AVAILABLE tt-pre-fatur THEN DO:
    
                CREATE tt-pre-fatur.
                ASSIGN tt-pre-fatur.nr-embarque  = pre-fatur.cdd-embarq
                       tt-pre-fatur.nr-resumo    = pre-fatur.nr-resumo
                       tt-pre-fatur.nome-abrev   = pre-fatur.nome-abrev
                       tt-pre-fatur.nr-pedcli    = pre-fatur.nr-pedcli.
            END. /* IF NOT AVAILABLE tt-pre-fatur THEN DO: */
    
            IF NOT CAN-FIND(FIRST ttEmbarques
                            WHERE ttEmbarques.separa-mg   = lSepara-mg
                              AND ttEmbarques.nome-transp = (IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp)
                              AND ttEmbarques.estado      = tt-notaOrigem.estado
                              AND ttEmbarques.nr-embarque = pre-fatur.cdd-embarq
                              AND ttEmbarques.cod-cli-dif = x-cli-difer) THEN DO:
    
               CREATE ttEmbarques.
               ASSIGN ttEmbarques.separa-mg   = lSepara-mg
                      ttEmbarques.nome-transp = IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp 
                      ttEmbarques.estado      = tt-notaOrigem.estado      
                      ttEmbarques.nr-embarque = pre-fatur.cdd-embarq
                      ttEmbarques.cod-cli-dif = x-cli-difer.
            END. /* IF NOT CAN-FIND(ttEmbarques */
    
            IF l-ativa-log  THEN
                PUT "10-7" SKIP.   
    
            IF NOT CAN-FIND(FIRST ttnota-fiscal
                            WHERE ttNota-fiscal.separa-mg   = lSepara-mg
                              AND ttNota-fiscal.cod-estabel = tt-notaOrigem.cod-estabel
                              AND ttNota-fiscal.serie       = tt-notaOrigem.serie
                              AND ttNota-fiscal.nr-nota-fis = tt-notaOrigem.nr-nota-fis) THEN DO:
    
                CREATE ttNota-fiscal.
                ASSIGN ttnota-fiscal.separa-mg   = lSepara-mg
                       ttNota-fiscal.nome-transp = tt-notaOrigem.nome-transp
                       ttNota-fiscal.estado      = tt-notaOrigem.estado
                       ttNota-fiscal.cod-estabel = tt-notaOrigem.cod-estabel
                       ttNota-fiscal.serie       = tt-notaOrigem.serie
                       ttNota-fiscal.nr-nota-fis = tt-notaOrigem.nr-nota-fis
                       ttNota-fiscal.vl-tot-nota = tt-notaOrigem.vl-tot-nota
                       ttNota-fiscal.nr-volumes  = tt-notaOrigem.nr-volumes
                       ttNota-fiscal.cod-cli-dif = x-cli-difer.
            END. /* IF NOT CAN-FIND(ttnota-fiscal */
        END. /* IF AVAIL tt-notaOrigem THEN DO: */
    END. /* FOR EACH pre-fatur USE-INDEX ch-embarque NO-LOCK */

END. /*fim pi-gera-item*/
