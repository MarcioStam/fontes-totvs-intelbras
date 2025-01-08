/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESFTP126RP 2.00.00.000}

/* ***************************  Definitions  ************************** */

DEF BUFFER bint-portaria-movto-bem  FOR int-portaria-movto.
DEF BUFFER bint-portaria-movto-prov FOR int-portaria-movto.
DEF BUFFER bint-portaria-movto-def  FOR int-portaria-movto.
    
/* Preprocessor Definitions ---                                         */

&GLOBAL-DEFINE PRINT-PARAM  YES

/* Include Definitions ---                                              */

/* Defini»’o das temp-tables tt-param, tt-digita e tt-raw-digita */
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field item-ini           as char
    field item-fim           as char
    field familia-ini        as char
    field familia-fim        as char
    field familia-com-ini    as char
    field familia-com-fim    as char
    field portaria-ppb-ini   as char
    field portaria-ppb-fim   as char
    field portaria-atual-ini as char
    field portaria-atual-fim as char
    field ncm-ini            as char
    field ncm-fim            as char
    field estab-ini          as char
    field estab-fim          as char
    field data-ini           as DATE
    field data-fim           as DATE
    FIELD classif            AS INT
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG.
    /*Fim alteracao 15/02/2005*/

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
   field raw-digita      as raw.

DEFINE TEMP-TABLE tt-nota-fiscal NO-UNDO
    FIELD cod-estabel          LIKE nota-fiscal.cod-estabel
    FIELD serie                LIKE nota-fiscal.serie
    FIELD nr-nota-fis          LIKE nota-fiscal.nr-nota-fis
    FIELD destino              AS CHAR
    FIELD operacao             AS CHAR
    FIELD log-tec-nacional     AS LOG
    FIELD dt-emis-nota         LIKE nota-fiscal.dt-emis-nota
    FIELD cod-emitente         LIKE nota-fiscal.cod-emitente
    FIELD nome-emit            LIKE emitente.nome-emit
    FIELD cgc                  LIKE emitente.cgc
    FIELD cidade               LIKE nota-fiscal.cidade
    FIELD estado               LIKE nota-fiscal.estado
    FIELD nat-operacao         LIKE nota-fiscal.nat-operacao
    FIELD cst                  AS CHAR
    FIELD aliquota-icm         LIKE it-nota-fisc.aliquota-icm
    FIELD aliquota-ipi         LIKE it-nota-fisc.aliquota-ipi
    FIELD it-codigo            LIKE it-nota-fisc.it-codigo
    FIELD desc-item            LIKE ITEM.desc-item
    FIELD produto-base         LIKE int-portaria-item.produto-base
    FIELD class-fiscal         LIKE ITEM.class-fiscal
    FIELD cod-unid-negoc       LIKE it-nota-fisc.cod-unid-negoc
    FIELD fm-cod-com           LIKE item.fm-cod-com
    FIELD desc-fm-cod-com      AS CHAR
    FIELD fm-codigo            LIKE item.fm-codigo
    FIELD desc-fm-codigo       AS CHAR
    FIELD qt-faturada          LIKE it-nota-fisc.qt-faturada[1]
    FIELD preco-unit           LIKE it-nota-fisc.vl-preuni
    FIELD vlr-merc-real        LIKE it-nota-fisc.vl-merc-liq
    FIELD vlr-merc-dolar       LIKE it-nota-fisc.vl-preuni-me
    FIELD vl-frete-it          LIKE it-nota-fisc.vl-frete-it
    FIELD vlr-icms             LIKE it-nota-fisc.vl-icms-it
    FIELD vl-bicms-it          LIKE it-nota-fisc.vl-bicms-it
    FIELD vl-ipi-it            LIKE it-nota-fisc.vl-ipi-it
    FIELD base-st              LIKE it-nota-fisc.vl-bsubs-it
    FIELD vl-icmsub-it         LIKE it-nota-fisc.vl-icmsub-it
    FIELD perc-fcp             AS DEC
    FIELD vl-fcp               AS DEC
    FIELD vl-despes-it         LIKE it-nota-fisc.vl-despes-it
    FIELD vl-pis               LIKE it-nota-fisc.vl-pis
    FIELD vl-finsocial         LIKE it-nota-fisc.vl-finsocial
    FIELD vl-tot-item          LIKE it-nota-fisc.vl-tot-item
    FIELD contrib-icms         AS CHAR
    FIELD ins-estadual         LIKE emitente.ins-estadual
    FIELD nf-orig-devol        LIKE nota-fiscal.nr-nota-fis
    FIELD serie-devol          LIKE nota-fiscal.serie      
    FIELD data-devol           AS CHAR
    FIELD nat-oper-devol       LIKE nota-fiscal.nat-operacao
    FIELD centro-custo         AS CHAR
    FIELD segmento             AS CHAR
    FIELD portaria-atual       LIKE int-portaria-movto.codigo
    FIELD portaria-def         LIKE int-portaria-movto.codigo
    FIELD portaria-prov        LIKE int-portaria-movto.codigo
    FIELD dt-portaria-def      AS CHAR
    FIELD desc-mctic           LIKE int-portaria-item.desc-mctic
    FIELD ind-item-fat         AS CHAR
    FIELD classif-atual        LIKE int-portaria-movto.classificacao
    FIELD valid-ini-prov       AS CHAR
    FIELD valid-ini-bem        AS CHAR
    FIELD valid-ini            AS CHAR
    FIELD valid-fim            AS CHAR
    FIELD vl-base-contrapart   AS DEC
    FIELD calc-ext-conv1       AS DEC
    FIELD calc-ext-conv2a      AS DEC
    FIELD calc-ext-conv2b      AS DEC
    FIELD calc-ext-fndct       AS DEC
    FIELD calc-externo         AS DEC
    FIELD calc-interno         AS DEC
    FIELD calc-tot             AS DEC
    FIELD calc-adic            AS DEC
    FIELD calc-cred-prod-hab   AS DEC
    FIELD calc-cred-bem-desenv AS DEC
    FIELD calc-limit-cred      AS DEC.

DEF TEMP-TABLE tt-nota-fiscal-totaliza
    FIELD log-tec-nacional AS LOG
    FIELD produto-base     LIKE int-portaria-item.produto-base
    FIELD portaria-atual   LIKE int-portaria-movto.codigo
    FIELD class-fiscal     LIKE ITEM.class-fiscal
    FIELD data-dou         AS CHAR
    FIELD qt-produzida     LIKE it-nota-fisc.qt-faturada[1]
    FIELD vl-fat-bruto     LIKE it-nota-fisc.vl-tot-item
    FIELD vl-fat-export    AS DEC
    FIELD vl-fat-zfm       AS DEC
    FIELD vl-ipi           AS DEC
    FIELD vl-pis-cofins    AS DEC
    FIELD vl-icms          AS DEC
    FIELD vl-aquis         AS DEC
    FIELD vl-devol         AS DEC
    FIELD vl-ipi-ia        AS DEC
    FIELD vl-icms-ia       AS DEC.

{include/i-rpvar.i}
{utp/ut-glob.i}
{esp/es0018.i}

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.

/* Local Temp-Table Definitions ---                                     */

DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-destino       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE da-data         AS DATE      NO-UNDO.
DEFINE VARIABLE i-niv-trib-icms AS INTEGER    NO-UNDO.
DEFINE VARIABLE l-sub           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE c-cst           AS CHARACTER FORMAT "x(3)"  NO-UNDO.
DEFINE VARIABLE c-fm-codigo     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-fm-cod-com    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-unid-neg      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE vlr-fcp-it      AS DECIMAL   NO-UNDO.
DEFINE VARIABLE perc-fcp        AS DECIMAL   NO-UNDO.

/* Stream Definitions ---                                               */

//DEFINE STREAM str-rp.

/* Form Definitions ---                                                 */

/* ************************  Function Prototypes ********************** */

FUNCTION fn-function RETURNS CHARACTER
  (  )  FORWARD.


/* ***************************  Main Block  *************************** */

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST mgcad.empresa
    WHERE empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

