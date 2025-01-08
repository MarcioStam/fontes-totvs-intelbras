/*----------------------------------------------------------------------
**  Programa..: esp/ftp/esftp010rp.p
**  Autor.....: Robinson Koprowski - Gestech
**  Data......: Dezembro/2004 - Desenvolvimento
**  Descricao.: Separaá∆o de itens para embarque por transportadora
-----------------------------------------------------------------------*/
DEFINE BUFFER empresa FOR mgcad.empresa.
{include/i-prgvrs.i esftp010 2.00.00.000}

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
       cTipoVolume      = "Fracionada;Fechada;Ambos":U.
DEF BUFFER b-nota-fiscal FOR nota-fiscal.
/*---------------------------  Temp-Tables  ---------------------------*/

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino             AS INTEGER
    FIELD arquivo             AS CHARACTER FORMAT "x(35)":U
    FIELD usuario             AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec           AS DATE
    FIELD hora-exec           AS INTEGER
    FIELD nr-embarque-ini     LIKE pre-fatur.cdd-embarq
    FIELD nr-embarque-end     LIKE pre-fatur.cdd-embarq
    FIELD nr-resumo-ini       LIKE pre-fatur.nr-resumo
    FIELD nr-resumo-end       LIKE pre-fatur.nr-resumo
    FIELD rastreabilidade     AS INTEGER
    FIELD tipo-volume         AS INTEGER
    FIELD nome-transp         LIKE pre-fatur.nome-transp
    FIELD dt-emis-nf-ini      LIKE nota-fiscal.dt-emis-nota
    FIELD dt-emis-nf-end      LIKE nota-fiscal.dt-emis-nota
    FIELD it-codigo-ini       LIKE it-nota-fisc.it-codigo
    FIELD it-codigo-fim       LIKE it-nota-fisc.it-codigo
    FIELD it-codigo-ini-2     LIKE it-nota-fisc.it-codigo
    FIELD it-codigo-fim-2     LIKE it-nota-fisc.it-codigo
    FIELD l-centrais          AS LOGICAL
    FIELD reimpressao         AS LOGICAL FORMAT "Sim/Nío":U
    FIELD impr-params         AS LOGICAL
    FIELD notas-mg            AS INTEGER
    FIELD l-estado            AS LOGICAL
    FIELD c-estado            AS CHARACTER
    FIELD l-class             AS LOG
    FIELD cod-estabel         AS CHAR
    FIELD notas-desconsiderar AS CHAR
    FIELD ordenacao-item      AS LOGICAL.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD cod-estabel       LIKE nota-fiscal.cod-estabel    INITIAL '101'
    FIELD serie             LIKE nota-fiscal.serie          INITIAL '3'
    FIELD nr-nota-fis-ini   LIKE nota-fiscal.nr-nota-fis    COLUMN-LABEL 'NF Ini'
    FIELD nr-nota-fis-end   LIKE nota-fiscal.nr-nota-fis    COLUMN-LABEL 'NF Fim'
    INDEX idNotas IS PRIMARY cod-estabel serie nr-nota-fis-ini.

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
    FIELD nr-serie          LIKE it-dep-fat.nr-serlot
    FIELD cod-cli-dif       LIKE cli-difer.cod-emitente
    FIELD nr-nota-fis       LIKE nota-fiscal.nr-nota-fis
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


/*
DEFINE TEMP-TABLE tt-cli-dif NO-UNDO
    FIELD separa-mg         AS LOGICAL
    FIELD nome-transp       LIKE nota-fiscal.nome-transp
    FIELD estado            LIKE nota-fiscal.estado
    FIELD cod-emitente      LIKE cli-difer.cod-emitente
    FIELD nome-abrev        LIKE emitente.nome-abrev
    INDEX tt-cli-dif IS PRIMARY UNIQUE separa-mg nome-transp cod-emitente.
*/


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

DEF VAR x-cli-difer AS INT.
DEF VAR c-nr-nota-fis LIKE nota-fiscal.nr-nota-fis.
DEFINE VARIABLE c-obs-cli-difer AS CHARACTER   NO-UNDO.

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

/* INICIO CARREGA TEMP-TABLE FAIXA DE NOTAS A DESCONSIDERAR */
DEFINE VARIABLE c-nota-des AS CHARACTER   NO-UNDO .
DEFINE VARIABLE c-inicial-nota-des AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-final-nota-des AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-faixa-nota-des AS CHARACTER   NO-UNDO.
DEF TEMP-TABLE tt-nota-des
    FIELD c-cod-nota-des-ini AS CHARACTER
    FIELD c-cod-nota-des-fim AS CHARACTER.

ASSIGN c-nota-des = tt-param.notas-desconsiderar.
DO i-cont = 1 TO NUM-ENTRIES(c-nota-des):
    ASSIGN c-faixa-nota-des = ENTRY(i-cont,c-nota-des).
    ASSIGN c-inicial-nota-des   = "" 
           c-final-nota-des   = "".

    IF NUM-ENTRIES(c-faixa-nota-des, "-") > 1 THEN DO:
        ASSIGN c-inicial-nota-des = ENTRY(1,c-faixa-nota-des,"-")  /* Faixa de Seleªío de nota-des */
               c-final-nota-des   = ENTRY(2,c-faixa-nota-des,"-").

        /* PUT 1
            SKIP. */

        CREATE tt-nota-des.
        ASSIGN tt-nota-des.c-cod-nota-des-ini = c-inicial-nota-des
               tt-nota-des.c-cod-nota-des-fim = c-final-nota-des.
    END.
    ELSE DO:
        /* PUT 2
            SKIP. */
        CREATE tt-nota-des.             
        ASSIGN tt-nota-des.c-cod-nota-des-ini = ENTRY(i-cont,c-nota-des)
               tt-nota-des.c-cod-nota-des-fim = ENTRY(i-cont,c-nota-des).
    END.
END.
/* FIM CARREGA TEMP-TABLE FAIXA DE NOTAS A DESCONSIDERAR */

IF tt-param.c-estado <> "" THEN DO:
   DO i-cont = 1 TO 30:
      ASSIGN c-est = ENTRY(i-cont,tt-param.c-estado) NO-ERROR.
      IF c-est <> "" THEN DO:
          /* PUT 3
              SKIP. */
         CREATE tt-estado.
         ASSIGN tt-estado.estado = SUBSTRING(c-est,1,2)
                c-est            = "".
      END.
   END.
END.

/*---------------------------  Frames       ---------------------------*/
FIND FIRST param-global NO-LOCK.
FIND FIRST empresa      NO-LOCK WHERE empresa.ep-codigo = param-global.empresa-pri.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Separaá∆o de Itens para Embarque"
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE ''
       c-programa     = "ESFTP010"
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
         b-ponto-programa.nome-programa = "esftp010":
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
/* Fim */

IF tt-param.rastreabilidade <> 3 THEN DO:
    FOR EACH item-rast FIELDS(it-codigo data-ini data-fim) NO-LOCK 
        WHERE item-rast.data-ini  <= TODAY
        AND   item-rast.data-fim   > TODAY:

        /* PUT 4
            SKIP. */
        CREATE tt-item-rast.         
        ASSIGN tt-item-rast.it-codigo = item-rast.it-codigo.
    END.

END.

run pi-acompanhar in h-acomp (input "Buscando dados...").