ASSIGN c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
       c-titulo-relat = "":U
       c-sistema      = "":U.

ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}.

FIND FIRST tt-param NO-ERROR.

DO ON ERROR UNDO, RETURN ERROR
   ON STOP  UNDO, RETURN ERROR:
    //{include/i-rpcab.i &STREAM="str-rp"}
    //{include/i-rpout.i &STREAM="STREAM str-rp"}

    //VIEW STREAM str-rp FRAME f-cabec.
    //VIEW STREAM str-rp FRAME f-rodape.

    IF NOT VALID-HANDLE(h-acomp)               OR
       h-acomp:TYPE      <> "PROCEDURE":U      OR
       h-acomp:FILE-NAME <> "utp/ut-acomp.p":U THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "":U).

    RUN pi-lista IN THIS-PROCEDURE.

    IF tt-param.classif = 1 THEN
        RUN pi-imprime IN THIS-PROCEDURE.
    ELSE DO:
        RUN pi-totaliza          IN THIS-PROCEDURE.
        RUN pi-imprime-totaliza  IN THIS-PROCEDURE.
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    //{include/i-rpclo.i &STREAM="STREAM str-rp"}

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    ASSIGN h-acomp = ?.
END.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */
PROCEDURE pi-lista:

    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "ESFTP126":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    DO da-data = tt-param.data-ini TO tt-param.data-fim:
        RUN pi-acompanhar IN h-acomp (INPUT "Selecionando data:" + STRING(da-data,"99/99/9999")).

/*
field portaria-ppb-ini   as char
field portaria-ppb-fim   as char
    */

        FOR EACH nota-fiscal NO-LOCK USE-INDEX ch-distancia
           WHERE nota-fiscal.dt-emis-nota = da-data
           AND   nota-fiscal.cod-estabel  >= tt-param.estab-ini
           AND   nota-fiscal.cod-estabel  <= tt-param.estab-fim,
           EACH  it-nota-fisc OF nota-fiscal NO-LOCK
           WHERE it-nota-fisc.it-codigo >= tt-param.item-ini
           AND   it-nota-fisc.it-codigo <= tt-param.item-fim
           AND   it-nota-fisc.class-fiscal >= tt-param.ncm-ini
           AND   it-nota-fisc.class-fiscal <= tt-param.ncm-fim,
           FIRST item NO-LOCK
           WHERE item.it-codigo = it-nota-fisc.it-codigo:

            IF nota-fiscal.dt-cancel    <> ? THEN NEXT.
            IF nota-fiscal.idi-sit-nf-eletro <> 3 THEN NEXT.
            IF item.it-codigo = "" THEN NEXT.
            
            IF NOT (item.fm-codigo >= tt-param.familia-ini
               AND  item.fm-codigo <= tt-param.familia-fim) THEN NEXT.

            IF NOT (item.fm-cod-com >= tt-param.familia-com-ini
               AND  ITEM.fm-cod-com <= tt-param.familia-com-fim) THEN NEXT.

            FOR FIRST int-portaria-item NO-LOCK
                WHERE int-portaria-item.it-codigo   = ITEM.it-codigo
                  AND int-portaria-item.cod-estabel = nota-fiscal.cod-estabel: END.
            IF NOT AVAIL int-portaria-item THEN NEXT.

            FIND LAST bint-portaria-movto-def NO-LOCK
                WHERE bint-portaria-movto-def.it-codigo     = int-portaria-item.it-codigo  
                  AND bint-portaria-movto-def.cod-estabel   = int-portaria-item.cod-estabel
                  AND bint-portaria-movto-def.seq           = int-portaria-item.seq        
                  AND bint-portaria-movto-def.dt-ini <= da-data
                  AND (bint-portaria-movto-def.dt-fim = ?
                   OR bint-portaria-movto-def.dt-fim >= da-data)
                  AND bint-portaria-movto-def.classificacao = "DEF" NO-ERROR.

            FIND LAST bint-portaria-movto-prov NO-LOCK
                WHERE bint-portaria-movto-prov.it-codigo     = int-portaria-item.it-codigo  
                  AND bint-portaria-movto-prov.cod-estabel   = int-portaria-item.cod-estabel
                  AND bint-portaria-movto-prov.seq           = int-portaria-item.seq        
                  AND bint-portaria-movto-prov.dt-ini <= da-data
                  //AND (bint-portaria-movto-prov.dt-fim = ?
                  // OR bint-portaria-movto-prov.dt-fim >= da-data)
                  AND bint-portaria-movto-prov.classificacao = "PROV" NO-ERROR.

            IF  NOT AVAIL bint-portaria-movto-def
            AND NOT AVAIL bint-portaria-movto-prov THEN NEXT.

            FOR FIRST int-portaria-perc NO-LOCK
                WHERE  int-portaria-perc.it-codigo   = int-portaria-item.it-codigo
                  AND  int-portaria-perc.cod-estabel = int-portaria-item.cod-estabel
                  AND  int-portaria-perc.seq         = int-portaria-item.seq
                  AND  int-portaria-perc.dt-ini <= da-data
                  AND (int-portaria-perc.dt-fim = ?
                   OR  int-portaria-perc.dt-fim >= da-data): END.
            IF NOT AVAIL int-portaria-perc THEN NEXT.

            FIND FIRST bint-portaria-movto-bem NO-LOCK
                 WHERE bint-portaria-movto-bem.it-codigo     = int-portaria-item.it-codigo   
                   AND bint-portaria-movto-bem.cod-estabel   = int-portaria-item.cod-estabel 
                   AND bint-portaria-movto-bem.seq           = int-portaria-item.seq
                   AND bint-portaria-movto-bem.classificacao = "BEM"
                   AND bint-portaria-movto-bem.dt-ini       <= da-data
                   AND (bint-portaria-movto-bem.dt-fim       = ?
                    OR bint-portaria-movto-bem.dt-fim       >= da-data) NO-ERROR.

            RUN pi-acompanhar IN h-acomp (INPUT "Docto de Saida " + nota-fiscal.nr-nota-fis).
    
            FIND FIRST emitente WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.
            FIND FIRST natur-oper WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-LOCK NO-ERROR.

            IF natur-oper.tipo <> 2 THEN NEXT.
            IF nota-fiscal.esp-docto = 23 THEN NEXT.
            IF natur-oper.atual-estat = NO THEN NEXT.

            RUN ftp/ft0515a.p (INPUT  ROWID(it-nota-fisc), 
                               OUTPUT i-niv-trib-icms,      
                               OUTPUT l-sub).
    
            ASSIGN c-cst = STRING(INT(SUBSTRING(it-nota-fisc.char-1,180,3))) + STRING(i-niv-trib-icms, "99")
                   c-fm-codigo  = item.fm-codigo
                   c-fm-cod-com = item.fm-cod-com.

            FIND FIRST int-it-nota-fisc
                 WHERE int-it-nota-fisc.cod-estabel = it-nota-fisc.cod-estabel
                   AND int-it-nota-fisc.serie       = it-nota-fisc.serie
                   AND int-it-nota-fisc.nr-nota-fis = it-nota-fisc.nr-nota-fis
                   AND int-it-nota-fisc.nr-seq-fat  = it-nota-fisc.nr-seq-fat
                   AND int-it-nota-fisc.it-codigo   = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.
            IF AVAIL int-it-nota-fisc THEN
                ASSIGN c-cst        = IF int-it-nota-fisc.cst        <> "" THEN int-it-nota-fisc.cst        ELSE c-cst       
                       c-fm-codigo  = IF int-it-nota-fisc.fm-codigo  <> "" THEN int-it-nota-fisc.fm-codigo  ELSE c-fm-codigo 
                       c-fm-cod-com = IF int-it-nota-fisc.fm-cod-com <> "" THEN int-it-nota-fisc.fm-cod-com ELSE c-fm-cod-com.

            FIND FIRST fam-comerc WHERE fam-comerc.fm-cod-com = c-fm-cod-com NO-LOCK NO-ERROR.
            FIND FIRST familia WHERE familia.fm-codigo = c-fm-codigo NO-LOCK NO-ERROR.
            FIND FIRST fam-com-item WHERE fam-com-item.fm-cod-com = SUBSTRING(c-fm-cod-com,1,4) NO-LOCK NO-ERROR.

            ASSIGN c-unid-neg = "".

            FIND FIRST unid_negoc NO-LOCK
                 WHERE unid_negoc.cod_unid_negoc = it-nota-fisc.cod-unid-negoc NO-ERROR.
            IF AVAIL unid_negoc THEN
               ASSIGN c-unid-neg  = unid_negoc.cod_unid_negoc.

            for first ponto-programa
                where ponto-programa.nome-programa = "boes513"
                  AND ponto-programa.ponto         = 1,
                 EACH conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                  AND conteudo-programa.sequencia    = int(SUBSTRING(c-fm-cod-com,1,2)):

                FIND FIRST unid_negoc NO-LOCK
                     WHERE unid_negoc.cdn_unid_negoc = INT(conteudo-programa.conteudo) NO-ERROR.
                IF AVAIL unid_negoc THEN
                    ASSIGN c-unid-neg  = unid_negoc.cod_unid_negoc.                  
              
            end. 

            IF AVAIL int-it-nota-fisc THEN
                ASSIGN c-unid-neg   = int-it-nota-fisc.cod-unid-negoc.

            ASSIGN vlr-fcp-it = 0
                   perc-fcp   = 0.
            FOR EACH item-nf-adc NO-LOCK
               WHERE item-nf-adc.cod-estab       = nota-fiscal.cod-estabel
                 and item-nf-adc.cod-serie       = nota-fiscal.serie
                 AND item-nf-adc.cod-nota        = nota-fiscal.nr-nota-fis
                 AND item-nf-adc.cdn-emitente    = nota-fiscal.cod-emitente
                 AND item-nf-adc.cod-natur-oper  = it-nota-fisc.nat-operacao
                 AND item-nf-adc.idi-tip-dado    = 25
                 and item-nf-adc.num-seq         > 0
                 AND item-nf-adc.num-seq-item-nf = it-nota-fisc.nr-seq-fat:
                 assign vlr-fcp-it = vlr-fcp-it + DEC(SUBSTR(item-nf-adc.cod-livre-4,1,30))
                        perc-fcp = item-nf-adc.val-livre-2.
            END.
            
            CREATE tt-nota-fiscal.
            ASSIGN tt-nota-fiscal.cod-estabel          = nota-fiscal.cod-estabel
                   tt-nota-fiscal.serie                = nota-fiscal.serie
                   tt-nota-fiscal.nr-nota-fis          = nota-fiscal.nr-nota-fis
                   tt-nota-fiscal.operacao             = "Faturamento"
                   tt-nota-fiscal.dt-emis-nota         = nota-fiscal.dt-emis-nota
                   tt-nota-fiscal.cod-emitente         = nota-fiscal.cod-emitente
                   tt-nota-fiscal.nome-emit            = emitente.nome-emit
                   tt-nota-fiscal.cgc                  = emitente.cgc
                   tt-nota-fiscal.cidade               = nota-fiscal.cidade
                   tt-nota-fiscal.estado               = nota-fiscal.estado
                   tt-nota-fiscal.nat-operacao         = nota-fiscal.nat-operacao
                   tt-nota-fiscal.cst                  = "'" + c-cst
                   tt-nota-fiscal.aliquota-icm         = it-nota-fisc.aliquota-icm
                   tt-nota-fiscal.aliquota-ipi         = it-nota-fisc.aliquota-ipi
                   tt-nota-fiscal.it-codigo            = it-nota-fisc.it-codigo
                   tt-nota-fiscal.desc-item            = ITEM.desc-item
                   tt-nota-fiscal.class-fiscal         = ITEM.class-fiscal
                   tt-nota-fiscal.cod-unid-negoc       = c-unid-neg
                   tt-nota-fiscal.fm-cod-com           = c-fm-cod-com
                   tt-nota-fiscal.desc-fm-cod-com      = IF AVAIL fam-comerc THEN fam-comerc.descricao ELSE ""
                   tt-nota-fiscal.fm-codigo            = c-fm-codigo
                   tt-nota-fiscal.desc-fm-codigo       = IF AVAIL familia THEN familia.descricao ELSE ""
                   tt-nota-fiscal.qt-faturada          = it-nota-fisc.qt-faturada[1]
                   tt-nota-fiscal.preco-unit           = it-nota-fisc.vl-preuni
                   tt-nota-fiscal.vlr-merc-real        = it-nota-fisc.vl-merc-liq
                   tt-nota-fiscal.vlr-merc-dolar       = ROUND(it-nota-fisc.vl-merc-liq / nota-fiscal.vl-taxa-exp,2)
                   tt-nota-fiscal.vl-frete-it          = it-nota-fisc.vl-frete-it
                   tt-nota-fiscal.vlr-icms             = it-nota-fisc.vl-icms-it
                   tt-nota-fiscal.vl-bicms-it          = it-nota-fisc.vl-bicms-it
                   tt-nota-fiscal.vl-ipi-it            = it-nota-fisc.vl-ipi-it
                   tt-nota-fiscal.base-st              = it-nota-fisc.vl-bsubs-it
                   tt-nota-fiscal.vl-icmsub-it         = it-nota-fisc.vl-icmsub-it
                   tt-nota-fiscal.perc-fcp             = perc-fcp
                   tt-nota-fiscal.vl-fcp               = vlr-fcp-it 
                   tt-nota-fiscal.vl-despes-it         = it-nota-fisc.vl-despes-it
                   tt-nota-fiscal.vl-pis               = IF SUBSTRING(it-nota-fisc.char-2,96,1) = "1" THEN ROUND((it-nota-fisc.vl-merc-liq + it-nota-fisc.vl-despes-it) * DEC(SUBSTRING(it-nota-fisc.char-2,76,5)) / 100,2) ELSE 0
                   tt-nota-fiscal.vl-finsocial         = IF SUBSTRING(it-nota-fisc.char-2,97,1) = "1" THEN ROUND((it-nota-fisc.vl-merc-liq + it-nota-fisc.vl-despes-it) * DEC(SUBSTRING(it-nota-fisc.char-2,81,5)) / 100,2) ELSE 0
                   tt-nota-fiscal.vl-tot-item          = it-nota-fisc.vl-tot-item
                   tt-nota-fiscal.contrib-icms         = IF nota-fiscal.cod-des-merc = 1 THEN "Nao" ELSE "Sim"
                   tt-nota-fiscal.ins-estadual         = emitente.ins-estadual
                   tt-nota-fiscal.nf-orig-devol        = ""
                   tt-nota-fiscal.serie-devol          = ""
                   tt-nota-fiscal.data-devol           = ""
                   tt-nota-fiscal.nat-oper-devol       = ""
                   //tt-nota-fiscal.centro-custo         = IF AVAIL movto-estoq  THEN movto-estoq.sc-codigo  ELSE ""
                   tt-nota-fiscal.centro-custo         = IF AVAIL int-centro-custo THEN int-centro-custo.cc-codigo ELSE ""
                   tt-nota-fiscal.segmento             = IF AVAIL fam-com-item THEN fam-com-item.descricao ELSE ""
                   tt-nota-fiscal.produto-base         = int-portaria-item.produto-base
                   tt-nota-fiscal.desc-mctic           = int-portaria-item.desc-mctic
                   tt-nota-fiscal.ind-item-fat         = STRING(ITEM.ind-item-fat,"Sim/Nao")
                   tt-nota-fiscal.classif-atual        = IF AVAIL bint-portaria-movto-def  THEN bint-portaria-movto-def.classificacao ELSE bint-portaria-movto-prov.classificacao
                   tt-nota-fiscal.portaria-atual       = IF AVAIL bint-portaria-movto-def  THEN bint-portaria-movto-def.codigo        ELSE bint-portaria-movto-prov.codigo
                   tt-nota-fiscal.portaria-def         = IF AVAIL bint-portaria-movto-def  THEN bint-portaria-movto-def.codigo        ELSE ""
                   tt-nota-fiscal.dt-portaria-def      = IF AVAIL bint-portaria-movto-def  THEN STRING(bint-portaria-movto-def.dt-portaria) ELSE ""
                   tt-nota-fiscal.portaria-prov        = IF AVAIL bint-portaria-movto-prov THEN bint-portaria-movto-prov.codigo       ELSE ""
                   tt-nota-fiscal.valid-ini-prov       = IF AVAIL bint-portaria-movto-prov AND bint-portaria-movto-prov.dt-ini <> ? THEN STRING(bint-portaria-movto-prov.dt-ini) ELSE ""
                   tt-nota-fiscal.valid-ini-bem        = IF AVAIL bint-portaria-movto-bem AND bint-portaria-movto-bem.dt-ini <> ? THEN STRING(bint-portaria-movto-bem.dt-ini) ELSE ""
                   tt-nota-fiscal.valid-ini            = IF AVAIL bint-portaria-movto-def AND bint-portaria-movto-def.dt-ini <> ? THEN STRING(bint-portaria-movto-def.dt-ini) ELSE IF AVAIL bint-portaria-movto-prov AND bint-portaria-movto-prov.dt-ini <> ? THEN STRING(bint-portaria-movto-prov.dt-ini) ELSE ""
                   tt-nota-fiscal.valid-fim            = IF AVAIL bint-portaria-movto-def AND bint-portaria-movto-def.dt-fim <> ? THEN STRING(bint-portaria-movto-def.dt-fim) ELSE IF AVAIL bint-portaria-movto-prov AND bint-portaria-movto-prov.dt-fim <> ? THEN STRING(bint-portaria-movto-prov.dt-fim) ELSE ""
                   tt-nota-fiscal.vl-base-contrapart   = it-nota-fisc.vl-merc-liq + it-nota-fisc.vl-frete-it
                   tt-nota-fiscal.log-tec-nacional     = AVAIL bint-portaria-movto-bem
                   tt-nota-fiscal.destino              = "BR".
                                                                                                                
            IF natur-oper.nat-operacao BEGINS "7"
            OR natur-oper.nat-operacao BEGINS "3" THEN DO:
                ASSIGN tt-nota-fiscal.destino = "EX".
                NEXT.
            END.
            IF nota-fiscal.cidade = "MANAUS"
            OR nota-fiscal.cidade = "PRESIDENTE FIGUEIREDO"
            OR nota-fiscal.cidade = "RIO PRETO DA EVA"
            OR nota-fiscal.cidade = "ITACOATIARA" THEN DO:
                ASSIGN tt-nota-fiscal.destino = "ZFM".
                NEXT.
            END.

            IF nota-fiscal.estado = "AM" THEN DO:
                ASSIGN tt-nota-fiscal.destino = "ZFM".
            END.

            ASSIGN tt-nota-fiscal.calc-ext-conv1       = ROUND(tt-nota-fiscal.vl-base-contrapart * int-portaria-perc.aliq-ext-conv1 / 100,2)                                                                           
                   tt-nota-fiscal.calc-ext-conv2a      = ROUND(tt-nota-fiscal.vl-base-contrapart * int-portaria-perc.aliq-ext-conv2a / 100,2)                                                                          
                   tt-nota-fiscal.calc-ext-conv2b      = ROUND(tt-nota-fiscal.vl-base-contrapart * int-portaria-perc.aliq-ext-conv2b / 100,2)                                                                          
                   tt-nota-fiscal.calc-ext-fndct       = ROUND(tt-nota-fiscal.vl-base-contrapart * int-portaria-perc.aliq-ext-fndct / 100,2)                                                                           
                   tt-nota-fiscal.calc-externo         = ROUND(tt-nota-fiscal.calc-ext-conv1 + tt-nota-fiscal.calc-ext-conv2a + tt-nota-fiscal.calc-ext-conv2b + tt-nota-fiscal.calc-ext-fndct,2)       
                   tt-nota-fiscal.calc-interno         = ROUND(tt-nota-fiscal.vl-base-contrapart * int-portaria-perc.aliq-int / 100,2)                                                                                 
                   tt-nota-fiscal.calc-tot             = ROUND(tt-nota-fiscal.calc-externo + tt-nota-fiscal.calc-interno,2)                                                                             
                   tt-nota-fiscal.calc-adic            = ROUND(tt-nota-fiscal.vl-base-contrapart * int-portaria-perc.aliq-adic / 100,2)                                                                                
                   tt-nota-fiscal.calc-cred-prod-hab   = IF NOT AVAIL bint-portaria-movto-bem THEN ROUND(tt-nota-fiscal.vl-base-contrapart * int-portaria-perc.aliq-cred-hab / 100,2) ELSE 0                               
                   tt-nota-fiscal.calc-cred-bem-desenv = IF     AVAIL bint-portaria-movto-bem THEN ROUND(tt-nota-fiscal.vl-base-contrapart * int-portaria-perc.aliq-cred-bem / 100,2) ELSE 0                               
                   tt-nota-fiscal.calc-limit-cred      = ROUND(tt-nota-fiscal.calc-cred-prod-hab + tt-nota-fiscal.calc-cred-bem-desenv,2). 
        
        END.