{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

FOR EACH tt-notaOrigem:
    DELETE tt-notaOrigem.
END.

    IF l-ativa-log  THEN
        PUT "1" SKIP.

/**********  Transportadora informada  ***********/
IF tt-param.nome-transp <> "" THEN DO:

    FOR EACH pre-fatur USE-INDEX ch-embarque NO-LOCK               WHERE
             pre-fatur.pick-impresso    = tt-param.reimpressao     AND
           /*pre-fatur.cod-sit-pre     <> 1                        AND */
             pre-fatur.cdd-embarq     >= tt-param.nr-embarque-ini AND
             pre-fatur.cdd-embarq     <= tt-param.nr-embarque-end AND
             pre-fatur.nr-resumo       >= tt-param.nr-resumo-ini   AND
             pre-fatur.nr-resumo       <= tt-param.nr-resumo-end,
        EACH it-pre-fat NO-LOCK OF pre-fatur:

    IF l-ativa-log  THEN
        PUT "2" SKIP.

        IF tt-param.rastreabilidade = 1 THEN DO:
            FIND FIRST tt-item-rast
                WHERE tt-item-rast.it-codigo = it-pre-fat.it-codigo NO-ERROR.

            IF NOT AVAILABLE tt-item-rast THEN NEXT.
        END.
        ELSE IF tt-param.rastreabilidade = 2 THEN DO:
            FIND FIRST tt-item-rast
                WHERE tt-item-rast.it-codigo = it-pre-fat.it-codigo NO-ERROR.

            IF AVAILABLE tt-item-rast THEN NEXT.
        END.

        IF l-ativa-log  THEN
           PUT "3" SKIP.

        ASSIGN c-transp = "".
      
        /*validaá∆o da transportadora passa a ser na NF pois ela j† esta gerada e pode ser alterada na nota*/
        FOR FIRST nota-fiscal NO-LOCK                                  WHERE 
                  nota-fiscal.cdd-embarq     = pre-fatur.cdd-embarq   AND
                  nota-fiscal.nr-resumo      = pre-fatur.nr-resumo     AND
                  nota-fiscal.nome-ab-cli    = pre-fatur.nome-abrev    AND
                  nota-fiscal.nr-pedcli      = pre-fatur.nr-pedcli     AND
                  nota-fiscal.cod-estabel    = tt-param.cod-estabel    AND
                  nota-fiscal.dt-cancela     = ?:
            ASSIGN c-transp = nota-fiscal.nome-transp.
        END.
        
        IF l-ativa-log  THEN
           PUT "3a " nota-fiscal.nat-operacao " " nota-fiscal.nr-nota-fis  SKIP.

        FIND natur-oper
            WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-LOCK NO-ERROR.

        IF l-ativa-log  THEN
           PUT "3a " natur-oper.log-oper-triang  SKIP.

        IF AVAIL natur-oper AND natur-oper.log-oper-triang THEN DO:

            FOR FIRST b-nota-fiscal NO-LOCK                                  
                WHERE b-nota-fiscal.cdd-embarq     = pre-fatur.cdd-embarq    
                  AND b-nota-fiscal.nr-resumo      = pre-fatur.nr-resumo     
                  AND b-nota-fiscal.nome-ab-cli    = nota-fiscal.nome-abrev  
                  AND b-nota-fiscal.nr-pedcli     = ""                      
                  AND b-nota-fiscal.cod-estabel    = tt-param.cod-estabel    
                  AND b-nota-fiscal.dt-cancela     = ?:
                ASSIGN c-transp = b-nota-fiscal.nome-transp.
                IF l-ativa-log  THEN
                   PUT "3b " b-nota-fiscal.nr-nota-fis  SKIP.

            END.

        END. /* IF AVAIL natur-oper AND natur-oper.log-oper-triang THEN DO: */

        IF l-ativa-log  THEN
            PUT "4" SKIP.

        IF AVAIL b-nota-fiscal THEN DO:

            FIND FIRST tt-notaOrigem
                WHERE tt-notaOrigem.cod-estabel  = b-nota-fiscal.cod-estabel 
                  AND tt-notaOrigem.serie        = b-nota-fiscal.serie       
                  AND tt-notaOrigem.nr-nota-fis  = b-nota-fiscal.nr-nota-fis  EXCLUSIVE-LOCK NO-ERROR.
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
                       tt-notaOrigem.nome-abrev   = b-nota-fiscal.nome-abrev.
            END. /*  IF NOT AVAIL tt-notaOrigem THEN DO: */

        END. /* IF AVAIL b-nota-fiscal THEN DO: */
        ELSE DO:

            IF AVAIL nota-fiscal THEN DO:

                FIND FIRST tt-notaOrigem
                    WHERE tt-notaOrigem.cod-estabel  = nota-fiscal.cod-estabel 
                      AND tt-notaOrigem.serie        = nota-fiscal.serie       
                      AND tt-notaOrigem.nr-nota-fis  = nota-fiscal.nr-nota-fis  EXCLUSIVE-LOCK NO-ERROR.
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
                           tt-notaOrigem.nome-abrev   = nota-fiscal.nome-abrev.
                END. /*  IF NOT AVAIL tt-notaOrigem THEN DO: */

            END. /* IF AVAIL nota-fiscal THEN DO: */

        END. /* IF NOT AVAIL b-nota-fiscal THEN DO: */


        IF l-ativa-log  THEN
           PUT "5" SKIP.

        FIND CURRENT tt-notaOrigem NO-LOCK NO-ERROR.
        IF AVAIL tt-notaOrigem THEN DO:

            IF l-ativa-log  THEN
               PUT "5a" SKIP.

            IF AVAIL tt-notaOrigem AND tt-param.notas-desconsiderar <> "" THEN DO:
                FIND FIRST tt-nota-des
                    WHERE INT(tt-nota-des.c-cod-nota-des-ini) <= INT(tt-notaOrigem.nr-nota-fis)
                      AND INT(tt-nota-des.c-cod-nota-des-fim) >= INT(tt-notaOrigem.nr-nota-fis) NO-LOCK NO-ERROR.
                IF AVAIL tt-nota-des THEN NEXT.
            END.
            IF l-ativa-log  THEN
               PUT "5b" SKIP.
            
            IF AVAIL tt-notaOrigem AND
               tt-notaOrigem.nome-transp <> tt-param.nome-transp THEN NEXT.
            IF l-ativa-log  THEN
               PUT "5b1" SKIP.    
            FOR FIRST ped-venda NO-LOCK
                WHERE ped-venda.nr-pedcli  = pre-fatur.nr-pedcli
                  AND ped-venda.nome-abrev = pre-fatur.nome-abrev:
            END.
    
            IF l-ativa-log  THEN
               PUT "5c" SKIP.

            IF  NOT AVAIL tt-notaOrigem AND 
                NOT AVAIL ped-venda   THEN NEXT.
    
            IF  AVAIL tt-notaOrigem THEN DO:
                FOR FIRST natur-oper NO-LOCK WHERE
                          natur-oper.nat-operacao = tt-notaOrigem.nat-operacao:
                END.
                IF l-ativa-log  THEN
                   PUT "5d" SKIP.

                {esinc/es0004.i} /*ValidaNaturezasImpress∆oNFs*/
                    IF l-ativa-log  THEN
                       PUT "5e" SKIP.

            END.
            ELSE DO:
                FOR FIRST natur-oper NO-LOCK WHERE
                          natur-oper.nat-operacao = ped-venda.nat-operacao:
                END.
                IF l-ativa-log  THEN
                   PUT "5f" SKIP.

                {esinc/es0004a.i} /*ValidaNaturezasImpress∆oNFs*/
                    IF l-ativa-log  THEN
                       PUT "5g" SKIP.

            END.

            IF l-ativa-log  THEN
                PUT "6" SKIP.   
    
            IF tt-param.l-estado THEN 
                IF NOT CAN-FIND(tt-estado WHERE 
                                tt-estado.estado = IF AVAIL tt-notaOrigem THEN tt-notaOrigem.estado ELSE ped-venda.estado) THEN 
                    NEXT.
    
            RUN defineAstec.
    
            /********* Achar Cliente diferenciado *************/ 
            ASSIGN x-cli-difer = 0
                   c-nr-nota-fis = ""
                   c-obs-cli-difer = "".
    
            FOR EACH cli-difer NO-LOCK 
                WHERE cli-difer.cod-emitente = IF AVAIL tt-notaOrigem THEN tt-notaOrigem.cod-emitente ELSE ped-venda.cod-emitente:
    
                IF x-cli-difer = 0 AND
                    CAN-FIND(FIRST tt-prog-ponto-tmp                                
                             WHERE tt-prog-ponto-tmp.conteudo = cli-difer.cc-codigo 
                               AND tt-prog-ponto-tmp.ponto    = 4) THEN DO:
    
                    ASSIGN x-cli-difer     = cli-difer.cod-emitente
                           c-nr-nota-fis   = IF AVAIL tt-notaOrigem THEN tt-notaOrigem.nr-nota-fis ELSE ""
                           c-obs-cli-difer = cli-difer.descricao.
                END.
            END.
            /***************************************************/
            IF l-ativa-log  THEN
                PUT "7" SKIP.   
      
            ASSIGN l-it-dep-fat = NO.
    
            IF l-centrais THEN DO:
                FIND FIRST item-uni-estab NO-LOCK                             WHERE
                           item-uni-estab.it-codigo   = it-pre-fat.it-codigo  AND
                           item-uni-estab.cod-estabel = pre-fatur.cod-estabel AND
                           item-uni-estab.nr-linha    = 20 NO-ERROR.
                IF NOT AVAIL item-uni-estab THEN 
                    NEXT.
            END.
            ELSE DO:
                FIND FIRST item-uni-estab NO-LOCK                             WHERE
                           item-uni-estab.it-codigo   = it-pre-fat.it-codigo  AND
                           item-uni-estab.cod-estabel = pre-fatur.cod-estabel NO-ERROR.          
                IF AVAIL item-uni-estab               AND
                         item-uni-estab.nr-linha = 20 THEN
                    NEXT.

                IF l-ativa-log  THEN
                    PUT "8" SKIP.   

    
                FOR EACH it-dep-fat USE-INDEX ch-deposito NO-LOCK          WHERE
                         it-dep-fat.cdd-embarq   = it-pre-fat.cdd-embarq   AND
                         it-dep-fat.nr-resumo    = it-pre-fat.nr-resumo    AND
                         it-dep-fat.nome-abrev   = it-pre-fat.nome-abrev   AND
                         it-dep-fat.nr-pedcli    = it-pre-fat.nr-pedcli    AND
                         it-dep-fat.nr-sequencia = it-pre-fat.nr-sequencia AND
                         it-dep-fat.nr-entrega   = it-pre-fat.nr-entrega   AND
                         it-dep-fat.it-codigo    = it-pre-fat.it-codigo:
    
                    IF l-ativa-log  THEN
                        PUT "9" SKIP.   

                      
                    IF pre-fatur.nat-operacao BEGINS "7":U THEN DO:
                        FIND FIRST emitente
                            WHERE emitente.nome-abrev = pre-fatur.nome-abrev NO-LOCK NO-ERROR.
    
                        IF AVAILABLE emitente THEN DO:
                            FIND FIRST int-emitente
                                WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    
                            IF AVAILABLE int-emitente              AND
                               int-emitente.tipo-embalagem <> "":U THEN DO:
                                FIND FIRST embalag
                                    WHERE embalag.embalagem = int-emitente.tipo-embalagem NO-LOCK NO-ERROR.
    
                                IF AVAILABLE embalag THEN
                                    FIND FIRST item-caixa
                                        WHERE item-caixa.it-codigo  = it-dep-fat.it-codigo
                                          AND item-caixa.fm-codigo  = ?
                                          AND item-caixa.fm-cod-com = ?
                                          AND item-caixa.sigla-emb BEGINS embalag.sigla-emb NO-LOCK NO-ERROR.
                            END.
                            ELSE DO:
                                FIND FIRST item-caixa
                                    WHERE item-caixa.it-codigo  = it-dep-fat.it-codigo
                                      AND item-caixa.fm-codigo  = ?
                                      AND item-caixa.fm-cod-com = ?
                                      AND item-caixa.sigla-emb BEGINS "E":U NO-LOCK NO-ERROR.
    
                                FIND FIRST embalag
                                    WHERE embalag.sigla-emb = item-caixa.sigla-emb NO-LOCK NO-ERROR.
    
                                IF NOT AVAILABLE embalag THEN DO:
                                    FOR EACH embalag
                                        WHERE embalag.embalagem BEGINS "EMB":U
                                          AND embalag.emite-roman
                                        BREAK BY embalag.volume:
                                        FIND FIRST item-caixa
                                            WHERE item-caixa.it-codigo  = it-dep-fat.it-codigo
                                              AND item-caixa.fm-codigo  = ?
                                              AND item-caixa.fm-cod-com = ?
                                              AND item-caixa.sigla-emb BEGINS embalag.sigla-emb NO-LOCK NO-ERROR.
                                    END.
                                END.    
                            END.
                        END.

                        IF l-ativa-log  THEN
                            PUT "10" SKIP.   

    
                        IF AVAILABLE item-caixa THEN DO:
                            IF tt-param.tipo-volume                            = 1 AND
                               it-dep-fat.qt-alocada MODULO item-caixa.qt-item = 0 THEN NEXT.
    
                            IF tt-param.tipo-volume                             = 2 AND
                               it-dep-fat.qt-alocada MODULO item-caixa.qt-item <> 0 AND
                               it-dep-fat.qt-alocada < item-caixa.qt-item           THEN NEXT.
                        END.
                    END.
                    ELSE DO:
                        FIND FIRST item-caixa
                            WHERE item-caixa.it-codigo  = it-dep-fat.it-codigo
                              AND item-caixa.fm-codigo  = ?
                              AND item-caixa.fm-cod-com = ?
                              AND item-caixa.sigla-emb  >= "N" NO-LOCK NO-ERROR.
    
                        IF NOT AVAILABLE item-caixa THEN DO:
                            FIND FIRST item-caixa
                                  WHERE item-caixa.it-codigo  = it-dep-fat.it-codigo
                                    AND item-caixa.fm-codigo  = ?
                                    AND item-caixa.fm-cod-com = ?
                                    AND item-caixa.sigla-emb BEGINS "E":U NO-LOCK NO-ERROR.
    
                        END.
                        IF AVAILABLE item-caixa THEN DO:
                            IF tt-param.tipo-volume                            = 1 AND
                               it-dep-fat.qt-alocada MODULO item-caixa.qt-item = 0 THEN NEXT.
    
                            IF tt-param.tipo-volume                             = 2 AND
                               it-dep-fat.qt-alocada MODULO item-caixa.qt-item <> 0 AND
                               it-dep-fat.qt-alocada < item-caixa.qt-item           THEN NEXT.
                        END.
                        IF tt-param.tipo-volume = 2 AND
                           NOT AVAIL item-caixa THEN NEXT.
                            
                    END.
    

                    IF l-ativa-log  THEN
                        PUT "11" SKIP.   

                    ASSIGN l-it-dep-fat = YES.

                    FIND FIRST tt-item                                                                                               WHERE
                               tt-item.separa-mg    = lSepara-mg                                                                     AND
                               tt-item.nome-transp  = (IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp) AND
                               tt-item.it-codigo    = it-dep-fat.it-codigo                                                           AND
                               tt-item.cod-refer    = it-dep-fat.cod-refer                                                           AND
                               tt-item.deposito     = it-dep-fat.cod-depos                                                           AND
                               tt-item.localizacao  = SUBSTRING(it-dep-fat.cod-localiz,1,10)                                         AND
                               tt-item.nr-serie     = it-dep-fat.nr-serlot                                                           AND
                               tt-item.cod-cli-dif  = x-cli-difer                                                                    AND 
                               tt-item.nr-nota-fis  = c-nr-nota-fis                                                                  NO-ERROR.
                    IF NOT AVAILABLE tt-item THEN DO:

                        CREATE tt-item.
                        ASSIGN tt-item.separa-mg     = lSepara-mg
                               tt-item.nome-transp   = IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp
                               tt-item.estado        = IF AVAIL tt-notaOrigem THEN tt-notaOrigem.estado      ELSE ped-venda.estado
                               tt-item.it-codigo     = it-dep-fat.it-codigo
                               tt-item.cod-refer     = it-dep-fat.cod-refer
                               tt-item.deposito      = it-dep-fat.cod-depos
                               tt-item.pedido        = it-dep-fat.nr-pedcli
                               tt-item.localizacao   = SUBSTRING(it-dep-fat.cod-localiz,1,10)
                               tt-item.nr-serie      = it-dep-fat.nr-serlot
                               tt-item.qt-alocada    = IF NOT AVAILABLE item-caixa OR tt-param.tipo-volume = 3 THEN it-dep-fat.qt-alocada ELSE (IF tt-param.tipo-volume = 1 THEN it-dep-fat.qt-alocada MODULO item-caixa.qt-item ELSE it-dep-fat.qt-alocada - (it-dep-fat.qt-alocada MODULO item-caixa.qt-item)) /*it-dep-fat.qt-alocada*/
                               tt-item.cod-cli-dif   = x-cli-difer
                               tt-item.nr-nota-fis   = c-nr-nota-fis
                               tt-item.nota-classif  = IF can-find(FIRST filial-cliente WHERE filial-cliente.cnpj = nota-fiscal.cgc) THEN c-nr-nota-fis ELSE ""
                               tt-item.qt-item       = IF AVAIL item-caixa THEN item-caixa.qt-item ELSE 0
                               tt-item.obs-cli-difer = c-obs-cli-difer.

                        FIND ITEM NO-LOCK WHERE 
                             ITEM.it-codigo = tt-item.it-codigo NO-ERROR.
                        IF AVAILABLE ITEM THEN
                            ASSIGN tt-item.desc-item    = ITEM.desc-item
                                   tt-item.un           = ITEM.un.
    
                        /* Sequància do Item na impress∆o */
                        FIND FIRST seq-item NO-LOCK
                            WHERE  seq-item.it-codigo = tt-item.it-codigo NO-ERROR.
                        IF  tt-param.ordenacao-item THEN
                            ASSIGN tt-item.sequencia = IF AVAIL seq-item THEN seq-item.sequencia ELSE 999999.
                        ELSE
                            ASSIGN tt-item.sequencia = 0.
                    END.
                    ELSE
                        ASSIGN tt-item.qt-alocada = tt-item.qt-alocada + (IF NOT AVAILABLE item-caixa OR tt-param.tipo-volume = 3 THEN it-dep-fat.qt-alocada ELSE (IF tt-param.tipo-volume = 1 THEN it-dep-fat.qt-alocada MODULO item-caixa.qt-item ELSE it-dep-fat.qt-alocada - (it-dep-fat.qt-alocada MODULO item-caixa.qt-item))) /*it-dep-fat.qt-alocada*/ .
                END.  /* it-dep-fat */
            END. /* else do */
    
            IF NOT l-it-dep-fat THEN DO:
                
                IF pre-fatur.nat-operacao BEGINS "7":U THEN DO:
                    FIND FIRST emitente
                        WHERE emitente.nome-abrev = pre-fatur.nome-abrev NO-LOCK NO-ERROR.
    
                    IF AVAILABLE emitente THEN DO:
                        FIND FIRST int-emitente
                            WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    
                        IF AVAILABLE int-emitente              AND
                           int-emitente.tipo-embalagem <> "":U THEN DO:
                            FIND FIRST embalag
                                WHERE embalag.embalagem = int-emitente.tipo-embalagem NO-LOCK NO-ERROR.
    
                            IF AVAILABLE embalag THEN
                                FIND FIRST item-caixa
                                    WHERE item-caixa.it-codigo  = it-pre-fat.it-codigo
                                      AND item-caixa.fm-codigo  = ?
                                      AND item-caixa.fm-cod-com = ?
                                      AND item-caixa.sigla-emb BEGINS embalag.sigla-emb NO-LOCK NO-ERROR.
                        END.
                        ELSE DO:
                            FIND FIRST item-caixa
                                WHERE item-caixa.it-codigo  = it-pre-fat.it-codigo
                                  AND item-caixa.fm-codigo  = ?
                                  AND item-caixa.fm-cod-com = ?
                                  AND item-caixa.sigla-emb BEGINS "E":U NO-LOCK NO-ERROR.
    
                            FIND FIRST embalag
                                WHERE embalag.sigla-emb = item-caixa.sigla-emb NO-LOCK NO-ERROR.
    
                            IF NOT AVAILABLE embalag THEN DO:
                                FOR EACH embalag
                                    WHERE embalag.embalagem BEGINS "EMB":U
                                      AND embalag.emite-roman
                                    BREAK BY embalag.volume:
                                    FIND FIRST item-caixa
                                        WHERE item-caixa.it-codigo  = it-pre-fat.it-codigo
                                          AND item-caixa.fm-codigo  = ?
                                          AND item-caixa.fm-cod-com = ?
                                          AND item-caixa.sigla-emb BEGINS embalag.sigla-emb NO-LOCK NO-ERROR.
                                END.
                            END.
                        END.
                    END.
    
                    IF AVAILABLE item-caixa THEN DO:
                        IF tt-param.tipo-volume                            = 1 AND
                           it-pre-fat.qt-alocada MODULO item-caixa.qt-item = 0 THEN NEXT.
    
                        IF tt-param.tipo-volume                             = 2 AND
                           it-pre-fat.qt-alocada MODULO item-caixa.qt-item <> 0 AND
                           it-pre-fat.qt-alocada < item-caixa.qt-item           THEN NEXT.
                    END.
                END.
                ELSE DO:
                    FIND FIRST item-caixa
                        WHERE item-caixa.it-codigo  = it-pre-fat.it-codigo
                          AND item-caixa.fm-codigo  = ?
                          AND item-caixa.fm-cod-com = ?
                          AND item-caixa.sigla-emb  >= "N" NO-LOCK NO-ERROR.
    
                    IF NOT AVAIL item-caixa THEN DO:
                        FIND FIRST item-caixa
                                WHERE item-caixa.it-codigo  = it-pre-fat.it-codigo
                                  AND item-caixa.fm-codigo  = ?
                                  AND item-caixa.fm-cod-com = ?
                                  AND item-caixa.sigla-emb BEGINS "E":U NO-LOCK NO-ERROR.
    
                    END.
                    IF AVAILABLE item-caixa THEN DO:
                        IF tt-param.tipo-volume                            = 1 AND
                           it-pre-fat.qt-alocada MODULO item-caixa.qt-item = 0 THEN NEXT.
    
                        IF tt-param.tipo-volume                             = 2 AND
                           it-pre-fat.qt-alocada MODULO item-caixa.qt-item <> 0 AND
                           it-pre-fat.qt-alocada < item-caixa.qt-item           THEN NEXT.
                    END.
    
                    IF tt-param.tipo-volume = 2 AND
                       NOT AVAIL item-caixa THEN NEXT.
                END.
    
                ASSIGN c-cod-depos = "".
                FOR EACH fat-ser-lote
                    WHERE fat-ser-lote.cod-estabel = tt-notaOrigem.cod-estabel
                      AND fat-ser-lote.serie       = tt-notaOrigem.serie
                      AND fat-ser-lote.nr-nota-fis = tt-notaOrigem.nr-nota-fis
                      AND fat-ser-lote.it-codigo   = it-pre-fat.it-codigo
                      AND fat-ser-lote.cod-refer   = it-pre-fat.cod-refer NO-LOCK:
                    ASSIGN c-cod-depos = c-cod-depos  + fat-ser-lote.cod-depos + ",".
                END.
    
                IF NOT l-centrais THEN DO:

                    IF tt-param.l-class THEN DO:
                        FIND FIRST tt-item                                                                                               WHERE
                                   tt-item.nome-transp  = (IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp) AND
                                   tt-item.estado       = (IF AVAIL tt-notaOrigem THEN tt-notaOrigem.estado      ELSE ped-venda.estado)      AND
                                   tt-item.it-codigo    = it-pre-fat.it-codigo                                                           AND
                                   tt-item.cod-refer    = it-pre-fat.cod-refer                                                           AND
                                   tt-item.deposito     = c-cod-depos                                                                    AND
                                   tt-item.cod-cli-dif  = x-cli-difer                                                                    AND
                                   tt-item.nr-nota-fis  = c-nr-nota-fis                                                                  NO-ERROR.
                    END.
                    ELSE DO:
                        FIND FIRST tt-item                                                                                               WHERE
                                   tt-item.nome-transp  = (IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp) AND
                                 /*tt-item.estado       = tt-notaOrigem.estado                                                             AND */
                                   tt-item.it-codigo    = it-pre-fat.it-codigo                                                           AND
                                   tt-item.cod-refer    = it-pre-fat.cod-refer                                                           AND
                                   tt-item.deposito     = c-cod-depos                                                                    AND
                                   tt-item.cod-cli-dif  = x-cli-difer                                                                    AND
                                   tt-item.nr-nota-fis  = c-nr-nota-fis                                                                  NO-ERROR.
                    END.
    
                    IF NOT AVAILABLE tt-item THEN DO:
                        CREATE tt-item.
                        ASSIGN tt-item.separa-mg     = lSepara-mg
                               tt-item.nome-transp   = IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp
                               tt-item.estado        = IF tt-param.l-class  THEN (IF AVAIL tt-notaOrigem THEN tt-notaOrigem.estado ELSE ped-venda.estado) ELSE ""
                               tt-item.it-codigo     = it-pre-fat.it-codigo
                               tt-item.cod-refer     = it-pre-fat.cod-refer
                               tt-item.deposito      = c-cod-depos
                               tt-item.pedido        = it-pre-fat.nr-pedcli
                               tt-item.qt-alocada    = IF NOT AVAILABLE item-caixa OR tt-param.tipo-volume = 3 THEN it-pre-fat.qt-alocada ELSE (IF tt-param.tipo-volume = 1 THEN it-pre-fat.qt-alocada MODULO item-caixa.qt-item ELSE it-pre-fat.qt-alocada - (it-pre-fat.qt-alocada MODULO item-caixa.qt-item)) /*it-pre-fat.qt-alocada*/
                               tt-item.cod-cli-dif   = x-cli-difer
                               tt-item.nr-nota-fis   = c-nr-nota-fis
                               tt-item.nota-classif  = IF can-find(FIRST filial-cliente WHERE filial-cliente.cnpj = nota-fiscal.cgc) THEN c-nr-nota-fis ELSE ""
                               tt-item.qt-item       = IF AVAIL item-caixa THEN item-caixa.qt-item ELSE 0
                               tt-item.obs-cli-difer = c-obs-cli-difer.

                        FIND ITEM NO-LOCK WHERE
                             ITEM.it-codigo = tt-item.it-codigo NO-ERROR.
                        IF  AVAILABLE ITEM THEN
                            ASSIGN tt-item.desc-item    = ITEM.desc-item
                                   tt-item.un           = ITEM.un.
    
                        /* Sequància do Item na impress∆o */
                        FIND FIRST seq-item NO-LOCK
                            WHERE  seq-item.it-codigo = tt-item.it-codigo NO-ERROR.
                        IF  tt-param.ordenacao-item THEN
                            ASSIGN tt-item.sequencia = IF AVAIL seq-item THEN seq-item.sequencia ELSE 999999.
                        ELSE
                            ASSIGN tt-item.sequencia = 0.
                    END.
                    ELSE
                        ASSIGN tt-item.qt-alocada = tt-item.qt-alocada + (IF NOT AVAILABLE item-caixa OR tt-param.tipo-volume = 3 THEN it-pre-fat.qt-alocada ELSE (IF tt-param.tipo-volume = 1 THEN it-pre-fat.qt-alocada MODULO item-caixa.qt-item ELSE it-pre-fat.qt-alocada - (it-pre-fat.qt-alocada MODULO item-caixa.qt-item))) /*it-pre-fat.qt-alocada*/ .
                END.
                ELSE DO:
                    FOR EACH estrutura NO-LOCK                              WHERE
                             estrutura.it-codigo     = it-pre-fat.it-codigo AND
                             estrutura.data-inicio  <= TODAY                AND
                             estrutura.data-termino >= TODAY:
    
                        IF tt-param.l-class THEN DO:
                            FIND FIRST tt-item                                                                                               WHERE
                                       tt-item.separa-mg    = lSepara-mg                                                                     AND
                                       tt-item.nome-transp  = (IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp) AND 
                                       tt-item.estado       = (IF AVAIL tt-notaOrigem THEN tt-notaOrigem.estado      ELSE ped-venda.estado)      AND 
                                       tt-item.it-codigo    = estrutura.es-codigo                                                            AND
                                       tt-item.cod-refer    = ""                                                                             AND
                                       tt-item.deposito     = c-cod-depos                                                                    AND
                                       tt-item.cod-cli-dif  = x-cli-difer                                                                    AND
                                       tt-item.nr-nota-fis  = c-nr-nota-fis                                                                  NO-ERROR.
                        END.
                        ELSE DO:
                            FIND FIRST tt-item                                                                                               WHERE
                                       tt-item.separa-mg    = lSepara-mg                                                                     AND
                                       tt-item.nome-transp  = (IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp) AND
                                     /*tt-item.estado       = tt-notaOrigem.estado                                                             AND */
                                       tt-item.it-codigo    = estrutura.es-codigo                                                            AND
                                       tt-item.cod-refer    = ""                                                                             AND
                                       tt-item.deposito     = c-cod-depos                                                                    AND
                                       tt-item.cod-cli-dif  = x-cli-difer                                                                    AND
                                       tt-item.nr-nota-fis  = c-nr-nota-fis                                                                  NO-ERROR.
                        END.
    
                        IF NOT AVAILABLE tt-item THEN DO:
                           
                            CREATE tt-item.
                            ASSIGN tt-item.nome-transp   = IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp
                                   tt-item.estado        = IF tt-param.l-class  THEN (IF AVAIL tt-notaOrigem THEN tt-notaOrigem.estado ELSE ped-venda.estado) ELSE ""  
                                   tt-item.it-codigo     = estrutura.es-codigo
                                   tt-item.cod-refer     = ""
                                   tt-item.deposito      =  c-cod-depos 
                                   tt-item.pedido        = it-pre-fat.nr-pedcli
                                   tt-item.qt-alocada    = ((IF NOT AVAILABLE item-caixa OR tt-param.tipo-volume = 3 THEN it-pre-fat.qt-alocada ELSE (IF tt-param.tipo-volume = 1 THEN it-pre-fat.qt-alocada MODULO item-caixa.qt-item ELSE it-pre-fat.qt-alocada - (it-pre-fat.qt-alocada MODULO item-caixa.qt-item))) /*it-pre-fat.qt-alocada*/ * estrutura.quant-usada)
                                   tt-item.cod-cli-dif   = x-cli-difer
                                   tt-item.nr-nota-fis   = c-nr-nota-fis
                                   tt-item.nota-classif  = IF can-find(FIRST filial-cliente WHERE filial-cliente.cnpj = nota-fiscal.cgc) THEN c-nr-nota-fis ELSE ""
                                   tt-item.qt-item       = IF AVAIL item-caixa THEN item-caixa.qt-item ELSE 0
                                   tt-item.obs-cli-difer = c-obs-cli-difer.

                            FIND ITEM NO-LOCK WHERE
                                 ITEM.it-codigo = tt-item.it-codigo NO-ERROR.
                            IF AVAILABLE ITEM THEN
                                ASSIGN tt-item.desc-item    = ITEM.desc-item
                                       tt-item.un           = ITEM.un.
    
                            /* Sequància do Item na impress∆o */
                            FIND FIRST seq-item NO-LOCK
                                WHERE  seq-item.it-codigo = tt-item.it-codigo NO-ERROR.
                            IF  tt-param.ordenacao-item THEN
                                ASSIGN tt-item.sequencia = IF AVAIL seq-item THEN seq-item.sequencia ELSE 999999.
                            ELSE
                                ASSIGN tt-item.sequencia = 0.
                        END.
                        ELSE
                            ASSIGN tt-item.qt-alocada = tt-item.qt-alocada + ((IF NOT AVAILABLE item-caixa OR tt-param.tipo-volume = 3 THEN it-pre-fat.qt-alocada ELSE (IF tt-param.tipo-volume = 1 THEN it-pre-fat.qt-alocada MODULO item-caixa.qt-item ELSE it-pre-fat.qt-alocada - (it-pre-fat.qt-alocada MODULO item-caixa.qt-item))) /*it-pre-fat.qt-alocada*/ * estrutura.quant-usada).
                    END. /* each estrutura */
                END.
            END. /* NOT l-it-dep-fat */
    
            IF NOT tt-param.reimpressao THEN DO:
                FIND FIRST tt-pre-fatur NO-LOCK                              WHERE
                           tt-pre-fatur.nr-embarque  = pre-fatur.cdd-embarq AND
                           tt-pre-fatur.nr-resumo    = pre-fatur.nr-resumo   AND
                           tt-pre-fatur.nome-abrev   = pre-fatur.nome-abrev  AND
                           tt-pre-fatur.nr-pedcli    = pre-fatur.nr-pedcli   NO-ERROR.
    
                IF NOT AVAILABLE tt-pre-fatur THEN DO:
                    /* PUT 10
                        SKIP. */
                    CREATE tt-pre-fatur.
                    ASSIGN tt-pre-fatur.nr-embarque  = pre-fatur.cdd-embarq
                           tt-pre-fatur.nr-resumo    = pre-fatur.nr-resumo
                           tt-pre-fatur.nome-abrev   = pre-fatur.nome-abrev
                           tt-pre-fatur.nr-pedcli    = pre-fatur.nr-pedcli.
                END.
            END.
    
            IF NOT CAN-FIND(ttEmbarques                                                                                              WHERE
                            ttEmbarques.separa-mg   = lSepara-mg                                                                     AND
                            ttEmbarques.nome-transp = (IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp) AND
                            ttEmbarques.estado      = (IF AVAIL tt-notaOrigem THEN tt-notaOrigem.estado      ELSE ped-venda.estado)      AND
                            ttEmbarques.nr-embarque = pre-fatur.cdd-embarq                                                          AND
                            ttEmbarques.cod-cli-dif = x-cli-difer)                                                                   THEN DO:
                                /* PUT 11
                                    SKIP. */
               CREATE ttEmbarques.
               ASSIGN ttEmbarques.separa-mg   = lSepara-mg
                      ttEmbarques.nome-transp = IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp 
                      ttEmbarques.estado      = IF AVAIL tt-notaOrigem THEN tt-notaOrigem.estado      ELSE ped-venda.estado      
                      ttEmbarques.nr-embarque = pre-fatur.cdd-embarq
                      ttEmbarques.cod-cli-dif = x-cli-difer.
            END.

            IF NOT CAN-FIND(ttnota-fiscal                                        WHERE
                            ttNota-fiscal.separa-mg   = lSepara-mg               AND 
                            ttNota-fiscal.cod-estabel = tt-notaOrigem.cod-estabel  AND 
                            ttNota-fiscal.serie       = tt-notaOrigem.serie        AND 
                            ttNota-fiscal.nr-nota-fis = tt-notaOrigem.nr-nota-fis) THEN DO:

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

END.
/*****************************************************/
/**********  Sem Transportadora informada  ***********/
ELSE DO:

    FOR EACH pre-fatur USE-INDEX ch-embarque NO-LOCK              WHERE
             pre-fatur.pick-impresso   = tt-param.reimpressao     AND
          /* pre-fatur.cod-sit-pre     <> 1                        AND  */
             pre-fatur.cdd-embarq     >= tt-param.nr-embarque-ini AND
             pre-fatur.cdd-embarq     <= tt-param.nr-embarque-end AND
             pre-fatur.nr-resumo      >= tt-param.nr-resumo-ini   AND
             pre-fatur.nr-resumo      <= tt-param.nr-resumo-end,
        /*validaá∆o da transportadora passa a ser na NF pois ela j† esta gerada e pode ser alterada na nota*/
        EACH it-pre-fat NO-LOCK OF pre-fatur:

        IF tt-param.rastreabilidade = 1 THEN DO:
            FIND FIRST tt-item-rast
                WHERE tt-item-rast.it-codigo = it-pre-fat.it-codigo NO-ERROR.

            IF NOT AVAILABLE tt-item-rast THEN NEXT.
        END.
        ELSE IF tt-param.rastreabilidade = 2 THEN DO:
            FIND FIRST tt-item-rast
                WHERE tt-item-rast.it-codigo = it-pre-fat.it-codigo NO-ERROR.

            IF AVAILABLE tt-item-rast THEN NEXT.
        END.

        ASSIGN c-transp = "".

        IF pre-fatur.nr-pedcli <> "" THEN DO:
            blk_nota:
            FOR EACH it-nota-fisc NO-LOCK
                WHERE it-nota-fisc.nome-ab-cli = pre-fatur.nome-abrev
                  AND it-nota-fisc.nr-pedcli   = pre-fatur.nr-pedcli:

                FOR FIRST nota-fiscal OF it-nota-fisc NO-LOCK
                WHERE nota-fiscal.cdd-embarq     = pre-fatur.cdd-embarq
                  AND nota-fiscal.nr-resumo      = pre-fatur.nr-resumo
                  AND nota-fiscal.dt-cancela     = ?:

                    ASSIGN c-transp = nota-fiscal.nome-transp.
                    LEAVE blk_nota.
                END.
            END.
        
            FIND natur-oper
                WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-LOCK NO-ERROR.
            IF AVAIL natur-oper AND natur-oper.log-oper-triang THEN DO:
    
                FOR FIRST b-nota-fiscal NO-LOCK                                  WHERE 
                          b-nota-fiscal.cdd-embarq     = pre-fatur.cdd-embarq    AND
                          b-nota-fiscal.nr-resumo      = pre-fatur.nr-resumo     AND
                          b-nota-fiscal.nome-ab-cli    = nota-fiscal.nome-abrev  AND
                          b-nota-fiscal.nr-pedcli      = ""                      AND                            
                          b-nota-fiscal.cod-estabel    = tt-param.cod-estabel   AND
                          b-nota-fiscal.dt-cancela     = ?:
                    ASSIGN c-transp = b-nota-fiscal.nome-transp.
                END. 
    
            END.
        END.
        IF AVAIL b-nota-fiscal THEN DO:

            FIND FIRST tt-notaOrigem
                WHERE tt-notaOrigem.cod-estabel  = b-nota-fiscal.cod-estabel 
                  AND tt-notaOrigem.serie        = b-nota-fiscal.serie       
                  AND tt-notaOrigem.nr-nota-fis  = b-nota-fiscal.nr-nota-fis  EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAIL tt-notaOrigem THEN DO:
                /* PUT 13
                    SKIP. */
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
                       tt-notaOrigem.nome-abrev   = b-nota-fiscal.nome-abrev.
            END. /*  IF NOT AVAIL tt-notaOrigem THEN DO: */

        END. /* IF AVAIL b-nota-fiscal THEN DO: */
        ELSE DO:

            IF AVAIL nota-fiscal THEN DO:

                FIND FIRST tt-notaOrigem
                    WHERE tt-notaOrigem.cod-estabel  = nota-fiscal.cod-estabel 
                      AND tt-notaOrigem.serie        = nota-fiscal.serie       
                      AND tt-notaOrigem.nr-nota-fis  = nota-fiscal.nr-nota-fis  EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAIL tt-notaOrigem THEN DO:
                    /* PUT 14
                        SKIP. */
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
                           tt-notaOrigem.nome-abrev   = nota-fiscal.nome-abrev.
                END. /*  IF NOT AVAIL tt-notaOrigem THEN DO: */

            END. /* IF AVAIL nota-fiscal THEN DO: */

        END. /* IF NOT AVAIL b-nota-fiscal THEN DO: */

        FIND CURRENT tt-notaOrigem NO-LOCK NO-ERROR.
        IF AVAIL tt-notaOrigem THEN DO:

            IF  NOT AVAIL tt-notaOrigem THEN NEXT.
    
            ASSIGN c-cod-depos = "".
            FOR EACH fat-ser-lote
                WHERE fat-ser-lote.cod-estabel = tt-notaOrigem.cod-estabel
                  AND fat-ser-lote.serie       = tt-notaOrigem.serie
                  AND fat-ser-lote.nr-nota-fis = tt-notaOrigem.nr-nota-fis
                  AND fat-ser-lote.it-codigo   = it-pre-fat.it-codigo
                  AND fat-ser-lote.cod-refer   = it-pre-fat.cod-refer NO-LOCK:
                ASSIGN c-cod-depos = c-cod-depos  + fat-ser-lote.cod-depos + ",".
            END.
    
            IF AVAIL tt-notaOrigem AND tt-param.notas-desconsiderar <> "" THEN DO:
                FIND FIRST tt-nota-des
                    WHERE INT(tt-nota-des.c-cod-nota-des-ini) <= INT(tt-notaOrigem.nr-nota-fis)
                      AND INT(tt-nota-des.c-cod-nota-des-fim) >= INT(tt-notaOrigem.nr-nota-fis) NO-LOCK NO-ERROR.
                IF AVAIL tt-nota-des THEN NEXT.
            END.
    
            FOR FIRST ped-venda NO-LOCK
                WHERE ped-venda.nr-pedcli  = pre-fatur.nr-pedcli
                  AND ped-venda.nome-abrev = pre-fatur.nome-abrev:
            END.
    
            IF  NOT AVAIL tt-notaOrigem AND 
                NOT AVAIL ped-venda   THEN NEXT.
    
            IF  AVAIL tt-notaOrigem THEN DO:
                FOR FIRST natur-oper NO-LOCK WHERE
                          natur-oper.nat-operacao    = tt-notaOrigem.nat-operacao:
                END.
               {esinc/es0004.i} /*ValidaNaturezasImpress∆oNFs*/
            END.
            ELSE DO:
                FOR FIRST natur-oper NO-LOCK WHERE
                          natur-oper.nat-operacao    = IF AVAIL tt-notaOrigem THEN tt-notaOrigem.nat-operacao ELSE ped-venda.nat-operacao:
                END.
                {esinc/es0004a.i} /*ValidaNaturezasImpress∆oNFs*/
            END.
    
            IF AVAIL tt-notaOrigem THEN DO:
                IF  tt-notaOrigem.nome-transp = "Malote" OR
                    tt-notaOrigem.nome-transp = "Retira" THEN NEXT.
            END.
            ELSE
                IF  ped-venda.nome-transp = "Malote" OR
                    ped-venda.nome-transp = "Retira" THEN NEXT.
    
            IF tt-param.l-estado THEN 
                IF NOT CAN-FIND(tt-estado WHERE
                                tt-estado.estado = IF AVAIL tt-notaOrigem THEN tt-notaOrigem.estado ELSE ped-venda.estado) THEN 
                    NEXT.
    
            RUN defineAstec.
/*             IF l-retorno-astec THEN NEXT. */

            /********* Achar Cliente diferenciado *************/ 
            ASSIGN x-cli-difer = 0
                   c-nr-nota-fis = ""
                   c-obs-cli-difer = "".
            
            FOR EACH cli-difer NO-LOCK 
                WHERE cli-difer.cod-emitente = IF AVAIL tt-notaOrigem THEN tt-notaOrigem.cod-emitente ELSE ped-venda.cod-emitente:
    
                IF x-cli-difer = 0 AND
                    CAN-FIND(FIRST tt-prog-ponto-tmp                                WHERE
                                   tt-prog-ponto-tmp.conteudo = cli-difer.cc-codigo AND 
                                   tt-prog-ponto-tmp.ponto = 4)                     THEN DO:
    
                    ASSIGN x-cli-difer = cli-difer.cod-emitente
                           c-nr-nota-fis = IF AVAIL tt-notaOrigem THEN tt-notaOrigem.nr-nota-fis ELSE ""
                           c-obs-cli-difer = cli-difer.descricao.
                END.
            END.
            /***************************************************/

            ASSIGN l-it-dep-fat = NO.
    
            IF l-centrais THEN DO:
                FIND FIRST item-uni-estab NO-LOCK                             WHERE
                           item-uni-estab.it-codigo   = it-pre-fat.it-codigo  AND
                           item-uni-estab.cod-estabel = pre-fatur.cod-estabel AND
                           item-uni-estab.nr-linha    = 20 NO-ERROR.
                IF NOT AVAIL item-uni-estab THEN 
                    NEXT.
            END.
            ELSE DO:
                FIND FIRST item-uni-estab NO-LOCK                             WHERE
                           item-uni-estab.it-codigo   = it-pre-fat.it-codigo  AND
                           item-uni-estab.cod-estabel = pre-fatur.cod-estabel NO-ERROR.
                IF AVAIL item-uni-estab AND
                         item-uni-estab.nr-linha = 20 THEN 
                    NEXT.
    
                FOR EACH it-dep-fat USE-INDEX ch-deposito NO-LOCK          WHERE
                         it-dep-fat.cdd-embarq  = it-pre-fat.cdd-embarq    AND
                         it-dep-fat.nr-resumo    = it-pre-fat.nr-resumo    AND
                         it-dep-fat.nome-abrev   = it-pre-fat.nome-abrev   AND
                         it-dep-fat.nr-pedcli    = it-pre-fat.nr-pedcli    AND
                         it-dep-fat.nr-sequencia = it-pre-fat.nr-sequencia AND
                         it-dep-fat.nr-entrega   = it-pre-fat.nr-entrega   AND
                         it-dep-fat.it-codigo    = it-pre-fat.it-codigo:
    
                    
                    IF pre-fatur.nat-operacao BEGINS "7":U THEN DO:
                        FIND FIRST emitente
                            WHERE emitente.nome-abrev = pre-fatur.nome-abrev NO-LOCK NO-ERROR.
    
                        IF AVAILABLE emitente THEN DO:
                            FIND FIRST int-emitente
                                WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    
                            IF AVAILABLE int-emitente              AND
                               int-emitente.tipo-embalagem <> "":U THEN DO:
                                FIND FIRST embalag
                                    WHERE embalag.embalagem = int-emitente.tipo-embalagem NO-LOCK NO-ERROR.
    
                                IF AVAILABLE embalag THEN
                                    FIND FIRST item-caixa
                                        WHERE item-caixa.it-codigo  = it-dep-fat.it-codigo
                                          AND item-caixa.fm-codigo  = ?
                                          AND item-caixa.fm-cod-com = ?
                                          AND item-caixa.sigla-emb BEGINS embalag.sigla-emb NO-LOCK NO-ERROR.
                            END.
                            ELSE DO:
                                FIND FIRST item-caixa
                                    WHERE item-caixa.it-codigo  = it-dep-fat.it-codigo
                                      AND item-caixa.fm-codigo  = ?
                                      AND item-caixa.fm-cod-com = ?
                                      AND item-caixa.sigla-emb BEGINS "E":U NO-LOCK NO-ERROR.
    
                                FIND FIRST embalag
                                    WHERE embalag.sigla-emb = item-caixa.sigla-emb NO-LOCK NO-ERROR.
    
                                IF NOT AVAILABLE embalag THEN DO:
                                    FOR EACH embalag
                                        WHERE embalag.embalagem BEGINS "EMB":U
                                          AND embalag.emite-roman
                                        BREAK BY embalag.volume:
                                        FIND FIRST item-caixa
                                            WHERE item-caixa.it-codigo  = it-dep-fat.it-codigo
                                              AND item-caixa.fm-codigo  = ?
                                              AND item-caixa.fm-cod-com = ?
                                              AND item-caixa.sigla-emb BEGINS embalag.sigla-emb NO-LOCK NO-ERROR.
                                    END.
                                END.
                            END.
                        END.
    
                        IF AVAILABLE item-caixa THEN DO:
                            IF tt-param.tipo-volume                            = 1 AND
                               it-dep-fat.qt-alocada MODULO item-caixa.qt-item = 0 THEN NEXT.
    
                            IF tt-param.tipo-volume                             = 2 AND
                               it-dep-fat.qt-alocada MODULO item-caixa.qt-item <> 0 AND
                               it-dep-fat.qt-alocada < item-caixa.qt-item           THEN NEXT.
                        END.
                    END.
                    ELSE DO:
                        FIND FIRST item-caixa
                            WHERE item-caixa.it-codigo  = it-dep-fat.it-codigo
                              AND item-caixa.fm-codigo  = ?
                              AND item-caixa.fm-cod-com = ?
                              AND item-caixa.sigla-emb  >= "N" NO-LOCK NO-ERROR.
    
                        IF NOT AVAILABLE item-caixa THEN DO:
                            FIND FIRST item-caixa
                                WHERE item-caixa.it-codigo  = it-pre-fat.it-codigo
                                  AND item-caixa.fm-codigo  = ?
                                  AND item-caixa.fm-cod-com = ?
                                  AND item-caixa.sigla-emb BEGINS "E":U NO-LOCK NO-ERROR.
    
                        END.
                        IF AVAILABLE item-caixa THEN DO:
                            IF tt-param.tipo-volume                            = 1 AND
                               it-dep-fat.qt-alocada MODULO item-caixa.qt-item = 0 THEN NEXT.
    
                            IF tt-param.tipo-volume                             = 2 AND
                               it-dep-fat.qt-alocada MODULO item-caixa.qt-item <> 0 AND
                               it-dep-fat.qt-alocada < item-caixa.qt-item           THEN NEXT.
                        END.
    
                        IF tt-param.tipo-volume = 2 AND
                           NOT AVAIL item-caixa THEN NEXT.
                    END.
    
                    
                    ASSIGN l-it-dep-fat = YES.
    
                    IF tt-param.l-class THEN DO:
                        FIND FIRST tt-item                                                        WHERE
                                   tt-item.separa-mg    = lSepara-mg                              AND
                                   tt-item.nome-transp  = (IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp) AND
                                   tt-item.estado       = (IF AVAIL tt-notaOrigem THEN tt-notaOrigem.estado      ELSE ped-venda.estado)      AND
                                   tt-item.it-codigo    = it-dep-fat.it-codigo                    AND
                                   tt-item.cod-refer    = it-dep-fat.cod-refer                    AND
                                   tt-item.deposito     = it-dep-fat.cod-depos                    AND
                                   tt-item.localizacao  = SUBSTRING(it-dep-fat.cod-localiz,1,10)  AND
                                   tt-item.nr-serie     = it-dep-fat.nr-serlot                    AND
                                   tt-item.cod-cli-dif  = x-cli-difer                             AND
                                   tt-item.nr-nota-fis  = c-nr-nota-fis                           NO-ERROR.
                    END.
                    ELSE DO:
                        FIND FIRST tt-item                                                        WHERE
                                   tt-item.separa-mg    = lSepara-mg                              AND
                                   tt-item.nome-transp  = (IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp) AND
                                   tt-item.it-codigo    = it-dep-fat.it-codigo                    AND
                                   tt-item.cod-refer    = it-dep-fat.cod-refer                    AND
                                   tt-item.deposito     = it-dep-fat.cod-depos                    AND
                                   tt-item.localizacao  = SUBSTRING(it-dep-fat.cod-localiz,1,10)  AND
                                   tt-item.nr-serie     = it-dep-fat.nr-serlot                    AND
                                   tt-item.cod-cli-dif  = x-cli-difer                             AND 
                                   tt-item.nr-nota-fis  = c-nr-nota-fis                           NO-ERROR.
                    END.
    
    
    
                    IF NOT AVAILABLE tt-item THEN DO:
                        /* PUT 15
                            SKIP. */

                        CREATE tt-item.
                        ASSIGN tt-item.separa-mg     = lSepara-mg
                               tt-item.nome-transp   = IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp
                               tt-item.estado        = IF tt-param.l-class THEN (IF AVAIL tt-notaOrigem THEN tt-notaOrigem.estado ELSE ped-venda.estado) ELSE ""
                               tt-item.it-codigo     = it-dep-fat.it-codigo
                               tt-item.cod-refer     = it-dep-fat.cod-refer
                               tt-item.deposito      = it-dep-fat.cod-depos
                               tt-item.localizacao   = SUBSTRING(it-dep-fat.cod-localiz,1,10)
                               tt-item.pedido        = it-dep-fat.nr-pedcli
                               tt-item.nr-serie      = it-dep-fat.nr-serlot
                               tt-item.qt-alocada    = IF NOT AVAILABLE item-caixa OR tt-param.tipo-volume = 3 THEN it-dep-fat.qt-alocada ELSE (IF tt-param.tipo-volume = 1 THEN it-dep-fat.qt-alocada MODULO item-caixa.qt-item ELSE it-dep-fat.qt-alocada - (it-dep-fat.qt-alocada MODULO item-caixa.qt-item)) /*it-dep-fat.qt-alocada*/
                               tt-item.cod-cli-dif   = x-cli-difer
                               tt-item.nr-nota-fis   = c-nr-nota-fis
                               tt-item.nota-classif  = IF can-find(FIRST filial-cliente WHERE filial-cliente.cnpj = nota-fiscal.cgc) THEN c-nr-nota-fis ELSE ""
                               tt-item.qt-item       = IF AVAIL item-caixa THEN item-caixa.qt-item ELSE 0
                               tt-item.obs-cli-difer = c-obs-cli-difer.

                        FIND ITEM NO-LOCK WHERE
                             ITEM.it-codigo = tt-item.it-codigo NO-ERROR.
                        IF AVAILABLE ITEM THEN
                           ASSIGN tt-item.desc-item    = ITEM.desc-item
                                  tt-item.un           = ITEM.un.
    
                        /* Sequància do Item na impress∆o */
                        FIND FIRST seq-item NO-LOCK
                            WHERE  seq-item.it-codigo = tt-item.it-codigo NO-ERROR.
                        IF  tt-param.ordenacao-item THEN
                            ASSIGN tt-item.sequencia = IF AVAIL seq-item THEN seq-item.sequencia ELSE 999999.
                        ELSE
                            ASSIGN tt-item.sequencia = 0.
                    END.
                    ELSE
                        ASSIGN tt-item.qt-alocada = tt-item.qt-alocada + (IF NOT AVAILABLE item-caixa OR tt-param.tipo-volume = 3 THEN it-dep-fat.qt-alocada ELSE (IF tt-param.tipo-volume = 1 THEN it-dep-fat.qt-alocada MODULO item-caixa.qt-item ELSE it-dep-fat.qt-alocada - (it-dep-fat.qt-alocada MODULO item-caixa.qt-item))) /*it-dep-fat.qt-alocada*/ .
                END.  /* it-dep-fat */
            END. /* else do */
    
            IF l-it-dep-fat = NO THEN DO:
    
                IF pre-fatur.nat-operacao BEGINS "7":U THEN DO:
                    FIND FIRST emitente
                        WHERE emitente.nome-abrev = pre-fatur.nome-abrev NO-LOCK NO-ERROR.
    
                    IF AVAILABLE emitente THEN DO:
                        FIND FIRST int-emitente
                            WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    
                        IF AVAILABLE int-emitente              AND
                           int-emitente.tipo-embalagem <> "":U THEN DO:
                            FIND FIRST embalag
                                WHERE embalag.embalagem = int-emitente.tipo-embalagem NO-LOCK NO-ERROR.
    
                            IF AVAILABLE embalag THEN
                                FIND FIRST item-caixa
                                    WHERE item-caixa.it-codigo  = it-pre-fat.it-codigo
                                      AND item-caixa.fm-codigo  = ?
                                      AND item-caixa.fm-cod-com = ?
                                      AND item-caixa.sigla-emb BEGINS embalag.sigla-emb NO-LOCK NO-ERROR.
                        END.
                        ELSE DO:
                            FIND FIRST item-caixa
                                WHERE item-caixa.it-codigo  = it-pre-fat.it-codigo
                                  AND item-caixa.fm-codigo  = ?
                                  AND item-caixa.fm-cod-com = ?
                                  AND item-caixa.sigla-emb BEGINS "E":U NO-LOCK NO-ERROR.
    
                            FIND FIRST embalag
                                WHERE embalag.sigla-emb = item-caixa.sigla-emb NO-LOCK NO-ERROR.
    
                            IF NOT AVAILABLE embalag THEN DO:
                                FOR EACH embalag
                                    WHERE embalag.embalagem BEGINS "EMB":U
                                      AND embalag.emite-roman
                                    BREAK BY embalag.volume:
                                    FIND FIRST item-caixa
                                        WHERE item-caixa.it-codigo  = it-pre-fat.it-codigo
                                          AND item-caixa.fm-codigo  = ?
                                          AND item-caixa.fm-cod-com = ?
                                          AND item-caixa.sigla-emb BEGINS embalag.sigla-emb NO-LOCK NO-ERROR.
                                END.
                            END.
                        END.
                    END.
    
                    IF AVAILABLE item-caixa THEN DO:
                        IF tt-param.tipo-volume                            = 1 AND
                           it-pre-fat.qt-alocada MODULO item-caixa.qt-item = 0 THEN NEXT.
    
                        IF tt-param.tipo-volume                             = 2 AND
                           it-pre-fat.qt-alocada MODULO item-caixa.qt-item <> 0 AND
                           it-pre-fat.qt-alocada < item-caixa.qt-item           THEN NEXT.
                    END.
                END.
                ELSE DO:
                    FIND FIRST item-caixa
                        WHERE item-caixa.it-codigo  = it-pre-fat.it-codigo
                          AND item-caixa.fm-codigo  = ?
                          AND item-caixa.fm-cod-com = ?
                          AND item-caixa.sigla-emb  >= "N" NO-LOCK NO-ERROR.
    
                    IF NOT AVAILABLE item-caixa THEN DO:
                        FIND FIRST item-caixa
                            WHERE item-caixa.it-codigo  = it-pre-fat.it-codigo
                              AND item-caixa.fm-codigo  = ?
                              AND item-caixa.fm-cod-com = ?
                              AND item-caixa.sigla-emb BEGINS "E":U NO-LOCK NO-ERROR.
    
                    END.
                    IF AVAILABLE item-caixa THEN DO:
                        IF tt-param.tipo-volume                            = 1 AND
                           it-pre-fat.qt-alocada MODULO item-caixa.qt-item = 0 THEN NEXT.
    
                        IF tt-param.tipo-volume                             = 2 AND
                           it-pre-fat.qt-alocada MODULO item-caixa.qt-item <> 0 AND
                           it-pre-fat.qt-alocada < item-caixa.qt-item           THEN NEXT.
                    END.
    
                    IF tt-param.tipo-volume = 2 AND
                       NOT AVAIL item-caixa THEN NEXT.
    
                END.
                
    
                IF l-centrais = NO THEN DO:
                    IF tt-param.l-class THEN DO:
                        FIND FIRST tt-item                                             WHERE
                                   tt-item.separa-mg    = lSepara-mg                   AND
                                   tt-item.nome-transp  = (IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp) AND
                                   tt-item.estado       = (IF AVAIL tt-notaOrigem THEN tt-notaOrigem.estado      ELSE ped-venda.estado)      AND
                                   tt-item.it-codigo    = it-pre-fat.it-codigo         AND
                                   tt-item.cod-refer    = it-pre-fat.cod-refer         AND
                                   tt-item.deposito     = c-cod-depos                  AND
                                   tt-item.cod-cli-dif  = x-cli-difer                  AND 
                                   tt-item.nr-nota-fis  = c-nr-nota-fis                NO-ERROR.
                    END.
                    ELSE DO:
                        FIND FIRST tt-item                                             WHERE
                                   tt-item.separa-mg    = lSepara-mg                   AND
                                   tt-item.nome-transp  = (IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp) AND
                                   tt-item.it-codigo    = it-pre-fat.it-codigo         AND
                                   tt-item.cod-refer    = it-pre-fat.cod-refer         AND
                                   tt-item.deposito     = c-cod-depos                  AND
                                   tt-item.cod-cli-dif  = x-cli-difer                  AND
                                   tt-item.nr-nota-fis  = c-nr-nota-fis                NO-ERROR.
                    END.
    
                    IF NOT AVAILABLE tt-item THEN DO:
                        /* PUT 16
                            SKIP. */

                       
                        CREATE tt-item.
                        ASSIGN tt-item.separa-mg     = lSepara-mg
                               tt-item.nome-transp   = (IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp)
                               tt-item.estado        = IF tt-param.l-class THEN (IF AVAIL tt-notaOrigem THEN tt-notaOrigem.estado ELSE ped-venda.estado) ELSE ""
                               tt-item.it-codigo     = it-pre-fat.it-codigo
                               tt-item.cod-refer     = it-pre-fat.cod-refer
                               tt-item.deposito      = c-cod-depos 
                               tt-item.pedido        = it-pre-fat.nr-pedcli
                               tt-item.qt-alocada    = IF NOT AVAILABLE item-caixa OR tt-param.tipo-volume = 3 THEN it-pre-fat.qt-alocada ELSE (IF tt-param.tipo-volume = 1 THEN it-pre-fat.qt-alocada MODULO item-caixa.qt-item ELSE it-pre-fat.qt-alocada - (it-pre-fat.qt-alocada MODULO item-caixa.qt-item)) /*it-pre-fat.qt-alocada*/
                               tt-item.cod-cli-dif   = x-cli-difer
                               tt-item.nr-nota-fis   = c-nr-nota-fis
                               tt-item.nota-classif  = IF can-find(FIRST filial-cliente WHERE filial-cliente.cnpj = nota-fiscal.cgc) THEN c-nr-nota-fis ELSE ""
                               tt-item.qt-item       = IF AVAIL item-caixa THEN item-caixa.qt-item ELSE 0
                               tt-item.obs-cli-difer = c-obs-cli-difer.

                        FIND ITEM NO-LOCK WHERE
                             ITEM.it-codigo = tt-item.it-codigo NO-ERROR.
                        IF AVAILABLE ITEM THEN
                            ASSIGN tt-item.desc-item = ITEM.desc-item
                                   tt-item.un        = ITEM.un.
    
                        /* Sequància do Item na impress∆o */
                        FIND FIRST seq-item NO-LOCK
                            WHERE  seq-item.it-codigo = tt-item.it-codigo NO-ERROR.
                        IF  tt-param.ordenacao-item THEN
                            ASSIGN tt-item.sequencia = IF AVAIL seq-item THEN seq-item.sequencia ELSE 999999.
                        ELSE
                            ASSIGN tt-item.sequencia = 0.
                    END.
                    ELSE
                        ASSIGN tt-item.qt-alocada = tt-item.qt-alocada + (IF NOT AVAILABLE item-caixa OR tt-param.tipo-volume = 3 THEN it-pre-fat.qt-alocada ELSE (IF tt-param.tipo-volume = 1 THEN it-pre-fat.qt-alocada MODULO item-caixa.qt-item ELSE it-pre-fat.qt-alocada - (it-pre-fat.qt-alocada MODULO item-caixa.qt-item))) /*it-pre-fat.qt-alocada*/ .
                END. /* IF l-centrais = NO THEN DO: */
                ELSE DO:
                    FOR EACH estrutura NO-LOCK                              WHERE
                             estrutura.it-codigo     = it-pre-fat.it-codigo AND
                             estrutura.data-inicio  <= TODAY                AND
                             estrutura.data-termino >= TODAY:
    
                        IF tt-param.l-class THEN DO:
                            FIND FIRST tt-item                                             WHERE
                                       tt-item.separa-mg    = lSepara-mg                   AND
                                       tt-item.nome-transp  = (IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp) AND
                                       tt-item.estado       = (IF AVAIL tt-notaOrigem THEN tt-notaOrigem.estado ELSE ped-venda.estado)           AND
                                       tt-item.it-codigo    = estrutura.es-codigo          AND
                                       tt-item.cod-refer    = ""                           AND
                                       tt-item.deposito     = c-cod-depos                  AND
                                       tt-item.cod-cli-dif  = x-cli-difer                  AND 
                                       tt-item.nr-nota-fis  = c-nr-nota-fis                NO-ERROR.
                        END.
                        ELSE DO:
                            FIND FIRST tt-item                                             WHERE
                                       tt-item.separa-mg    = lSepara-mg                   AND
                                       tt-item.nome-transp  = (IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp) AND
                                     /*tt-item.estado       = tt-notaOrigem.estado           AND */
                                       tt-item.it-codigo    = estrutura.es-codigo          AND
                                       tt-item.cod-refer    = ""                           AND
                                       tt-item.deposito     = c-cod-depos                  AND
                                       tt-item.cod-cli-dif  = x-cli-difer                  AND 
                                       tt-item.nr-nota-fis  = c-nr-nota-fis                NO-ERROR.
                        END.
    
                        IF NOT AVAILABLE tt-item THEN DO:
                            /* PUT 17
                                SKIP. */

                           
                            CREATE tt-item.
                            ASSIGN tt-item.separa-mg     = lSepara-mg
                                   tt-item.nome-transp   = (IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp)
                                   tt-item.estado        = IF tt-param.l-class THEN (IF AVAIL tt-notaOrigem THEN tt-notaOrigem.estado ELSE ped-venda.estado) ELSE ""
                                   tt-item.it-codigo     = estrutura.es-codigo
                                   tt-item.cod-refer     = ""
                                   tt-item.deposito      = c-cod-depos 
                                   tt-item.pedido        = it-pre-fat.nr-pedcli
                                   tt-item.qt-alocada    = ((IF NOT AVAILABLE item-caixa OR tt-param.tipo-volume = 3 THEN it-pre-fat.qt-alocada ELSE (IF tt-param.tipo-volume = 1 THEN it-pre-fat.qt-alocada MODULO item-caixa.qt-item ELSE it-pre-fat.qt-alocada - (it-pre-fat.qt-alocada MODULO item-caixa.qt-item))) /*it-pre-fat.qt-alocada*/ * estrutura.quant-usada)
                                   tt-item.cod-cli-dif   = x-cli-difer
                                   tt-item.nr-nota-fis   = c-nr-nota-fis
                                   tt-item.nota-classif  = IF can-find(FIRST filial-cliente WHERE filial-cliente.cnpj = nota-fiscal.cgc) THEN c-nr-nota-fis ELSE ""
                                   tt-item.qt-item       = IF AVAIL item-caixa THEN item-caixa.qt-item ELSE 0
                                   tt-item.obs-cli-difer = c-obs-cli-difer.
                            
                            FIND ITEM NO-LOCK WHERE 
                                 ITEM.it-codigo = tt-item.it-codigo NO-ERROR.
                            IF AVAILABLE ITEM THEN
                               ASSIGN tt-item.desc-item    = ITEM.desc-item
                                      tt-item.un           = ITEM.un.
    
                            /* Sequància do Item na impress∆o */
                            FIND FIRST seq-item NO-LOCK
                                WHERE  seq-item.it-codigo = tt-item.it-codigo NO-ERROR.
                            IF  tt-param.ordenacao-item THEN
                                ASSIGN tt-item.sequencia = IF AVAIL seq-item THEN seq-item.sequencia ELSE 999999.
                            ELSE
                                ASSIGN tt-item.sequencia = 0.
                        END.
                        ELSE
                            ASSIGN tt-item.qt-alocada = tt-item.qt-alocada + ((IF NOT AVAILABLE item-caixa OR tt-param.tipo-volume = 3 THEN it-pre-fat.qt-alocada ELSE (IF tt-param.tipo-volume = 1 THEN it-pre-fat.qt-alocada MODULO item-caixa.qt-item ELSE it-pre-fat.qt-alocada - (it-pre-fat.qt-alocada MODULO item-caixa.qt-item))) /*it-pre-fat.qt-alocada*/ * estrutura.quant-usada).
                    END. /* each estrutura */
                END. /* else do:*/
            END. /* IF l-it-dep-fat = NO THEN DO: */
    
            IF NOT tt-param.reimpressao THEN DO:
                FIND FIRST tt-pre-fatur NO-LOCK                              WHERE
                           tt-pre-fatur.nr-embarque  = pre-fatur.cdd-embarq AND
                           tt-pre-fatur.nr-resumo    = pre-fatur.nr-resumo   AND
                           tt-pre-fatur.nome-abrev   = pre-fatur.nome-abrev  AND
                           tt-pre-fatur.nr-pedcli    = pre-fatur.nr-pedcli   NO-ERROR. 
    
                  IF NOT AVAILABLE tt-pre-fatur THEN DO:
                      /* PUT 18
                          SKIP. */
                      CREATE tt-pre-fatur.
                      ASSIGN tt-pre-fatur.nr-embarque  = pre-fatur.cdd-embarq
                             tt-pre-fatur.nr-resumo    = pre-fatur.nr-resumo
                             tt-pre-fatur.nome-abrev   = pre-fatur.nome-abrev
                             tt-pre-fatur.nr-pedcli    = pre-fatur.nr-pedcli.
                  END.
            END.
    
            IF NOT CAN-FIND(ttEmbarques                                                                                              WHERE
                            ttEmbarques.separa-mg   = lSepara-mg                                                                     AND
                            ttEmbarques.nome-transp = (IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp) AND
                            ttEmbarques.estado      = (IF AVAIL tt-notaOrigem THEN tt-notaOrigem.estado      ELSE ped-venda.estado)      AND
                            ttEmbarques.nr-embarque = pre-fatur.cdd-embarq                                                          AND
                            ttembarques.cod-cli-dif = x-cli-difer)                                                                   THEN DO:
                                /* PUT 19
                                    SKIP. */
                  CREATE ttEmbarques.
                  ASSIGN ttEmbarques.separa-mg   = lSepara-mg
                         ttEmbarques.nome-transp = IF c-transp <> "" THEN c-transp ELSE ped-venda.nome-transp
                         ttEmbarques.estado      = IF AVAIL tt-notaOrigem THEN tt-notaOrigem.estado      ELSE ped-venda.estado
                         ttEmbarques.nr-embarque = pre-fatur.cdd-embarq
                         ttembarques.cod-cli-dif = x-cli-difer.
            END.
    
            IF NOT CAN-FIND(ttnota-fiscal                                        WHERE
                            ttNota-fiscal.separa-mg   = lSepara-mg               AND 
                            ttNota-fiscal.cod-estabel = tt-notaOrigem.cod-estabel  AND 
                            ttNota-fiscal.serie       = tt-notaOrigem.serie        AND 
                            ttNota-fiscal.nr-nota-fis = tt-notaOrigem.nr-nota-fis) THEN DO:

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
    END.
END.

/******* Notas sem embarque adicionadas a separaá∆o de itens********/
/*********** Transportadora informada ***********/
IF tt-param.nome-transp <> "" THEN DO:

    FOR EACH tt-digita NO-LOCK,
        EACH nota-fiscal USE-INDEX ch-distancia NO-LOCK              WHERE
             nota-fiscal.cod-estabel    = tt-digita.cod-estabel      AND
             nota-fiscal.serie          = tt-digita.serie            AND
             nota-fiscal.dt-cancela     = ?                          AND
             nota-fiscal.nr-nota-fis   >= tt-digita.nr-nota-fis-ini  AND
             nota-fiscal.nr-nota-fis   <= tt-digita.nr-nota-fis-end  AND
             nota-fiscal.dt-emis-nota  >= tt-param.dt-emis-nf-ini    AND
             nota-fiscal.dt-emis-nota  <= tt-param.dt-emis-nf-end    AND
             nota-fiscal.nome-transp    = tt-param.nome-transp,
       FIRST natur-oper NO-LOCK WHERE
             natur-oper.nat-operacao    = nota-fiscal.nat-operacao:

        {esinc/es0004.i} /*ValidaNaturezasImpress∆oNFs*/
        
        IF tt-param.notas-desconsiderar <> "" THEN DO:
            FIND FIRST tt-nota-des
                WHERE INT(tt-nota-des.c-cod-nota-des-ini) <= INT(nota-fiscal.nr-nota-fis)
                  AND INT(tt-nota-des.c-cod-nota-des-fim) >= INT(nota-fiscal.nr-nota-fis) NO-LOCK NO-ERROR.
            IF AVAIL tt-nota-des THEN NEXT.
        END.

        IF tt-param.l-estado THEN 
            IF NOT CAN-FIND(tt-estado WHERE 
                            tt-estado.estado = nota-fiscal.estado) THEN 
                NEXT.
        END.         
         assign c-transp = nota-fiscal.nome-transp.
        IF natur-oper.log-oper-triang THEN DO:
            FOR FIRST b-nota-fiscal NO-LOCK                                  WHERE 
                      b-nota-fiscal.cdd-embarq     = nota-fiscal.cdd-embarq    AND
                      b-nota-fiscal.nr-resumo      = nota-fiscal.nr-resumo     AND
                      b-nota-fiscal.nome-ab-cli    = nota-fiscal.nome-abrev  AND
                      b-nota-fiscal.nr-pedcli     = ""                       AND                            
                      b-nota-fiscal.cod-estabel    = tt-param.cod-estabel    AND
                      b-nota-fiscal.dt-cancela     = ?:
                 assign c-transp = b-nota-fiscal.nome-transp.
            END.  
        END.

        IF AVAIL b-nota-fiscal THEN DO:

            FIND FIRST tt-notaOrigem
                WHERE tt-notaOrigem.cod-estabel  = b-nota-fiscal.cod-estabel 
                  AND tt-notaOrigem.serie        = b-nota-fiscal.serie       
                  AND tt-notaOrigem.nr-nota-fis  = b-nota-fiscal.nr-nota-fis  EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAIL tt-notaOrigem THEN DO:
                /* PUT 22
                    SKIP. */
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
                       tt-notaOrigem.nome-abrev   = b-nota-fiscal.nome-abrev.
            END. /*  IF NOT AVAIL tt-notaOrigem THEN DO: */

        END. /* IF AVAIL b-nota-fiscal THEN DO: */
        ELSE DO:

            IF AVAIL nota-fiscal THEN DO:
                FIND FIRST tt-notaOrigem
                    WHERE tt-notaOrigem.cod-estabel  = nota-fiscal.cod-estabel 
                      AND tt-notaOrigem.serie        = nota-fiscal.serie       
                      AND tt-notaOrigem.nr-nota-fis  = nota-fiscal.nr-nota-fis  EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAIL tt-notaOrigem THEN DO:
                    /* PUT 23
                        SKIP. */
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
                           tt-notaOrigem.nome-abrev   = nota-fiscal.nome-abrev.
                END. /*  IF NOT AVAIL tt-notaOrigem THEN DO: */
            END. /* IF AVAIL nota-fiscal THEN DO: */

        END. /* IF NOT AVAIL b-nota-fiscal THEN DO: */

        FIND CURRENT tt-notaOrigem NO-LOCK NO-ERROR.
        IF AVAIL tt-notaOrigem THEN DO:

            FIND FIRST int-nota-fiscal NO-LOCK                                 WHERE
                       int-nota-fiscal.cod-estab    = tt-notaOrigem.cod-estabel  AND
                       int-nota-fiscal.serie        = tt-notaOrigem.serie        AND
                       int-nota-fiscal.nr-nota-fis  = tt-notaOrigem.nr-nota-fis  NO-ERROR.
            IF AVAILABLE int-nota-fiscal AND
                int-nota-fiscal.log-impr-separacao <> tt-param.reimpressao THEN
                NEXT.

            RUN defineAstec.

            FOR EACH it-nota-fisc NO-LOCK OF tt-notaOrigem:
                IF tt-param.rastreabilidade = 1 THEN DO:
                    FIND FIRST tt-item-rast
                        WHERE tt-item-rast.it-codigo = it-nota-fisc.it-codigo NO-ERROR.

                    IF NOT AVAILABLE tt-item-rast THEN NEXT.
                END.
                ELSE IF tt-param.rastreabilidade = 2 THEN DO:
                    FIND FIRST tt-item-rast
                        WHERE tt-item-rast.it-codigo = it-nota-fisc.it-codigo NO-ERROR.

                    IF AVAILABLE tt-item-rast THEN NEXT.
                END.

                ASSIGN c-cod-depos = "".
                FOR EACH fat-ser-lote
                    WHERE fat-ser-lote.cod-estabel = tt-notaOrigem.cod-estabel
                      AND fat-ser-lote.serie       = tt-notaOrigem.serie
                      AND fat-ser-lote.nr-nota-fis = tt-notaOrigem.nr-nota-fis
                      AND fat-ser-lote.it-codigo   = it-nota-fisc.it-codigo
                      AND fat-ser-lote.cod-refer   = it-nota-fisc.cod-refer NO-LOCK:
                    ASSIGN c-cod-depos = c-cod-depos + fat-ser-lote.cod-depos + ",".
                END.


                IF natur-oper.nat-operacao BEGINS "7":U THEN DO:
                    FIND FIRST emitente
                        WHERE emitente.nome-abrev = tt-notaOrigem.nome-ab-cli NO-LOCK NO-ERROR.

                    IF AVAILABLE emitente THEN DO:
                        FIND FIRST int-emitente
                            WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

                        IF AVAILABLE int-emitente              AND
                           int-emitente.tipo-embalagem <> "":U THEN DO:
                            FIND FIRST embalag
                                WHERE embalag.embalagem = int-emitente.tipo-embalagem NO-LOCK NO-ERROR.

                            IF AVAILABLE embalag THEN
                                FIND FIRST item-caixa
                                    WHERE item-caixa.it-codigo  = it-nota-fisc.it-codigo
                                      AND item-caixa.fm-codigo  = ?
                                      AND item-caixa.fm-cod-com = ?
                                      AND item-caixa.sigla-emb BEGINS embalag.sigla-emb NO-LOCK NO-ERROR.
                        END.
                        ELSE DO:
                            FIND FIRST item-caixa
                                WHERE item-caixa.it-codigo  = it-nota-fisc.it-codigo
                                  AND item-caixa.fm-codigo  = ?
                                  AND item-caixa.fm-cod-com = ?
                                  AND item-caixa.sigla-emb BEGINS "E":U NO-LOCK NO-ERROR.

                            FIND FIRST embalag
                                WHERE embalag.sigla-emb = item-caixa.sigla-emb NO-LOCK NO-ERROR.

                            IF NOT AVAILABLE embalag THEN DO:
                                FOR EACH embalag
                                    WHERE embalag.embalagem BEGINS "EMB":U
                                      AND embalag.emite-roman
                                    BREAK BY embalag.volume:
                                    FIND FIRST item-caixa
                                        WHERE item-caixa.it-codigo  = it-nota-fisc.it-codigo
                                          AND item-caixa.fm-codigo  = ?
                                          AND item-caixa.fm-cod-com = ?
                                          AND item-caixa.sigla-emb BEGINS embalag.sigla-emb NO-LOCK NO-ERROR.
                                END.
                            END.
                        END.
                    END.

                    IF AVAILABLE item-caixa THEN DO:
                        IF tt-param.tipo-volume                                  = 1 AND
                           it-nota-fisc.qt-faturada[1] MODULO item-caixa.qt-item = 0 THEN NEXT.

                        IF tt-param.tipo-volume                                   = 2 AND
                           it-nota-fisc.qt-faturada[1] MODULO item-caixa.qt-item <> 0 AND
                           it-nota-fisc.qt-faturada[1] < item-caixa.qt-item           THEN NEXT.
                    END.
                END.
                ELSE DO:
                    FIND FIRST item-caixa
                        WHERE item-caixa.it-codigo  = it-dep-fat.it-codigo
                          AND item-caixa.fm-codigo  = ?
                          AND item-caixa.fm-cod-com = ?
                          AND item-caixa.sigla-emb  >= "N" NO-LOCK NO-ERROR.

                    IF NOT AVAILABLE item-caixa THEN DO:
                        FIND FIRST item-caixa
                            WHERE item-caixa.it-codigo  = it-pre-fat.it-codigo
                              AND item-caixa.fm-codigo  = ?
                              AND item-caixa.fm-cod-com = ?
                              AND item-caixa.sigla-emb BEGINS "E":U NO-LOCK NO-ERROR.

                    END.
                    IF AVAILABLE item-caixa THEN DO:
                        IF tt-param.tipo-volume                            = 1 AND
                           it-dep-fat.qt-alocada MODULO item-caixa.qt-item = 0 THEN NEXT.

                        IF tt-param.tipo-volume                             = 2 AND
                           it-dep-fat.qt-alocada MODULO item-caixa.qt-item <> 0 AND
                           it-dep-fat.qt-alocada < item-caixa.qt-item           THEN NEXT.
                    END.

                    IF tt-param.tipo-volume = 2 AND
                       NOT AVAIL item-caixa THEN NEXT.
                END.


                FIND FIRST item-uni-estab NO-LOCK WHERE 
                           item-uni-estab.it-codigo   = it-nota-fisc.it-codigo   AND
                           item-uni-estab.cod-estabel = it-nota-fisc.cod-estabel NO-ERROR.
                IF AVAIL item-uni-estab THEN DO:
                    IF l-centrais     AND
                       item-uni-estab.nr-linha <> 20 THEN 
                      NEXT.

                    IF NOT l-centrais AND
                        item-uni-estab.nr-linha  = 20 THEN 
                      NEXT.
                END.
                /********* Achar Cliente diferenciado *************/ 
            ASSIGN x-cli-difer = 0
                   c-nr-nota-fis = ""
                   c-obs-cli-difer = "".


            FOR EACH cli-difer NO-LOCK 
                WHERE cli-difer.cod-emitente = tt-notaOrigem.cod-emitente:

                IF x-cli-difer = 0 AND
                    CAN-FIND(FIRST tt-prog-ponto-tmp                                WHERE
                                   tt-prog-ponto-tmp.conteudo = cli-difer.cc-codigo AND 
                                   tt-prog-ponto-tmp.ponto = 4)                     THEN DO:

                    ASSIGN x-cli-difer = cli-difer.cod-emitente
                           c-nr-nota-fis = IF AVAIL tt-notaOrigem THEN tt-notaOrigem.nr-nota-fis ELSE ""
                           c-obs-cli-difer = cli-difer.descricao.

                END.
            END.
            /***************************************************/

                IF l-centrais THEN DO:
                    FOR EACH estrutura NO-LOCK                                WHERE
                             estrutura.it-codigo     = it-nota-fisc.it-codigo AND
                             estrutura.data-inicio  <= TODAY                  AND
                             estrutura.data-termino >= TODAY:

                        IF tt-param.l-class THEN DO:
                            FIND FIRST tt-item                                             WHERE
                                       tt-item.separa-mg    = lSepara-mg                   AND
                                       tt-item.nome-transp  = tt-notaOrigem.nome-transp      AND
                                       tt-item.estado       = tt-notaOrigem.estado           AND
                                       tt-item.it-codigo    = estrutura.es-codigo          AND
                                       tt-item.cod-refer    = ""                           AND
                                       tt-item.deposito     = c-cod-depos                  AND
                                       tt-item.cod-cli-dif  = x-cli-difer                  AND 
                                       tt-item.nr-nota-fis  = c-nr-nota-fis                NO-ERROR.
                        END.
                        ELSE DO:
                            FIND FIRST tt-item                                             WHERE
                                       tt-item.separa-mg    = lSepara-mg                   AND
                                       tt-item.nome-transp  = tt-notaOrigem.nome-transp      AND
                                     /*tt-item.estado       = tt-notaOrigem.estado           AND */
                                       tt-item.it-codigo    = estrutura.es-codigo          AND
                                       tt-item.cod-refer    = ""                           AND
                                       tt-item.deposito     = c-cod-depos                  AND
                                       tt-item.cod-cli-dif  = x-cli-difer                  AND 
                                       tt-item.nr-nota-fis  = c-nr-nota-fis                NO-ERROR.
                        END.

                        IF NOT AVAILABLE tt-item THEN DO:
                            /* PUT 24
                                SKIP. */
                           
                            CREATE tt-item.
                            ASSIGN tt-item.separa-mg     = lSepara-mg
                                   tt-item.nome-transp   = tt-notaOrigem.nome-transp
                                   tt-item.estado        = IF tt-param.l-class THEN tt-notaOrigem.estado ELSE ""
                                   tt-item.it-codigo     = estrutura.es-codigo
                                   tt-item.cod-refer     = ""
                                   tt-item.deposito      = c-cod-depos 
                                   tt-item.pedido        = it-nota-fisc.nr-pedcli
                                   tt-item.qt-alocada    = (estrutura.quant-usada * (IF NOT AVAILABLE item-caixa OR tt-param.tipo-volume = 3 THEN it-nota-fisc.qt-faturada[1] ELSE (IF tt-param.tipo-volume = 1 THEN it-nota-fisc.qt-faturada[1] MODULO item-caixa.qt-item ELSE it-nota-fisc.qt-faturada[1] - (it-nota-fisc.qt-faturada[1] MODULO item-caixa.qt-item))) /*it-nota-fisc.qt-faturada[1]*/ )
                                   tt-item.cod-cli-dif   = x-cli-difer
                                   tt-item.nr-nota-fis   = c-nr-nota-fis
                                   tt-item.nota-classif  = IF can-find(FIRST filial-cliente WHERE filial-cliente.cnpj = nota-fiscal.cgc) THEN c-nr-nota-fis ELSE ""
                                   tt-item.qt-item       = IF AVAIL item-caixa THEN item-caixa.qt-item ELSE 0
                                   tt-item.obs-cli-difer = c-obs-cli-difer.

                            FIND ITEM NO-LOCK WHERE
                                 ITEM.it-codigo = tt-item.it-codigo NO-ERROR.
                            IF AVAILABLE ITEM THEN
                                ASSIGN tt-item.desc-item    = ITEM.desc-item
                                       tt-item.un           = ITEM.un.

                            /* Sequància do Item na impress∆o */
                            FIND FIRST seq-item NO-LOCK
                                WHERE  seq-item.it-codigo = tt-item.it-codigo NO-ERROR.
                            IF  tt-param.ordenacao-item THEN
                                ASSIGN tt-item.sequencia = IF AVAIL seq-item THEN seq-item.sequencia ELSE 999999.
                            ELSE
                                ASSIGN tt-item.sequencia = 0.
                        END.
                        ELSE
                            ASSIGN tt-item.qt-alocada = tt-item.qt-alocada + (estrutura.quant-usada * (IF NOT AVAILABLE item-caixa OR tt-param.tipo-volume = 3 THEN it-nota-fisc.qt-faturada[1] ELSE (IF tt-param.tipo-volume = 1 THEN it-nota-fisc.qt-faturada[1] MODULO item-caixa.qt-item ELSE it-nota-fisc.qt-faturada[1] - (it-nota-fisc.qt-faturada[1] MODULO item-caixa.qt-item))) /*it-nota-fisc.qt-faturada[1]*/ ).
                    END.
                END.
                ELSE DO:
                    IF tt-param.l-class THEN DO:
                        FIND FIRST tt-item                                                WHERE
                                   tt-item.separa-mg    = lSepara-mg                      AND
                                   tt-item.nome-transp  = tt-notaOrigem.nome-transp         AND
                                   tt-item.estado       = tt-notaOrigem.estado              AND
                                   tt-item.it-codigo    = it-nota-fisc.it-codigo          AND
                                   tt-item.cod-refer    = it-nota-fisc.cod-refer          AND
                                   tt-item.deposito     = c-cod-depos                     AND
                                   tt-item.cod-cli-dif  = x-cli-difer                     AND 
                                   tt-item.nr-nota-fis  = c-nr-nota-fis                   NO-ERROR.
                    END.
                    ELSE DO:
                        FIND FIRST tt-item                                                WHERE
                                   tt-item.separa-mg    = lSepara-mg                      AND
                                   tt-item.nome-transp  = tt-notaOrigem.nome-transp         AND
                                 /*tt-item.estado       = tt-notaOrigem.estado              AND */
                                   tt-item.it-codigo    = it-nota-fisc.it-codigo          AND
                                   tt-item.cod-refer    = it-nota-fisc.cod-refer          AND
                                   tt-item.deposito     = c-cod-depos                     AND
                                   tt-item.cod-cli-dif  = x-cli-difer                     AND 
                                   tt-item.nr-nota-fis  = c-nr-nota-fis                   NO-ERROR.
                    END.

                    IF NOT AVAILABLE tt-item THEN DO:
                        /* PUT 25
                            SKIP. */

                       
                        CREATE tt-item.
                        ASSIGN tt-item.separa-mg     = lSepara-mg
                               tt-item.nome-transp   = tt-notaOrigem.nome-transp
                               tt-item.estado        = IF tt-param.l-class THEN tt-notaOrigem.estado ELSE ""
                               tt-item.it-codigo     = it-nota-fisc.it-codigo
                               tt-item.cod-refer     = it-nota-fisc.cod-refer
                               tt-item.deposito      = c-cod-depos 
                               tt-item.pedido        = it-nota-fisc.nr-pedcli
                               tt-item.qt-alocada    = IF NOT AVAILABLE item-caixa OR tt-param.tipo-volume = 3 THEN it-nota-fisc.qt-faturada[1] ELSE (IF tt-param.tipo-volume = 1 THEN it-nota-fisc.qt-faturada[1] MODULO item-caixa.qt-item ELSE it-nota-fisc.qt-faturada[1] - (it-nota-fisc.qt-faturada[1] MODULO item-caixa.qt-item)) /*it-nota-fisc.qt-faturada[1]*/
                               tt-item.cod-cli-dif   = x-cli-difer
                               tt-item.nr-nota-fis   = c-nr-nota-fis
                               tt-item.nota-classif  = IF can-find(FIRST filial-cliente WHERE filial-cliente.cnpj = nota-fiscal.cgc) THEN c-nr-nota-fis ELSE ""
                               tt-item.qt-item       = IF AVAIL item-caixa THEN item-caixa.qt-item ELSE 0
                               tt-item.obs-cli-difer = c-obs-cli-difer.

                        FIND ITEM NO-LOCK WHERE
                             ITEM.it-codigo = tt-item.it-codigo NO-ERROR.
                        IF AVAILABLE ITEM THEN
                            ASSIGN tt-item.desc-item    = ITEM.desc-item
                                   tt-item.un           = ITEM.un.

                        /* Sequància do Item na impress∆o */
                        FIND FIRST seq-item NO-LOCK
                            WHERE  seq-item.it-codigo = tt-item.it-codigo NO-ERROR.
                        IF  tt-param.ordenacao-item THEN
                            ASSIGN tt-item.sequencia = IF AVAIL seq-item THEN seq-item.sequencia ELSE 999999.
                        ELSE
                            ASSIGN tt-item.sequencia = 0.
                    END.
                    ELSE
                        ASSIGN tt-item.qt-alocada = tt-item.qt-alocada + (IF NOT AVAILABLE item-caixa OR tt-param.tipo-volume = 3 THEN it-nota-fisc.qt-faturada[1] ELSE (IF tt-param.tipo-volume = 1 THEN it-nota-fisc.qt-faturada[1] MODULO item-caixa.qt-item ELSE it-nota-fisc.qt-faturada[1] - (it-nota-fisc.qt-faturada[1] MODULO item-caixa.qt-item))) /*it-nota-fisc.qt-faturada[1]*/ .
                END.
            END.

            IF NOT CAN-FIND(ttNota-fiscal                                        WHERE
                            ttNota-fiscal.separa-mg   = lSepara-mg               AND
                            ttNota-fiscal.cod-estabel = tt-notaOrigem.cod-estabel  AND
                            ttNota-fiscal.serie       = tt-notaOrigem.serie        AND
                            ttNota-fiscal.nr-nota-fis = tt-notaOrigem.nr-nota-fis) THEN DO:

                CREATE ttNota-fiscal.
                ASSIGN ttNota-fiscal.separa-mg   = lSepara-mg
                       ttNota-fiscal.nome-transp = tt-notaOrigem.nome-transp
                       ttNota-fiscal.estado      = tt-notaOrigem.estado
                       ttNota-fiscal.cod-estabel = tt-notaOrigem.cod-estabel
                       ttNota-fiscal.serie       = tt-notaOrigem.serie
                       ttNota-fiscal.nr-nota-fis = tt-notaOrigem.nr-nota-fis
                       ttNota-fiscal.cod-cli-dif = x-cli-difer.
            END.    

        END. /* IF AVAIL tt-notaOrigem THEN DO: */
        
    END.
    
END.
/************************************************/

/******* Notas com embarque adicionadas a separaá∆o de itens********/
/*********** Transportadora informada ***********/

run pi-acompanhar in h-acomp (input "Imprimindo...").

IF tt-param.l-class THEN DO:

    
    FOR EACH tt-item NO-LOCK 
        WHERE  tt-item.it-codigo >= tt-param.it-codigo-ini
          AND  tt-item.it-codigo <= tt-param.it-codigo-fim 
          AND  tt-item.it-codigo <  tt-param.it-codigo-ini-2
           OR  tt-item.it-codigo >  tt-param.it-codigo-fim-2
            BREAK BY tt-item.nome-transp
                  BY tt-item.estado
                  BY tt-item.cod-cli-dif 
                  BY tt-item.nota-classif
                  BY tt-item.deposito
                  BY tt-item.sequencia
                  BY tt-item.it-codigo
            WITH STREAM-IO WIDTH 132:

        IF FIRST-OF(tt-item.estado) THEN DO:
            FIND FIRST unid-feder NO-LOCK WHERE
                       unid-feder.estado = tt-item.estado NO-ERROR.
            
            PUT "     Itens:":U
                   ENTRY(tt-param.rastreabilidade, cRastreabilidade, ";":U) FORMAT "x(19)":U AT 20
               "   Volumes:":U
               ENTRY(tt-param.tipo-volume,     cTipoVolume,      ";":U) FORMAT "x(10)":U AT 60 SKIP.

            DISPLAY tt-item.nome-transp 
                    " - "
                    tt-item.estado
                    " - "
                    unid-feder.no-estado NO-LABEL 
                WITH FRAME f3 STREAM-IO SIDE-LABELS.

            ASSIGN c-deposito = tt-item.deposito.
        END.

        IF (FIRST-OF(tt-item.cod-cli-dif) AND
            tt-item.cod-cli-dif  <> 0)    
            or                         
           (first-of(tt-item.nota-classif) AND
            tt-item.nota-classif <> "") THEN DO:   
            
            PUT FILL("-",130) FORMAT "X(132)".
            PUT SKIP (1) 'Clientes diferenciados: ' .
            
            FIND FIRST emitente NO-LOCK WHERE
                       emitente.cod-emitente = tt-item.cod-cli-dif.
            
            FIND FIRST cli-difer NO-LOCK WHERE
                       cli-difer.cod-emitente = tt-item.cod-cli-dif.

            PUT tt-item.cod-cli-dif " - " emitente.nome-abrev SKIP.
            PUT "Observaá∆o: " SKIP.    
            RUN pi-print-editor(INPUT TRIM(tt-item.obs-cli-difer), INPUT 132).

            FOR EACH tt-editor:
                PUT tt-editor.conteudo FORMAT 'x(132)' SKIP.
            END.
        END.

        IF c-deposito = "" THEN
            ASSIGN c-deposito = tt-item.deposito.

        IF  NOT(tt-item.deposito BEGINS "   ":U) AND (tt-item.deposito <> c-deposito) OR 
               (tt-item.deposito BEGINS "   ":U  AND NOT(c-deposito BEGINS "   ":U))  THEN DO:
            ASSIGN c-deposito = tt-item.deposito.
            PAGE.

            DISPLAY tt-item.nome-transp 
                    " - "
                    tt-item.estado
                    " - "
                    unid-feder.no-estado NO-LABEL 
                WITH FRAME f4 STREAM-IO SIDE-LABELS.
        END.
        FIND item-mat
            WHERE item-mat.it-codigo = tt-item.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL item-mat THEN
           ASSIGN c-cod-ean13 = item-mat.cod-ean.
        ELSE
           ASSIGN c-cod-ean13 = "".

        DISPLAY tt-item.it-codigo FORMAT "9999999"
                STRING(tt-item.desc-item) FORMAT  'x(35)' COLUMN-LABEL "Descriá∆o"
                tt-item.un
                tt-item.qt-alocada
                tt-item.deposito  + (IF tt-item.deposito = "b2c" THEN " E-commercer" ELSE "") @ tt-item.deposito FORMAT "x(15)"
                tt-item.localizacao
                tt-item.pedido
                c-cod-ean13     FORMAT "x(13)"
                tt-item.qt-item FORMAT ">>>9"    COLUMN-LABEL "Fator" 
            WITH WIDTH 132 STREAM-IO.

        IF (LAST-OF(tt-item.cod-cli-dif) AND
            tt-item.cod-cli-dif  = 0) THEN DO:   

            PUT SKIP (1) 'Embarques: ' SKIP.

            ASSIGN cList = ''.

            FOR EACH ttEmbarques NO-LOCK                           WHERE
                     ttEmbarques.nome-transp = tt-item.nome-transp AND
                     ttEmbarques.estado      = tt-item.estado      AND
                     ttEmbarques.cod-cli-dif = 0:
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

           FOR EACH ttNota-fiscal NO-LOCK WHERE
                    ttNota-fiscal.nome-transp = tt-item.nome-transp AND
                    ttNota-fiscal.estado      = tt-item.estado      AND
                    ttNota-fiscal.cod-cli-dif = 0: 
               IF tt-item.nota-classif = "" OR 
                  tt-item.nota-classif = ttNota-fiscal.nr-nota-fis THEN DO:
                   ASSIGN cList = cList + (IF cList <> '' THEN ', ' ELSE '') + TRIM(ttNota-fiscal.nr-nota-fis).
                   ASSIGN vValTotalNota = vValTotalNota + ttNota-fiscal.vl-tot-nota
                          vqtTotalVol   = vqtTotalVol   + int(ttNota-fiscal.nr-volumes).

               END.

           END.

           RUN pi-print-editor(INPUT cList, INPUT 132).

           FOR EACH tt-editor:
               PUT tt-editor.conteudo FORMAT 'x(132)' SKIP.
           END.
       END.

       IF (LAST-OF(tt-item.cod-cli-dif) AND
           tt-item.cod-cli-dif  <> 0)    
           or                         
          (LAST-OF(tt-item.nota-classif) AND
           tt-item.nota-classif <> "") THEN DO:   

           PUT SKIP (1) 'Embarques: ' SKIP.

           ASSIGN cList = ''.
           FOR EACH ttEmbarques NO-LOCK                           WHERE
                    ttEmbarques.nome-transp = tt-item.nome-transp AND
                    ttEmbarques.cod-cli-dif = tt-item.cod-cli-dif
               BREAK BY ttEmbarques.nr-embarque:

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

           FOR EACH ttNota-fiscal NO-LOCK WHERE
                    ttNota-fiscal.nome-transp = tt-item.nome-transp AND
                    ttNota-fiscal.cod-cli-dif = tt-item.cod-cli-dif AND
                    ttNota-fiscal.estado      = tt-item.estado      
               BREAK BY ttNota-fiscal.nr-nota-fis:
               IF tt-item.nota-classif = "" OR 
                  tt-item.nota-classif = ttNota-fiscal.nr-nota-fis THEN DO:

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

       IF LAST-OF(tt-item.estado) THEN DO: 
          ASSIGN vValTotalNota = 0
                 vQtTotalVol   = 0.

          FOR EACH ttNota-fiscal NO-LOCK WHERE
                   ttNota-fiscal.nome-transp = tt-item.nome-transp AND
                   ttNota-fiscal.estado      = tt-item.estado:
               ASSIGN vValTotalNota = vValTotalNota + ttNota-fiscal.vl-tot-nota
                      vqtTotalVol   = vqtTotalVol   + int(ttNota-fiscal.nr-volumes).
          END.

          PUT SKIP(2)
              "Valor Total Notas do Estado...: " vValTotalNota SKIP
              "Quant Total Volumes do Estado.: " vQtTotalVol   SKIP(5).
          PAGE.
       END.
   END.
END. /* IF tt-param.l-class THEN DO: */
ELSE DO:


    FOR EACH tt-item NO-LOCK
        WHERE  tt-item.it-codigo >= tt-param.it-codigo-ini
          AND  tt-item.it-codigo <= tt-param.it-codigo-fim 
          AND  tt-item.it-codigo < tt-param.it-codigo-ini-2
           OR  tt-item.it-codigo > tt-param.it-codigo-fim-2
        BREAK BY tt-item.separa-mg 
              BY tt-item.nome-transp  
              BY tt-item.cod-cli-dif 
              BY tt-item.nota-classif
              BY tt-item.deposito
              BY tt-item.sequencia
              BY tt-item.it-codigo
        WITH STREAM-IO WIDTH 132:

        IF FIRST-OF(tt-item.nome-transp) THEN DO:

            PUT "     Itens:":U
                   ENTRY(tt-param.rastreabilidade, cRastreabilidade, ";":U) FORMAT "x(19)":U AT 20
               "   Volumes:":U
               ENTRY(tt-param.tipo-volume,     cTipoVolume,      ";":U) FORMAT "x(10)":U AT 60 SKIP.

           DISPLAY tt-item.nome-transp WITH FRAME f-nome-transp.

           ASSIGN c-deposito = tt-item.deposito.
        END.

        IF (FIRST-OF(tt-item.cod-cli-dif) AND
            tt-item.cod-cli-dif  <> 0)    
            or                         
           (first-of(tt-item.nota-classif) AND
            tt-item.nota-classif <> "") THEN DO:   

           PUT SKIP (1) 'Clientes diferenciados: '.

           FIND FIRST emitente NO-LOCK WHERE
                      emitente.cod-emitente = tt-item.cod-cli-dif.
           FIND FIRST cli-difer NO-LOCK WHERE
                      cli-difer.cod-emitente = tt-item.cod-cli-dif.

           PUT tt-item.cod-cli-dif " - " emitente.nome-abrev skip.
           PUT "Observaá∆o: ".

           RUN pi-print-editor(INPUT trim(tt-item.obs-cli-difer), INPUT 118).
           FOR EACH tt-editor:
               PUT tt-editor.conteudo FORMAT 'x(132)' AT 13 SKIP.
           END.
           PUT " " SKIP.

        END.

        IF c-deposito = "" THEN
            ASSIGN c-deposito = tt-item.deposito.

        IF NOT(tt-item.deposito BEGINS "   ":U) AND (tt-item.deposito <> c-deposito) OR 
              (tt-item.deposito BEGINS "   ":U  AND NOT(c-deposito BEGINS "   ":U))  THEN DO:
            ASSIGN c-deposito = tt-item.deposito.
            PAGE.
            DISPLAY tt-item.nome-transp WITH FRAME f-nome-transp.
        END.
        FIND item-mat
            WHERE item-mat.it-codigo = tt-item.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL item-mat THEN
           ASSIGN c-cod-ean13 = item-mat.cod-ean.
        ELSE
           ASSIGN c-cod-ean13 = "".
        DISPLAY tt-item.it-codigo FORMAT "9999999"
                STRING(tt-item.desc-item) FORMAT  'x(35)' COLUMN-LABEL "Descriá∆o"
                tt-item.un
                tt-item.qt-alocada
                tt-item.deposito  + (IF tt-item.deposito = "b2c" THEN " E-commercer" ELSE "") @ tt-item.deposito FORMAT "x(15)"
                tt-item.localizacao
                tt-item.pedido
                c-cod-ean13     FORMAT "x(13)"
                tt-item.qt-item FORMAT ">>>9"    COLUMN-LABEL "Fator"
            WITH WIDTH 132 STREAM-IO.


        IF (LAST-OF(tt-item.cod-cli-dif) AND
            tt-item.cod-cli-dif  <> 0)    
            or                         
           (LAST-OF(tt-item.nota-classif) AND
            tt-item.nota-classif <> "") THEN DO:   

            PUT SKIP (1) 'Embarques: ' SKIP.

            ASSIGN cList = ''.
            FOR EACH ttEmbarques NO-LOCK                           WHERE
                     ttEmbarques.nome-transp = tt-item.nome-transp AND
                     ttEmbarques.cod-cli-dif = tt-item.cod-cli-dif
                BREAK BY ttEmbarques.nr-embarque:
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

            FOR EACH ttNota-fiscal NO-LOCK WHERE
                     ttNota-fiscal.nome-transp = tt-item.nome-transp AND
                     ttNota-fiscal.cod-cli-dif = tt-item.cod-cli-dif
                BREAK BY ttNota-fiscal.nr-nota-fis:
                IF tt-item.nota-classif = "" OR 
                   tt-item.nota-classif = ttNota-fiscal.nr-nota-fis THEN DO:

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
            FOR EACH ttEmbarques NO-LOCK                            WHERE
                     ttEmbarques.nome-transp = tt-item.nome-transp 
                BREAK BY ttEmbarques.nr-embarque:
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

            FOR EACH ttNota-fiscal NO-LOCK WHERE
                     ttNota-fiscal.nome-transp = tt-item.nome-transp /* AND
                     ttNota-fiscal.estado      = tt-item.estado         */
                BREAK BY ttNota-fiscal.nr-nota-fis:
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

           FOR EACH ttNota-fiscal NO-LOCK                           WHERE
                    ttNota-fiscal.separa-mg   = tt-item.separa-mg   AND
                    ttNota-fiscal.nome-transp = tt-item.nome-transp
               BREAK BY ttNota-fiscal.nr-nota-fis:
               ASSIGN cListNF = cListNF + (IF cListNF <> '' THEN ', ' ELSE '') + TRIM(ttNota-fiscal.nr-nota-fis).
               ASSIGN vValTotalNota = vValTotalNota + ttNota-fiscal.vl-tot-nota
                       vqtTotalVol   = vqtTotalVol   + int(ttNota-fiscal.nr-volumes).
            END.
            PUT skip(2)
                "Valor Total Notas...: " vValTotalNota SKIP
                "Quant Total Volumes.: " vQtTotalVol   SKIP(2).
            PAGE.
        END.
    END.
END.

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


IF tt-param.impr-params THEN
   RUN piImprimeParam IN THIS-PROCEDURE.

IF NOT tt-param.reimpressao THEN DO:
   Marca_Impres:
   DO TRANSACTION:
      FOR EACH tt-pre-fatur NO-LOCK,
          FIRST pre-fatur EXCLUSIVE-LOCK 
          where pre-fatur.cdd-embarq  = tt-pre-fatur.nr-embarque
            and pre-fatur.nr-resumo   = tt-pre-fatur.nr-resumo
            and pre-fatur.nome-abrev  = tt-pre-fatur.nome-abrev
            and pre-fatur.nr-pedcli   = tt-pre-fatur.nr-pedcli
          ON ERROR UNDO Marca_Impres, LEAVE Marca_Impres:
          ASSIGN pre-fatur.pick-impresso = YES.
      END.

      FOR EACH ttNota-fiscal NO-LOCK USE-INDEX id-nota:
          FIND int-nota-fiscal EXCLUSIVE-LOCK                          WHERE
               int-nota-fiscal.cod-estab   = ttNota-fiscal.cod-estab   AND
               int-nota-fiscal.serie       = ttNota-fiscal.serie       AND
               int-nota-fiscal.nr-nota-fis = ttNota-fiscal.nr-nota-fis NO-ERROR.
          IF NOT AVAILABLE int-nota-fiscal THEN DO:
              /* PUT 27
                  SKIP. */
             CREATE int-nota-fiscal.
             ASSIGN int-nota-fiscal.cod-estab   = ttNota-fiscal.cod-estab
                    int-nota-fiscal.serie       = ttNota-fiscal.serie
                    int-nota-fiscal.nr-nota-fis = ttNota-fiscal.nr-nota-fis.
          END.
          ASSIGN int-nota-fiscal.log-impr-separacao = YES.
      END.
   END.
END.

PROCEDURE piMostraEstados:

    DEF INPUT PARAM p-nome-transp LIKE nota-fiscal.nome-transp.

    FOR EACH tt-estado:
        FOR EACH bf-item NO-LOCK                        WHERE
                 bf-item.nome-transp = p-nome-transp    AND
                 bf-item.estado      = tt-estado.estado AND
                 bf-item.cod-cli-dif = 0
            BREAK BY bf-item.nome-transp
            WITH STREAM-IO WIDTH 132:

            IF FIRST-OF(bf-item.nome-transp) THEN DO:
               DISPLAY bf-item.nome-transp @ tt-item.nome-transp
                       WITH FRAME f-nome-transp.

               FIND FIRST unid-feder NO-LOCK WHERE
                          unid-feder.estado = bf-item.estado NO-ERROR.

               DISPLAY bf-item.estado @ tt-item.estado
                       unid-feder.no-estado 
                       WITH FRAME f-estado.
            END.

            DISPLAY bf-item.it-codigo
                    string(bf-item.desc-item) FORMAT  'x(42)' COLUMN-LABEL "Descriá∆o"
                    bf-item.un
                    bf-item.qt-alocada
                    bf-item.deposito + (IF tt-item.deposito = "b2c" THEN " E-commercer" ELSE "") @ tt-item.deposito format "x(15)"
                    bf-item.localizacao
                    bf-item.pedido
                    WITH WIDTH 132 STREAM-IO.
        END.


        PUT SKIP (1) 'Clientes diferenciados: ' SKIP.
        FOR EACH bf-item NO-LOCK                        WHERE
                 bf-item.nome-transp = p-nome-transp    AND
                 bf-item.estado      = tt-estado.estado AND
                 bf-item.cod-cli-dif <> 0
            BREAK BY bf-item.nome-transp
            WITH STREAM-IO WIDTH 132:

            IF FIRST-OF(bf-item.nome-transp) THEN DO:
               DISPLAY bf-item.nome-transp @ tt-item.nome-transp
                       WITH FRAME f-nome-transp.

               FIND FIRST unid-feder NO-LOCK WHERE
                          unid-feder.estado = bf-item.estado NO-ERROR.

               DISPLAY bf-item.estado @ tt-item.estado
                       unid-feder.no-estado 
                       WITH FRAME f-estado.
            END.

            DISPLAY bf-item.it-codigo
                    string(bf-item.desc-item) FORMAT  'x(42)' COLUMN-LABEL "Descriá∆o"
                    bf-item.un
                    bf-item.qt-alocada
                    bf-item.deposito + (IF tt-item.deposito = "b2c" THEN " E-commercer" ELSE "") @ tt-item.deposito format "x(15)"
                    bf-item.localizacao
                    bf-item.pedido
                    WITH WIDTH 132 STREAM-IO.
        END.

        FOR EACH bf-item NO-LOCK                        WHERE
                 bf-item.nome-transp = p-nome-transp    AND
                 bf-item.estado      = tt-estado.estado
            BREAK BY bf-item.nome-transp
            WITH STREAM-IO WIDTH 132:

            IF LAST-OF(bf-item.nome-transp) THEN DO:

               PUT SKIP (1) 'Embarques: ' SKIP.

               ASSIGN cList = ''.
               FOR EACH ttEmbarques NO-LOCK                           WHERE
                        ttEmbarques.nome-transp = bf-item.nome-transp AND
                        ttEmbarques.estado      = bf-item.estado:  
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

               FOR EACH ttNota-fiscal NO-LOCK                           WHERE
                        ttNota-fiscal.nome-transp = bf-item.nome-transp AND
                        ttNota-fiscal.estado      = bf-item.estado: 
                   ASSIGN cList = cList + (IF cList <> '' THEN ', ' ELSE '') + TRIM(ttNota-fiscal.nr-nota-fis).
                   ASSIGN vValTotalNota = vValTotalNota + ttNota-fiscal.vl-tot-nota
                          vqtTotalVol   = vqtTotalVol   + int(ttNota-fiscal.nr-volumes).
               END.

               RUN pi-print-editor(INPUT cList, INPUT 132).
               FOR EACH tt-editor:
                   PUT tt-editor.conteudo FORMAT 'x(132)' SKIP.
               END.

               PUT skip(2)
                   "Valor Total Notas...: " vValTotalNota SKIP
                   "Quant Total Volumes.: " vQtTotalVol   SKIP(2).

               PAGE. 
            END.
        END.
    END.
END PROCEDURE.

PROCEDURE piImprimeParam:
    DEFINE VARIABLE vDestino         AS CHARACTER   NO-UNDO.


    PAGE.
    CASE tt-param.destino:
        WHEN 1 THEN ASSIGN vDestino = "Impressora". 
        WHEN 2 THEN ASSIGN vDestino = "Arquivo".
        WHEN 3 THEN ASSIGN vDestino = "Terminal".
    END.

    PUT  "SELEÄ«O:"                     SKIP(1)
         "  Embarque:"
            tt-param.nr-embarque-ini    AT 20 " |<  >| " AT 32
            tt-param.nr-embarque-end    SKIP
         " Nr Resumo:"
            tt-param.nr-resumo-ini      AT 20 " |<  >| " AT 32
            tt-param.nr-resumo-end      SKIP
         "     Itens:":U
            ENTRY(tt-param.rastreabilidade, cRastreabilidade, ";":U) FORMAT "x(19)":U AT 20 SKIP
         "   Volumes:":U
            ENTRY(tt-param.tipo-volume,     cTipoVolume,      ";":U) FORMAT "x(10)":U AT 20 SKIP
         SKIP(3)
         "PAR∂METROS:"                  SKIP(1)
         "  Reimpress∆o: " 
            tt-param.reimpressao        AT 22 SKIP 
         "  Transportador: "
            tt-param.nome-transp        AT 22 SKIP
         SKIP(3)
         "IMPRESS«O:"                   SKIP(1)
         "        Destino:"     
         vDestino                       AT 20 SKIP
         "        Usu†rio:"
         c-seg-usuario                  AT 20 SKIP
         "           Data:"
         tt-param.data-exec             AT 20 SKIP
         "           Hora:"
         string(tt-param.hora-exec,"hh:mm") AT 20
         SKIP(3).

END PROCEDURE.

run pi-finalizar in h-acomp.
{include/i-rpclo.i}
RETURN "OK".

/*-----------------------  Internal Procedures  -----------------------*/

{include/pi-edit.i}

PROCEDURE defineAstec:
   ASSIGN l-retorno-astec = NO.
   IF AVAIL ped-venda
       AND AVAIL tt-notaOrigem
       AND tt-notaOrigem.nome-transp <> "Sedex"
       AND (ped-venda.tp-pedido = "99" or
            ped-venda.tp-pedido = "9" OR
            ped-venda.tp-pedido = "94") THEN DO:
       FIND tt-pedido-astec
            WHERE tt-pedido-astec.nr-pedcli   = ped-venda.nr-pedcli
              AND tt-pedido-astec.nr-nota-fis = tt-notaOrigem.nr-nota-fis
           NO-LOCK NO-ERROR.
       IF NOT AVAIL tt-pedido-astec THEN DO:
           /* PUT 28
               SKIP. */
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