/*
field portaria-ppb-ini   as char
field portaria-ppb-fim   as char
    */

        FOR EACH docum-est NO-LOCK
           WHERE docum-est.dt-trans     = da-data
             AND docum-est.cod-estabel >= tt-param.estab-ini
             AND docum-est.cod-estabel <= tt-param.estab-fim, 
            EACH item-doc-est OF docum-est NO-LOCK
           WHERE item-doc-est.it-codigo    >= tt-param.item-ini
             AND item-doc-est.it-codigo    <= tt-param.item-fim
             AND item-doc-est.class-fiscal >= tt-param.ncm-ini
             AND item-doc-est.class-fiscal <= tt-param.ncm-fim,
           FIRST item NO-LOCK
           WHERE item.it-codigo     = item-doc-est.it-codigo:

            /*IF nota-fiscal.dt-cancel    <> ? THEN NEXT.*/
            IF item.it-codigo = "" THEN NEXT.

            IF NOT (item.fm-codigo >= tt-param.familia-ini
               AND  item.fm-codigo <= tt-param.familia-fim) THEN NEXT.

            IF NOT (item.fm-cod-com >= tt-param.familia-com-ini
               AND  ITEM.fm-cod-com <= tt-param.familia-com-fim) THEN NEXT.

            FOR FIRST int-portaria-item NO-LOCK
                WHERE int-portaria-item.it-codigo   = ITEM.it-codigo
                  AND int-portaria-item.cod-estabel = docum-est.cod-estabel: END.
            IF NOT AVAIL int-portaria-item THEN NEXT.

            FIND FIRST nota-fiscal
                 WHERE nota-fiscal.cod-estabel = docum-est.cod-estabel
                   AND nota-fiscal.serie       = item-doc-est.serie-comp
                   AND nota-fiscal.nr-nota-fis = item-doc-est.nro-comp NO-LOCK NO-ERROR.

            IF AVAIL nota-fiscal THEN DO:
                IF nota-fiscal.dt-cancel    <> ? THEN NEXT.
                IF nota-fiscal.idi-sit-nf-eletro <> 3 THEN NEXT.
            END.

            FIND LAST bint-portaria-movto-def NO-LOCK
                WHERE bint-portaria-movto-def.it-codigo     = int-portaria-item.it-codigo  
                  AND bint-portaria-movto-def.cod-estabel   = int-portaria-item.cod-estabel
                  AND bint-portaria-movto-def.seq           = int-portaria-item.seq        
                  AND bint-portaria-movto-def.dt-ini <= (IF AVAIL nota-fiscal THEN nota-fiscal.dt-emis-nota ELSE da-data)
                  AND (bint-portaria-movto-def.dt-fim = ?
                   OR bint-portaria-movto-def.dt-fim >= (IF AVAIL nota-fiscal THEN nota-fiscal.dt-emis-nota ELSE da-data))
                  AND bint-portaria-movto-def.classificacao = "DEF" NO-ERROR.

            FIND LAST bint-portaria-movto-prov NO-LOCK
                WHERE bint-portaria-movto-prov.it-codigo     = int-portaria-item.it-codigo  
                  AND bint-portaria-movto-prov.cod-estabel   = int-portaria-item.cod-estabel
                  AND bint-portaria-movto-prov.seq           = int-portaria-item.seq        
                  AND bint-portaria-movto-prov.dt-ini <= (IF AVAIL nota-fiscal THEN nota-fiscal.dt-emis-nota ELSE da-data)
                  //AND (bint-portaria-movto-prov.dt-fim = ?
                  // OR bint-portaria-movto-prov.dt-fim >= (IF AVAIL nota-fiscal THEN nota-fiscal.dt-emis-nota ELSE da-data))
                  AND bint-portaria-movto-prov.classificacao = "PROV" NO-ERROR.

            IF  NOT AVAIL bint-portaria-movto-def
            AND NOT AVAIL bint-portaria-movto-prov THEN NEXT.

            FOR FIRST int-portaria-perc NO-LOCK
                WHERE  int-portaria-perc.it-codigo   = int-portaria-item.it-codigo
                  AND  int-portaria-perc.cod-estabel = int-portaria-item.cod-estabel
                  AND  int-portaria-perc.seq         = int-portaria-item.seq
                  AND  int-portaria-perc.dt-ini     <= (IF AVAIL nota-fiscal THEN nota-fiscal.dt-emis-nota ELSE da-data)
                  AND (int-portaria-perc.dt-fim      = ?
                   OR  int-portaria-perc.dt-fim     >= (IF AVAIL nota-fiscal THEN nota-fiscal.dt-emis-nota ELSE da-data)): END.
            IF NOT AVAIL int-portaria-perc THEN NEXT.

            FIND FIRST bint-portaria-movto-bem NO-LOCK
                 WHERE bint-portaria-movto-bem.it-codigo     = int-portaria-item.it-codigo   
                   AND bint-portaria-movto-bem.cod-estabel   = int-portaria-item.cod-estabel 
                   AND bint-portaria-movto-bem.seq           = int-portaria-item.seq
                   AND bint-portaria-movto-bem.classificacao = "BEM"
                   AND bint-portaria-movto-bem.dt-ini       <= (IF AVAIL nota-fiscal THEN nota-fiscal.dt-emis-nota ELSE da-data)
                   AND (bint-portaria-movto-bem.dt-fim       = ?
                    OR bint-portaria-movto-bem.dt-fim       >= (IF AVAIL nota-fiscal THEN nota-fiscal.dt-emis-nota ELSE da-data)) NO-ERROR.

            RUN pi-acompanhar IN h-acomp (INPUT "Docto de Entrada " + docum-est.nro-docto).

            FIND FIRST devol-cli OF docum-est NO-LOCK NO-ERROR.
            FIND FIRST natur-oper WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.
            FIND FIRST emitente WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.
            
            IF natur-oper.tipo <> 1 THEN NEXT.
            IF docum-est.esp-docto = 23 THEN NEXT.

            /* Somente lista as CFOPs cadastradas no ES0018 - ESFTP126 - Ponto 1 */
            FIND FIRST tt-prog-ponto
                 WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = natur-oper.cod-cfop NO-ERROR.
            IF NOT AVAIL tt-prog-ponto THEN NEXT.

            /*FOR FIRST movto-estoq
                WHERE movto-estoq.serie-docto  = item-doc-est.serie-docto 
                AND   movto-estoq.nro-docto    = item-doc-est.nro-docto   
                AND   movto-estoq.cod-emitente = item-doc-est.cod-emitente
                AND   movto-estoq.nat-operacao = item-doc-est.nat-operacao
                AND   movto-estoq.sequen-nf    = item-doc-est.sequencia
                AND   movto-estoq.it-codigo    = ITEM.it-codigo NO-LOCK: END.*/

            /*FIND FIRST int-centro-custo NO-LOCK
                 WHERE int-centro-custo.cod-estabel    = docum-est.cod-estabel
                   AND int-centro-custo.cod-unid-negoc = IF AVAIL it-nota-fisc THEN it-nota-fisc.cod-unid-negoc ELSE IF item.cod-unid-negoc <> "" THEN item.cod-unid-negoc ELSE item-doc-est.cod-unid-negoc NO-ERROR.
           */

            FIND FIRST it-nota-fisc
                 WHERE it-nota-fisc.cod-estabel = docum-est.cod-estabel
                   AND it-nota-fisc.serie       = item-doc-est.serie-comp
                   AND it-nota-fisc.nr-nota-fis = item-doc-est.nro-comp 
                   AND it-nota-fisc.nr-seq-fat  = item-doc-est.seq-comp
                   AND it-nota-fisc.it-codigo   = item-doc-est.it-codigo NO-LOCK NO-ERROR.
            IF AVAIL it-nota-fisc THEN
                IF it-nota-fisc.atual-estat = NO THEN NEXT.

            IF AVAIL it-nota-fisc THEN DO:
                RUN ftp/ft0515a.p (INPUT  ROWID(it-nota-fisc), 
                                   OUTPUT i-niv-trib-icms,      
                                   OUTPUT l-sub).
                ASSIGN c-cst = SUBSTRING(item-doc-est.char-2,502,1) + STRING(i-niv-trib-icms, "99").
            END.
            ELSE ASSIGN c-cst = "".

            ASSIGN c-fm-codigo  = item.fm-codigo
                   c-fm-cod-com = item.fm-cod-com.

            IF AVAIL it-nota-fisc THEN
                FIND FIRST int-it-nota-fisc
                     WHERE int-it-nota-fisc.cod-estabel = it-nota-fisc.cod-estabel
                       AND int-it-nota-fisc.serie       = it-nota-fisc.serie
                       AND int-it-nota-fisc.nr-nota-fis = it-nota-fisc.nr-nota-fis
                       AND int-it-nota-fisc.nr-seq-fat  = it-nota-fisc.nr-seq-fat
                       AND int-it-nota-fisc.it-codigo   = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.
                IF AVAIL int-it-nota-fisc THEN
                    ASSIGN c-cst        = IF int-it-nota-fisc.cst        <> "" THEN int-it-nota-fisc.cst        ELSE c-cst       
                           c-fm-codigo  = IF int-it-nota-fisc.fm-codigo  <> "" THEN int-it-nota-fisc.fm-codigo  ELSE c-fm-codigo 
                           c-fm-cod-com = IF int-it-nota-fisc.fm-cod-com <> "" THEN int-it-nota-fisc.fm-cod-com ELSE c-fm-cod-com.

            FIND FIRST fam-comerc WHERE fam-comerc.fm-cod-com = c-fm-cod-com NO-LOCK NO-ERROR.
            FIND FIRST familia WHERE familia.fm-codigo = c-fm-codigo NO-LOCK NO-ERROR.
            FIND FIRST fam-com-item WHERE fam-com-item.fm-cod-com = SUBSTRING(c-fm-cod-com,1,4) NO-LOCK NO-ERROR.

            ASSIGN c-unid-neg = "".

            FIND FIRST unid_negoc NO-LOCK
                 WHERE unid_negoc.cod_unid_negoc = IF AVAIL it-nota-fisc THEN it-nota-fisc.cod-unid-negoc ELSE IF item.cod-unid-negoc <> "" THEN item.cod-unid-negoc ELSE item-doc-est.cod-unid-negoc NO-ERROR.
            IF AVAIL unid_negoc THEN
               ASSIGN c-unid-neg  = unid_negoc.cod_unid_negoc.

            for first ponto-programa
                where ponto-programa.nome-programa = "boes513"
                  AND ponto-programa.ponto         = 1,
                 EACH conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                  AND conteudo-programa.sequencia    = int(SUBSTRING(c-fm-cod-com,1,2)):

                FIND FIRST unid_negoc NO-LOCK
                     WHERE unid_negoc.cdn_unid_negoc = INT(conteudo-programa.conteudo) NO-ERROR.
                IF AVAIL unid_negoc THEN
                    ASSIGN c-unid-neg  = unid_negoc.cod_unid_negoc.                  
              
            end. 

            IF AVAIL int-it-nota-fisc THEN
                ASSIGN c-unid-neg   = int-it-nota-fisc.cod-unid-negoc.

            ASSIGN vlr-fcp-it = 0
                   perc-fcp   = 0.
            FOR EACH item-nf-adc NO-LOCK
               WHERE item-nf-adc.cod-estab       = nota-fiscal.cod-estabel
                 and item-nf-adc.cod-serie       = nota-fiscal.serie
                 AND item-nf-adc.cod-nota        = nota-fiscal.nr-nota-fis
                 AND item-nf-adc.cdn-emitente    = nota-fiscal.cod-emitente
                 AND item-nf-adc.cod-natur-oper  = it-nota-fisc.nat-operacao
                 AND item-nf-adc.idi-tip-dado    = 25
                 and item-nf-adc.num-seq         > 0
                 AND item-nf-adc.num-seq-item-nf = it-nota-fisc.nr-seq-fat:
                 assign vlr-fcp-it = vlr-fcp-it + DEC(SUBSTR(item-nf-adc.cod-livre-4,1,30))
                        perc-fcp = item-nf-adc.val-livre-2.
            END.

            CREATE tt-nota-fiscal.
            ASSIGN tt-nota-fiscal.cod-estabel          = docum-est.cod-estabel
                   tt-nota-fiscal.serie                = docum-est.serie-docto
                   tt-nota-fiscal.nr-nota-fis          = docum-est.nro-docto
                   tt-nota-fiscal.operacao             = "Devolu‡Æo"
                   tt-nota-fiscal.dt-emis-nota         = docum-est.dt-trans
                   tt-nota-fiscal.cod-emitente         = docum-est.cod-emitente
                   tt-nota-fiscal.nome-emit            = emitente.nome-emit
                   tt-nota-fiscal.cgc                  = emitente.cgc
                   tt-nota-fiscal.cidade               = docum-est.cidade
                   tt-nota-fiscal.estado               = docum-est.uf
                   tt-nota-fiscal.nat-operacao         = docum-est.nat-operacao
                   tt-nota-fiscal.cst                  = "'" + c-cst
                   tt-nota-fiscal.aliquota-icm         = item-doc-est.aliquota-icm
                   tt-nota-fiscal.aliquota-ipi         = item-doc-est.aliquota-ipi
                   tt-nota-fiscal.it-codigo            = item-doc-est.it-codigo
                   tt-nota-fiscal.desc-item            = ITEM.desc-item
                   tt-nota-fiscal.class-fiscal         = ITEM.class-fiscal
                   tt-nota-fiscal.cod-unid-negoc       = c-unid-neg
                   tt-nota-fiscal.fm-cod-com           = c-fm-cod-com
                   tt-nota-fiscal.desc-fm-cod-com      = IF AVAIL fam-comerc THEN fam-comerc.descricao ELSE ""
                   tt-nota-fiscal.fm-codigo            = c-fm-codigo
                   tt-nota-fiscal.desc-fm-codigo       = IF AVAIL familia THEN familia.descricao ELSE ""
                   tt-nota-fiscal.qt-faturada          = item-doc-est.quantidade * -1
                   tt-nota-fiscal.preco-unit           = item-doc-est.preco-unit[1] * -1
                   tt-nota-fiscal.vlr-merc-real        = (item-doc-est.preco-total[1] - item-doc-est.desconto[1]) * -1
                   tt-nota-fiscal.vlr-merc-dolar       = ROUND((item-doc-est.preco-total[1] - item-doc-est.desconto[1])  / IF AVAIL nota-fiscal THEN nota-fiscal.vl-taxa-exp ELSE 1,2) * -1
                   tt-nota-fiscal.vl-frete-it          = item-doc-est.valor-frete * -1
                   tt-nota-fiscal.vlr-icms             = item-doc-est.valor-icm[1] * -1
                   tt-nota-fiscal.vl-bicms-it          = item-doc-est.base-icm[1] * -1
                   tt-nota-fiscal.vl-ipi-it            = item-doc-est.valor-ipi[1] * -1
                   tt-nota-fiscal.base-st              = item-doc-est.base-subs[1] * -1
                   tt-nota-fiscal.vl-icmsub-it         = item-doc-est.vl-subs[1] * -1
                   tt-nota-fiscal.perc-fcp             = perc-fcp * -1
                   tt-nota-fiscal.vl-fcp               = vlr-fcp-it * -1
                   tt-nota-fiscal.vl-despes-it         = item-doc-est.despesas[1] * -1
                   tt-nota-fiscal.vl-pis               = item-doc-est.valor-pis * -1
                   tt-nota-fiscal.vl-finsocial         = item-doc-est.val-cofins * -1
                   tt-nota-fiscal.vl-tot-item          = (item-doc-est.preco-total[1] + item-doc-est.valor-ipi[1]) * -1
                   tt-nota-fiscal.contrib-icms         = IF AVAIL nota-fiscal THEN IF nota-fiscal.cod-des-merc = 1 THEN "Nao" ELSE "Sim" ELSE STRING(emitente.contrib-icms,"Sim/Nao")
                   tt-nota-fiscal.ins-estadual         = emitente.ins-estadual
                   tt-nota-fiscal.nf-orig-devol        = IF AVAIL nota-fiscal THEN nota-fiscal.nr-nota-fis ELSE ""
                   tt-nota-fiscal.serie-devol          = IF AVAIL nota-fiscal THEN nota-fiscal.serie ELSE ""
                   tt-nota-fiscal.data-devol           = IF AVAIL nota-fiscal THEN STRING(nota-fiscal.dt-emis-nota) ELSE ""
                   tt-nota-fiscal.nat-oper-devol       = IF AVAIL nota-fiscal THEN nota-fiscal.nat-operacao ELSE ""
                   //tt-nota-fiscal.centro-custo         = IF AVAIL movto-estoq  THEN movto-estoq.sc-codigo  ELSE ""
                   tt-nota-fiscal.centro-custo         = IF AVAIL int-centro-custo THEN int-centro-custo.cc-codigo ELSE ""
                   tt-nota-fiscal.segmento             = IF AVAIL fam-com-item THEN fam-com-item.descricao ELSE ""
                   tt-nota-fiscal.produto-base         = int-portaria-item.produto-base
                   tt-nota-fiscal.desc-mctic           = int-portaria-item.desc-mctic
                   tt-nota-fiscal.ind-item-fat         = STRING(ITEM.ind-item-fat,"Sim/Nao")
                   tt-nota-fiscal.classif-atual        = IF AVAIL bint-portaria-movto-def  THEN bint-portaria-movto-def.classificacao ELSE bint-portaria-movto-prov.classificacao
                   tt-nota-fiscal.portaria-atual       = IF AVAIL bint-portaria-movto-def  THEN bint-portaria-movto-def.codigo        ELSE bint-portaria-movto-prov.codigo
                   tt-nota-fiscal.portaria-def         = IF AVAIL bint-portaria-movto-def  THEN bint-portaria-movto-def.codigo        ELSE ""
                   tt-nota-fiscal.dt-portaria-def      = IF AVAIL bint-portaria-movto-def  THEN STRING(bint-portaria-movto-def.dt-portaria) ELSE ""
                   tt-nota-fiscal.portaria-prov        = IF AVAIL bint-portaria-movto-prov THEN bint-portaria-movto-prov.codigo       ELSE ""
                   tt-nota-fiscal.valid-ini-prov       = IF AVAIL bint-portaria-movto-prov AND bint-portaria-movto-prov.dt-ini <> ? THEN STRING(bint-portaria-movto-prov.dt-ini) ELSE ""
                   tt-nota-fiscal.valid-ini-bem        = IF AVAIL bint-portaria-movto-bem AND bint-portaria-movto-bem.dt-ini <> ? THEN STRING(bint-portaria-movto-bem.dt-ini) ELSE ""
                   tt-nota-fiscal.valid-ini            = IF AVAIL bint-portaria-movto-def AND bint-portaria-movto-def.dt-ini <> ? THEN STRING(bint-portaria-movto-def.dt-ini) ELSE IF AVAIL bint-portaria-movto-prov AND bint-portaria-movto-prov.dt-ini <> ? THEN STRING(bint-portaria-movto-prov.dt-ini) ELSE ""
                   tt-nota-fiscal.valid-fim            = IF AVAIL bint-portaria-movto-def AND bint-portaria-movto-def.dt-fim <> ? THEN STRING(bint-portaria-movto-def.dt-fim) ELSE IF AVAIL bint-portaria-movto-prov AND bint-portaria-movto-prov.dt-fim <> ? THEN STRING(bint-portaria-movto-prov.dt-fim) ELSE ""
                   tt-nota-fiscal.vl-base-contrapart   = (item-doc-est.preco-total[1] - item-doc-est.desconto[1] + item-doc-est.valor-frete) * -1.
                   tt-nota-fiscal.destino              = "BR".

                IF natur-oper.nat-operacao BEGINS "7"
                OR natur-oper.nat-operacao BEGINS "3" THEN DO:
                    ASSIGN tt-nota-fiscal.destino = "EX".
                    NEXT.
                END.
                IF docum-est.cidade = "MANAUS"
                OR docum-est.cidade = "PRESIDENTE FIGUEIREDO"
                OR docum-est.cidade = "RIO PRETO DA EVA"
                OR docum-est.cidade = "ITACOATIARA" THEN DO:
                    ASSIGN tt-nota-fiscal.destino = "ZFM".
                    NEXT.
                END.
    
                IF docum-est.uf = "AM" THEN DO:
                    ASSIGN tt-nota-fiscal.destino = "ZFM".
                END.

                IF NOT AVAIL nota-fiscal  THEN NEXT.
                IF NOT AVAIL it-nota-fisc THEN NEXT.
        
                ASSIGN tt-nota-fiscal.calc-ext-conv1       = ROUND(tt-nota-fiscal.vl-base-contrapart * int-portaria-perc.aliq-ext-conv1 / 100,2)                                                                        
                       tt-nota-fiscal.calc-ext-conv2a      = ROUND(tt-nota-fiscal.vl-base-contrapart * int-portaria-perc.aliq-ext-conv2a / 100,2)                                                                        
                       tt-nota-fiscal.calc-ext-conv2b      = ROUND(tt-nota-fiscal.vl-base-contrapart * int-portaria-perc.aliq-ext-conv2b / 100,2)                                                                          
                       tt-nota-fiscal.calc-ext-fndct       = ROUND(tt-nota-fiscal.vl-base-contrapart * int-portaria-perc.aliq-ext-fndct / 100,2)                                                                          
                       tt-nota-fiscal.calc-externo         = ROUND(tt-nota-fiscal.calc-ext-conv1 + tt-nota-fiscal.calc-ext-conv2a + tt-nota-fiscal.calc-ext-conv2b + tt-nota-fiscal.calc-ext-fndct,2)       
                       tt-nota-fiscal.calc-interno         = ROUND(tt-nota-fiscal.vl-base-contrapart * int-portaria-perc.aliq-int / 100,2)                                                                                
                       tt-nota-fiscal.calc-tot             = ROUND(tt-nota-fiscal.calc-externo + tt-nota-fiscal.calc-interno,2)                                                                             
                       tt-nota-fiscal.calc-adic            = ROUND(tt-nota-fiscal.vl-base-contrapart * int-portaria-perc.aliq-adic / 100,2)                                                                               
                       tt-nota-fiscal.calc-cred-prod-hab   = IF NOT AVAIL bint-portaria-movto-bem THEN ROUND(tt-nota-fiscal.vl-base-contrapart * int-portaria-perc.aliq-cred-hab / 100,2) ELSE 0                               
                       tt-nota-fiscal.calc-cred-bem-desenv = IF     AVAIL bint-portaria-movto-bem THEN ROUND(tt-nota-fiscal.vl-base-contrapart * int-portaria-perc.aliq-cred-bem / 100,2) ELSE 0                               
                       tt-nota-fiscal.calc-limit-cred      = ROUND(tt-nota-fiscal.calc-cred-prod-hab + tt-nota-fiscal.calc-cred-bem-desenv,2).

        END.
    END.

END PROCEDURE.

PROCEDURE pi-imprime :
/*------------------------------------------------------------------------------
  Purpose:     <none>
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/

    DEF VAR c-arq-excel AS CHAR NO-UNDO.
    DEF VAR c-dir-saida AS CHAR NO-UNDO.

    //IF tt-param.destino = 2 THEN
        ASSIGN c-arq-excel = "esftp126-" + STRING(TIME) + ".csv":U.
    //ELSE
        //ASSIGN c-arq-excel = tt-param.arquivo.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arq-excel).
    END. 
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arq-excel).
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Relat¢rio...":U).

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Acompanhando...":U).

    OUTPUT TO VALUE(c-arq-excel) CONVERT TARGET "iso8859-1".

    PUT UNFORMATTED "Est;Ser;Nr.Nota;Operacao;Dt.Emissao;Cliente;Nome;CGC;Cidade;UF;Natur.;ST;ICMS%;IPI%;Item;Familia Materiais;Descricao Familia Materiais;Quantidade;Pre‡o Unit rio;Vlr.Merc.(Real);Vlr.Merc.(Dolar);Frete;Vlr ICMS;Base Calculo ICMS;Vlr.IPI;Vl.Base S.Trib.;ICMS Sub.Tr.;% FCP;Vl FCP;Despesas;Vlr PIS;vlr COFINS;Vl.Tot.NF;CF;Ins Estad.;Nota Origem Devolucao;Serie;Data Origem;Natureza;C.C.;Segmento;Item Fat;Classif Atual;Portaria Atual;Descricao do Item;Desc Item MCTIC;Cl. Fiscal;Unidade Neg;Familia Comercial;Descricao Familia Comercial;Portaria Def;Produto Base;Valid Ini Bem;Valid Ini Prov;Dt Portaria;Portaria Prov;Valid Ini;Valid Fim;Base Contrapartida;Ext Conv1;Ext Conv2a;Ext Conv2b;Ext FNDCT;%Externo;%Interno;Tot Contra Partida;Calc %Adic P&D;Calc Cred Prod Habilit;Calc Cred Bem Desenv;Limite Cred;" SKIP. 

    FOR EACH tt-nota-fiscal:
        PUT UNFORMATTED
            tt-nota-fiscal.cod-estabel          ";"
            tt-nota-fiscal.serie                ";"
            tt-nota-fiscal.nr-nota-fis          ";"
            tt-nota-fiscal.operacao             ";"
            tt-nota-fiscal.dt-emis-nota         ";"
            tt-nota-fiscal.cod-emitente         ";"
            tt-nota-fiscal.nome-emit            ";"
            tt-nota-fiscal.cgc                  ";"
            tt-nota-fiscal.cidade               ";"
            tt-nota-fiscal.estado               ";"
            tt-nota-fiscal.nat-operacao         ";"
            tt-nota-fiscal.cst                  ";"
            tt-nota-fiscal.aliquota-icm         ";"
            tt-nota-fiscal.aliquota-ipi         ";"
            tt-nota-fiscal.it-codigo            ";"
            tt-nota-fiscal.fm-codigo            ";"
            tt-nota-fiscal.desc-fm-codigo       ";"
            tt-nota-fiscal.qt-faturada          ";"
            tt-nota-fiscal.preco-unit           ";"
            tt-nota-fiscal.vlr-merc-real        ";"
            tt-nota-fiscal.vlr-merc-dolar       ";"
            tt-nota-fiscal.vl-frete-it          ";"
            tt-nota-fiscal.vlr-icms             ";"
            tt-nota-fiscal.vl-bicms-it          ";"
            tt-nota-fiscal.vl-ipi-it            ";"
            tt-nota-fiscal.base-st              ";"
            tt-nota-fiscal.vl-icmsub-it         ";"
            tt-nota-fiscal.perc-fcp             ";"
            tt-nota-fiscal.vl-fcp               ";"
            tt-nota-fiscal.vl-despes-it         ";"
            tt-nota-fiscal.vl-pis               ";"
            tt-nota-fiscal.vl-finsocial         ";"
            tt-nota-fiscal.vl-tot-item          ";"
            tt-nota-fiscal.contrib-icms         ";"
            tt-nota-fiscal.ins-estadual         ";"
            tt-nota-fiscal.nf-orig-devol        ";"
            tt-nota-fiscal.serie-devol          ";"
            tt-nota-fiscal.data-devol           ";"
            tt-nota-fiscal.nat-oper-devol       ";"
            tt-nota-fiscal.centro-custo         ";"
            tt-nota-fiscal.segmento             ";"
            tt-nota-fiscal.ind-item-fat         ";"
            tt-nota-fiscal.classif-atual        ";"
            tt-nota-fiscal.portaria-atual       ";"
            tt-nota-fiscal.desc-item            ";"
            tt-nota-fiscal.desc-mctic           ";"
            tt-nota-fiscal.class-fiscal         ";"
            tt-nota-fiscal.cod-unid-negoc       ";"
            tt-nota-fiscal.fm-cod-com           ";"
            tt-nota-fiscal.desc-fm-cod-com      ";"
            tt-nota-fiscal.portaria-def         ";"
            tt-nota-fiscal.produto-base         ";"
            tt-nota-fiscal.valid-ini-bem        ";"
            tt-nota-fiscal.valid-ini-prov       ";"
            tt-nota-fiscal.dt-portaria-def      ";"
            tt-nota-fiscal.portaria-prov        ";"
            tt-nota-fiscal.valid-ini            ";"
            tt-nota-fiscal.valid-fim            ";"
            tt-nota-fiscal.vl-base-contrapart   ";"
            tt-nota-fiscal.calc-ext-conv1       ";"
            tt-nota-fiscal.calc-ext-conv2a      ";"
            tt-nota-fiscal.calc-ext-conv2b      ";"
            tt-nota-fiscal.calc-ext-fndct       ";"
            tt-nota-fiscal.calc-externo         ";"
            tt-nota-fiscal.calc-interno         ";"
            tt-nota-fiscal.calc-tot             ";"
            tt-nota-fiscal.calc-adic            ";"
            tt-nota-fiscal.calc-cred-prod-hab   ";"
            tt-nota-fiscal.calc-cred-bem-desenv ";"
            tt-nota-fiscal.calc-limit-cred      ";"
            SKIP.
        
    END.         

    OUTPUT CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-totaliza:

    FOR EACH tt-nota-fiscal:

        FOR FIRST tt-nota-fiscal-totaliza
            WHERE tt-nota-fiscal-totaliza.produto-base = tt-nota-fiscal.produto-base: END.
        IF NOT AVAIL tt-nota-fiscal-totaliza THEN DO:
            CREATE tt-nota-fiscal-totaliza.
            ASSIGN tt-nota-fiscal-totaliza.log-tec-nacional = tt-nota-fiscal.log-tec-nacional
                   tt-nota-fiscal-totaliza.produto-base     = tt-nota-fiscal.produto-base  
                   tt-nota-fiscal-totaliza.portaria-atual   = tt-nota-fiscal.portaria-atual
                   tt-nota-fiscal-totaliza.class-fiscal     = tt-nota-fiscal.class-fiscal  
                   tt-nota-fiscal-totaliza.data-dou         = tt-nota-fiscal.dt-portaria-def.
        END.

        IF tt-nota-fiscal.operacao = "Faturamento" THEN DO:
        
            IF tt-nota-fiscal.destino = "BR" THEN
                ASSIGN tt-nota-fiscal-totaliza.vl-fat-bruto  = tt-nota-fiscal-totaliza.vl-fat-bruto  + tt-nota-fiscal.vl-tot-item - tt-nota-fiscal.vl-frete-it.
    
            IF tt-nota-fiscal.destino = "EX" THEN
                ASSIGN tt-nota-fiscal-totaliza.vl-fat-export = tt-nota-fiscal-totaliza.vl-fat-export + tt-nota-fiscal.vl-base-contrapart.
    
            IF tt-nota-fiscal.destino = "ZFM" THEN
                ASSIGN tt-nota-fiscal-totaliza.vl-fat-zfm    = tt-nota-fiscal-totaliza.vl-fat-zfm    + tt-nota-fiscal.vl-base-contrapart.
    
            ASSIGN tt-nota-fiscal-totaliza.qt-produzida      = tt-nota-fiscal-totaliza.qt-produzida  + tt-nota-fiscal.qt-faturada
                   tt-nota-fiscal-totaliza.vl-ipi            = tt-nota-fiscal-totaliza.vl-ipi        + tt-nota-fiscal.vl-ipi-it
                   tt-nota-fiscal-totaliza.vl-pis-cofins     = tt-nota-fiscal-totaliza.vl-pis-cofins + tt-nota-fiscal.vl-pis + tt-nota-fiscal.vl-finsocial
                   tt-nota-fiscal-totaliza.vl-icms           = tt-nota-fiscal-totaliza.vl-icms       + tt-nota-fiscal.vlr-icms.
        END.
        ELSE DO:
            ASSIGN tt-nota-fiscal-totaliza.vl-devol          = tt-nota-fiscal-totaliza.vl-devol      + ((tt-nota-fiscal.vl-base-contrapart + tt-nota-fiscal.vl-icmsub-it) * -1).
        END.
        ASSIGN tt-nota-fiscal-totaliza.vl-aquis              = 0
               tt-nota-fiscal-totaliza.vl-ipi-ia             = 0
               tt-nota-fiscal-totaliza.vl-icms-ia            = 0.

    END.

END PROCEDURE.

PROCEDURE pi-imprime-totaliza:

    DEF VAR c-arq-excel AS CHAR NO-UNDO.
    DEF VAR c-dir-saida AS CHAR NO-UNDO.

    //IF tt-param.destino = 2 THEN
        ASSIGN c-arq-excel = "esftp126-" + STRING(TIME) + ".csv":U.
    //ELSE
        //ASSIGN c-arq-excel = tt-param.arquivo.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arq-excel).
    END. 
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arq-excel).
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Relat¢rio...":U).

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Acompanhando...":U).

    OUTPUT TO VALUE(c-arq-excel) CONVERT TARGET "iso8859-1".

    PUT UNFORMATTED "Produto de Tec. Nac; Nome do Produto Base; Portaria; NCM; Data Dou; Quant. Produzida; Fat. Bruto no MI; Exporta‡äes; Venda P/ZFM; IPI; PIS/COFINS; ICMS; Aquisi‡äes; Devolu‡äes; IPI I.A; ICMS I.A;" SKIP.
    
    FOR EACH tt-nota-fiscal-totaliza:

        PUT UNFORMATTED
            STRING(tt-nota-fiscal-totaliza.log-tec-nacional,"Sim/Nao") ";"
            tt-nota-fiscal-totaliza.produto-base                      ";"
            tt-nota-fiscal-totaliza.portaria-atual                    ";"
            tt-nota-fiscal-totaliza.class-fiscal                      ";"
            tt-nota-fiscal-totaliza.data-dou                          ";"
            tt-nota-fiscal-totaliza.qt-produzida                      ";"
            tt-nota-fiscal-totaliza.vl-fat-bruto                      ";"
            tt-nota-fiscal-totaliza.vl-fat-export                     ";"
            tt-nota-fiscal-totaliza.vl-fat-zfm                        ";"
            tt-nota-fiscal-totaliza.vl-ipi                            ";"
            tt-nota-fiscal-totaliza.vl-pis-cofins                     ";"
            tt-nota-fiscal-totaliza.vl-icms                           ";"
            tt-nota-fiscal-totaliza.vl-aquis                          ";"
            tt-nota-fiscal-totaliza.vl-devol                          ";"
            tt-nota-fiscal-totaliza.vl-ipi-ia                         ";"
            tt-nota-fiscal-totaliza.vl-icms-ia                        ";"
            SKIP.

    END.         

    OUTPUT CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

    RETURN "OK":U.

END PROCEDURE.
