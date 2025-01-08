/***********************************************************************
**  Programa..: ESP\REP\ESFTP087RP.P
**  Autor.....: Anderson Cenci
**  Data......: Julho/2012 - Desenvolvimento
**  Descricao.: NF de Saida - mp563
**  VersÆo....: 001 18/072012
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESFTP087 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/ftp/esftp087tt.i}

{utp/ut-glob.i}
{include/i-rpvar.i}

DEF VAR c-key-value            AS CHARACTER.
def var c-grade-cont           as char no-undo.
def var c-cab-5-1              as char no-undo.
def var c-cab-corpo-1          as char no-undo.
def var c-cab-corpo-2          as char no-undo.
def var c-cab-corpo-3          as char no-undo.
def var c-cab-corpo-4          as char no-undo.
def var de-total-c    as decimal format ">>>,>>>,>>9.99".
def var de-total-d    as decimal format ">>>,>>>,>>9.99".
def var c-dc          as char format "x(01)".
def var de-valor-d    like docum-est.tot-valor init 0.
def var de-valor      as decimal no-undo.
def var l-indicador   as logical no-undo.
DEFINE VARIABLE c-tp-item AS CHARACTER FORMAT "X(25)"  NO-UNDO.
def var h-cd9500               as handle no-undo.
deF VAR de-taxa-cofins AS DECIMAL.
DEF VAR de-desconto AS decimal.
DEF VAR de-desc-acum AS DECIMAL.
def var c-separador  as char format "x(2)".
def new shared var c-tabela      as character format "x(11)" init "1,2,3,4,5,6,7".
def new shared var r-nota            as rowid   no-undo.

def new shared var grade-contabil as logical no-undo format "Sim/Nao" init "Nao".
def new shared var i-branco       as integer no-undo.
def new shared var i-contador     as integer.
def new shared var i-cont         as int.
def new shared var i-sequencia    as integer                  no-undo.
def new shared var r-conta-ft     as rowid.
def new shared var i-ct-conta     like conta-contab.ct-codigo no-undo.
def new shared var i-sc-conta     like conta-contab.sc-codigo no-undo.
def new shared var i-vl-debito    like sumar-ft.vl-contab format "->>,>>>,>>9.99" no-undo.
def new shared var i-vl-credito   like sumar-ft.vl-contab format "->>,>>>,>>9.99" no-undo.
def new shared var imp-cod as logical format "Codigo/Nome" init yes no-undo.
def new shared var de-vl-contab   like sumar-ft.vl-contab     no-undo.

DEFINE VARIABLE c-desc-prod AS CHARACTER FORMAT "x(100)"  NO-UNDO.
DEFINE VARIABLE c-unid-nota AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-unid-neg AS CHARACTER   NO-UNDO.
def var de-cotacao        as decimal no-undo.
def var da-data           as date    no-undo.
def var de-vl-merc-liq    like it-nota-fisc.vl-merc-liq    no-undo.
def var de-vl-merc-liq-me like it-nota-fisc.vl-merc-liq-me no-undo.
def var de-vl-frete-it    like it-nota-fisc.vl-frete-it    no-undo.
def var de-vl-icms-it     like it-nota-fisc.vl-icms-it     no-undo.
def var de-vl-ipi-it      like it-nota-fisc.vl-ipi-it      no-undo.
def var de-vl-despes-it   like it-nota-fisc.vl-despes-it   no-undo.
def var de-vl-pis         like it-nota-fisc.vl-pis         no-undo.
def var de-vl-finsocial   like it-nota-fisc.vl-finsocial   no-undo. 
def var de-vl-tot-item    like it-nota-fisc.vl-tot-item    no-undo.
def var de-valor-contabil as decimal format ">>>,>>>,>>9.99" no-undo.
def var de-vl-icmsub-it   as decimal format ">>>,>>>,>>9.99" no-undo.
def var de-vl-bsubs-it    as decimal format ">>>,>>>,>>9.99" no-undo.
DEFINE VARIABLE de-vl-dci AS DECIMAL     NO-UNDO.

DEFINE VARIABLE de-total-faturamento AS DECIMAL     NO-UNDO.
DEFINE VARIABLE l-inss-faturamento AS LOGICAL FORMAT "Sim/Nao"    NO-UNDO.
        
def var de-tot-merc-liq    like it-nota-fisc.vl-merc-liq    no-undo.
def var de-tot-merc-liq-me like it-nota-fisc.vl-merc-liq-me no-undo.
def var de-tot-frete-it    like it-nota-fisc.vl-frete-it    no-undo.
def var de-tot-icms-it     like it-nota-fisc.vl-icms-it     no-undo.
def var de-tot-ipi-it      like it-nota-fisc.vl-ipi-it      no-undo.
def var de-tot-despes-it   like it-nota-fisc.vl-despes-it   no-undo.
def var de-tot-pis         like it-nota-fisc.vl-pis         no-undo.
def var de-tot-finsocial   like it-nota-fisc.vl-finsocial   no-undo. 
def var de-tot-tot-item    like it-nota-fisc.vl-tot-item    no-undo.
def var de-tot-vl-icmsub-it as decimal format ">>>,>>>,>>9.99" no-undo.
def var de-tot-vl-bsubs-it  as decimal format ">>>,>>>,>>9.99" no-undo.
DEFINE VARIABLE de-tot-vl-dci AS DECIMAL     NO-UNDO.

def buffer b-it-nota-fisc for it-nota-fisc.

/****************************  Temp-Tables  ****************************/

def temp-table w-item 
    field nr-sequencia like it-nota-fisc.nr-seq-fat
    field desconto     like it-nota-fisc.vl-tot-item
    field vl-tot-item  like it-nota-fisc.vl-tot-item.
    
DEF TEMP-TABLE tt-movto
   field empresa        like movimento.ep-codigo
   field conta          like movimento.ct-codigo
   field sub-conta      like movimento.sc-codigo
   FIELD valor          LIKE docum-est.tot-valor                 label "Valor Movto"
   FIELD c-dc           AS CHAR FORMAT "x(01)"                   label "D/C".    

DEF TEMP-TABLE tt-class
    FIELD ncm like item.class-fiscal
    FIELD valor as dec format ">>,>>>,>>9.99"
    INDEX codigo is primary ncm.    

def temp-table tt-fatur
    field r-registro as ROWID
    field nr-igual   as inte
    index codigo as primary unique
          r-registro
    index ch-maior  
          nr-igual   ascending.    


/****************************  Temp-Tables  ****************************/
def temp-table tt-nota-fiscal
    field cod-estabel        like nota-fiscal.cod-estabel
    field serie              like nota-fiscal.serie
    field nr-nota-fis        like nota-fiscal.nr-nota-fis
    FIELD nr-fatura          LIKE nota-fiscal.nr-fatura
    field dt-emis-nota       like nota-fiscal.dt-emis-nota
    FIELD cod-canal-venda    LIKE nota-fiscal.cod-canal-venda
    field cod-emitente       like nota-fiscal.cod-emitente
    field nome-abrev         like nota-fiscal.nome-ab-cli
    FIELD nr-pedcli          LIKE nota-fiscal.nr-pedcli
    field cgc                like nota-fiscal.cgc
    field estado             like nota-fiscal.estado
    field cidade             like nota-fiscal.cidade 
    FIELD pais               LIKE nota-fiscal.pais
    field nat-operacao       like nota-fiscal.nat-operacao
    field nr-embarque        like nota-fiscal.cdd-embarq
    field it-codigo          like it-nota-fisc.it-codigo 
    field qt-faturada        as dec
    field vl-merc-liq        like it-nota-fisc.vl-merc-liq
    field vl-merc-liq-me     like it-nota-fisc.vl-merc-liq-me
    field vl-icmsub-it       like it-nota-fisc.vl-icmsub-it
    field vl-bsubs-it        like it-nota-fisc.vl-bsubs-it    
    field vl-frete-it        like it-nota-fisc.vl-frete-it
    field aliquota-icm       like it-nota-fisc.aliquota-icm
    field aliquota-ipi       like it-nota-fisc.aliquota-ipi    
    field vl-icms-it         like it-nota-fisc.vl-icms-it 
    field vl-ipi-it          like it-nota-fisc.vl-ipi-it
    field vl-despes-it       like it-nota-fisc.vl-despes-it
    field vl-pis             like it-nota-fisc.vl-pis
    field vl-finsocial       like it-nota-fisc.vl-finsocial
    field vl-tot-item        like it-nota-fisc.vl-tot-item
    field vl-preori          like it-nota-fisc.vl-preori
    field cod-depos          like fat-ser-lote.cod-depos
    FIELD class-fiscal       LIKE ITEM.class-fiscal
    FIELD nr-seq-fat         LIKE it-nota-fisc.nr-seq-fat
    field user-calc          like nota-fiscal.user-calc
    FIELD cod-mensagemm      AS INTEGER
    FIELD cod-trib-cliente   AS CHARACTER FORMAT "x(1)"
    FIELD nr-dcr-item        LIKE int-it-nota-fisc.cod-dcr-e
    FIELD vl-dci             AS DECIMAL
    FIELD serie-comp         AS CHAR
    FIELD nro-comp           AS CHAR
    FIELD data-comp          AS DATE
    FIELD nat-comp           AS CHAR
    FIELD inss-faturamento   AS LOGICAL
    FIELD cod-unid-neg       AS CHAR.
    
/****************************  Frames       ****************************/
DEF INPUT PARAMETER raw-param as raw no-undo.
DEF INPUT PARAMETER table for tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.



DEF VAR h-acomp      as handle no-undo.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Notas Fiscais de Saida"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESFTP087"
       c-versao       = "2.04"
       c-revisao      = "000".


/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
/*     {include/i-rpcab.i} */
/*     {include/i-rpout.i} */
    IF OPSYS = "unix" THEN
        OUTPUT TO value(session:temp-directory + trim(tt-param.usuario) +  "/esftp087.tmp").
    ELSE
        OUTPUT TO value(session:temp-directory + "esftp087.tmp").


    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

/*     if tt-param.excel = no then do: */
/*        VIEW FRAME f-cabec.          */
/*        VIEW FRAME f-rodape.         */
/*     end.                            */

    RUN piMontaRelat-1.

    RUN pi-finalizar in h-acomp.
    OUTPUT CLOSE.

    
/*     MESSAGE "O Arquivo gerado encontra-se em : "  session:temp-directory + "esftp087.tmp" VIEW-AS ALERT-BOX. */

/*     {include/i-rpclo.i} */
    RETURN "OK".
END.



PROCEDURE piMontaRelat-1:
    RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").
    
    do da-data = tt-param.ini-data to tt-param.fim-data:
       RUN pi-acompanhar IN h-acomp (INPUT "Selecionando data:" + string(da-data,"99/99/9999")).
       for each nota-fiscal NO-LOCK USE-INDEX ch-distancia
           WHERE nota-fiscal.dt-emis-nota = da-data
           AND   nota-fiscal.cod-estabel  >= tt-param.ini-cod-estabel
           AND   nota-fiscal.cod-estabel  <= tt-param.fim-cod-estabel
           AND   nota-fiscal.cod-emitente >= tt-param.ini-cod-emitente 
           AND   nota-fiscal.cod-emitente <= tt-param.fim-cod-emitente 
           and   nota-fiscal.nat-operacao >= tt-param.ini-nat-operacao
           and   nota-fiscal.nat-operacao <= tt-param.fim-nat-operacao           
           and   nota-fiscal.estado       >= tt-param.ini-uf
           and   nota-fiscal.estado       <= tt-param.fim-uf           
           AND   nota-fiscal.dt-cancel    = ?,
           each  it-nota-fisc of nota-fiscal no-lock
           WHERE it-nota-fisc.it-codigo >= tt-param.ini-it-codigo
             AND it-nota-fisc.it-codigo <= tt-param.fim-it-codigo,
           FIRST item NO-LOCK
           WHERE ITEM.it-codigo = it-nota-fisc.it-codigo
             AND ITEM.fm-codigo >= tt-param.fm-codigo-ini
             AND ITEM.fm-codigo <= tt-param.fm-codigo-fim:

           IF nota-fiscal.nr-pedcli <> "" THEN 
              FIND ped-venda
                   WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli
                   NO-LOCK NO-ERROR.

           FIND int-nota-fiscal
                WHERE int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                  AND int-nota-fiscal.serie       = nota-fiscal.serie
                  AND int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis
                  NO-LOCK NO-ERROR.
           FIND int-it-nota-fisc
                WHERE int-it-nota-fisc.cod-estabel = it-nota-fisc.cod-estabel
                  AND int-it-nota-fisc.serie       = it-nota-fisc.serie
                  AND int-it-nota-fisc.nr-nota-fis = it-nota-fisc.nr-nota-fis
                  AND int-it-nota-fisc.nr-seq-fat  = it-nota-fisc.nr-seq-fat
                  AND int-it-nota-fisc.it-codigo   = it-nota-fisc.it-codigo
                NO-LOCK NO-ERROR.

           create tt-nota-fiscal.
           assign tt-nota-fiscal.cod-estabel        = nota-fiscal.cod-estabel
                  tt-nota-fiscal.serie              = nota-fiscal.serie
                  tt-nota-fiscal.nr-nota-fis        = nota-fiscal.nr-nota-fis
                  tt-nota-fiscal.nr-fatura          = nota-fiscal.nr-fatura
                  tt-nota-fiscal.dt-emis-nota       = nota-fiscal.dt-emis-nota
                  tt-nota-fiscal.cod-canal-venda    = nota-fiscal.cod-canal-venda
                  tt-nota-fiscal.cod-emitente       = nota-fiscal.cod-emitente
                  tt-nota-fiscal.nome-abrev         = nota-fiscal.nome-ab-cli
                  tt-nota-fiscal.nr-pedcli          = nota-fiscal.nr-pedcli
                  tt-nota-fiscal.cgc                = nota-fiscal.cgc
                  tt-nota-fiscal.estado             = nota-fiscal.estado
                  tt-nota-fiscal.cidade             = nota-fiscal.cidade
                  tt-nota-fiscal.pais               = nota-fiscal.pais
                  tt-nota-fiscal.nat-operacao       = it-nota-fisc.nat-operacao
                  tt-nota-fiscal.nr-embarque        = nota-fiscal.cdd-embarq
                  tt-nota-fiscal.it-codigo          = it-nota-fisc.it-codigo
                  tt-nota-fiscal.class-fiscal       = it-nota-fisc.class-fiscal
                  tt-nota-fiscal.qt-faturada        = it-nota-fisc.qt-faturada[1]                  
                  tt-nota-fiscal.vl-preori          = it-nota-fisc.vl-preori
                  tt-nota-fiscal.vl-merc-liq        = it-nota-fisc.vl-merc-liq
                  tt-nota-fiscal.vl-merc-liq-me     = it-nota-fisc.vl-merc-liq / nota-fiscal.vl-taxa-exp
                  tt-nota-fiscal.vl-icmsub-it       = it-nota-fisc.vl-icmsub-it
                  tt-nota-fiscal.vl-bsubs-it        = it-nota-fisc.vl-bsubs-it
                  tt-nota-fiscal.vl-frete-it        = it-nota-fisc.vl-frete-it
                  tt-nota-fiscal.aliquota-icm       = it-nota-fisc.aliquota-icm
                  tt-nota-fiscal.aliquota-ipi       = it-nota-fisc.aliquota-ipi
                  tt-nota-fiscal.vl-icms-it         = it-nota-fisc.vl-icms-it
                  tt-nota-fiscal.vl-ipi-it          = it-nota-fisc.vl-ipi-it
                  tt-nota-fiscal.vl-despes-it       = it-nota-fisc.vl-despes-it
                  tt-nota-fiscal.vl-tot-item        = it-nota-fisc.vl-tot-item                  
                  tt-nota-fiscal.nr-seq-fat         = it-nota-fisc.nr-seq-fat
                  tt-nota-fiscal.nr-dcr-item        = IF AVAIL int-it-nota-fisc THEN int-it-nota-fisc.cod-dcr-e ELSE ""
                  tt-nota-fiscal.vl-dci             = it-nota-fisc.vl-tot-item * 0.12
                  tt-nota-fiscal.cod-unid-neg       = it-nota-fisc.cod-unid-neg.


           FIND INT-CLASSIF-FISC
                WHERE INT-CLASSIF-FISC.class-fiscal = ITEM.class-fiscal
                NO-LOCK NO-ERROR.
           IF AVAIL int-classif-fisc AND
              int-classif-fisc.inss-faturamento = YES THEN 
              ASSIGN tt-nota-fiscal.inss-faturamento = YES.
           ELSE
              ASSIGN tt-nota-fiscal.inss-faturamento = NO.

           FIND int-emitente 
                WHERE int-emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.
           IF AVAIL  int-emitente THEN
               CASE int-emitente.ind-forma-tributo:
                   WHEN 1 THEN ASSIGN tt-nota-fiscal.cod-trib-cliente = "R".
                   WHEN 2 THEN ASSIGN tt-nota-fiscal.cod-trib-cliente = "P".
                   WHEN 3 THEN ASSIGN tt-nota-fiscal.cod-trib-cliente = "S".
                   WHEN 4 THEN ASSIGN tt-nota-fiscal.cod-trib-cliente = "N".
                   WHEN 5 THEN ASSIGN tt-nota-fiscal.cod-trib-cliente = "I".
               END CASE.
           IF AVAIL INT-nota-fiscal THEN
              ASSIGN tt-nota-fiscal.cod-mensagem = int-nota-fiscal.cod-mensagem.
           IF substring(it-nota-fisc.char-2,96,1) = "1" THEN
              ASSIGN tt-nota-fiscal.vl-pis = tt-nota-fiscal.vl-merc-liq * dec(substring(it-nota-fisc.char-2,76,5)) / 100.
           IF substring(it-nota-fisc.char-2,97,1) = "1" THEN
              ASSIGN tt-nota-fiscal.vl-finsocial  = tt-nota-fiscal.vl-merc-liq * dec(substring(it-nota-fisc.char-2,81,5)) / 100.
           IF nota-fiscal.nr-pedcli <> "" AND
              AVAIL ped-venda THEN DO:
               IF ped-venda.user-impl <> "adm" and
                  ped-venda.user-impl <> "super" THEN
                  ASSIGN tt-nota-fiscal.user-calc          = ped-venda.user-impl.
               ELSE DO:
                   FIND atendente
                        WHERE atendente.cd-oper = int(ped-venda.tp-pedido)
                       NO-LOCK NO-ERROR.
                   IF AVAIL ATendente THEN DO:
                       ASSIGN tt-nota-fiscal.user-calc = atendente.user_magnus.
                   END.
               END.
           END.
           ELSE
               ASSIGN tt-nota-fiscal.user-calc          = nota-fiscal.user-calc.
          for first fat-ser-lote of it-nota-fisc no-lock:
              assign tt-nota-fiscal.cod-depos = fat-ser-lote.cod-depos.
          end.
           
       end.
   end.
    
    for each devol-cli no-lock
       where devol-cli.dt-devol >= tt-param.ini-data
         and devol-cli.dt-devol <= tt-param.fim-data,
        each item-doc-est of devol-cli NO-LOCK
       WHERE item-doc-est.it-codigo >= tt-param.ini-it-codigo
         AND item-doc-est.it-codigo <= tt-param.fim-it-codigo,
       first docum-est of item-doc-est no-lock
       WHERE docum-est.cod-estabel >= tt-param.ini-cod-estabel
         AND docum-est.cod-estabel <= tt-param.fim-cod-estabel,
       FIRST natur-oper NO-LOCK
       WHERE natur-oper.nat-operacao = docum-est.nat-operacao,
        EACH emitente NO-LOCK 
       WHERE emitente.cod-emitente = docum-est.cod-emitente,
       FIRST ITEM NO-LOCK 
       WHERE ITEM.it-codigo = item-doc-est.it-codigo
         AND ITEM.fm-codigo >= tt-param.fm-codigo-ini
         AND ITEM.fm-codigo <= tt-param.fm-codigo-fim:


        RUN pi-acompanhar IN h-acomp (INPUT "Docto de Entrada " + docum-est.nro-docto).
       
        FIND nota-fiscal
             WHERE nota-fiscal.cod-estabel = docum-est.cod-estabel
               AND nota-fiscal.serie       = item-doc-est.serie-comp
               AND nota-fiscal.nr-nota-fis = item-doc-est.nro-comp  
             NO-LOCK NO-ERROR.

        FIND it-nota-fisc
             WHERE it-nota-fisc.cod-estabel = docum-est.cod-estabel
               AND it-nota-fisc.serie        = item-doc-est.serie-comp
               AND it-nota-fisc.nr-nota-fis  = item-doc-est.nro-comp 
               AND it-nota-fisc.nr-seq-fat   = item-doc-est.seq-comp
               AND it-nota-fisc.it-codigo    = item-doc-est.it-codigo 
             NO-LOCK NO-ERROR.

        IF AVAIL it-nota-fisc THEN DO:
            IF it-nota-fisc.atual-estat = NO THEN NEXT.
        END.
        ELSE NEXT.

        IF    docum-est.cod-emitente > tt-param.fim-cod-emitente OR
              docum-est.cod-emitente < tt-param.ini-cod-emitente THEN NEXT.

        IF    emitente.estado       < tt-param.ini-uf           OR
              emitente.estado       > tt-param.fim-uf           THEN NEXT. 


        create tt-nota-fiscal.
        assign tt-nota-fiscal.cod-estabel        = docum-est.cod-estabel
               tt-nota-fiscal.serie              = docum-est.serie-docto
               tt-nota-fiscal.nr-nota-fis        = docum-est.nro-docto
               tt-nota-fiscal.nr-fatura          = docum-est.nro-docto
               tt-nota-fiscal.dt-emis-nota       = docum-est.dt-trans
               tt-nota-fiscal.cod-canal-venda    = IF AVAIL nota-fiscal THEN nota-fiscal.cod-canal-venda ELSE 0
               tt-nota-fiscal.cod-emitente       = docum-est.cod-emitente
               tt-nota-fiscal.nome-abrev         = IF AVAIL nota-fiscal THEN nota-fiscal.nome-ab-cli ELSE ""
               tt-nota-fiscal.nr-pedcli          = IF AVAIL nota-fiscal THEN nota-fiscal.nr-pedcli   ELSE ""
               tt-nota-fiscal.cgc                = IF AVAIL nota-fiscal THEN nota-fiscal.cgc         ELSE ""
               tt-nota-fiscal.estado             = IF AVAIL nota-fiscal THEN nota-fiscal.estado      ELSE ""
               tt-nota-fiscal.cidade             = IF AVAIL nota-fiscal THEN nota-fiscal.cidade      ELSE ""
               tt-nota-fiscal.pais               = IF AVAIL nota-fiscal THEN nota-fiscal.pais        ELSE ""
               tt-nota-fiscal.nat-operacao       = docum-est.nat-operacao
               tt-nota-fiscal.nr-embarque        = 0.
        ASSIGN tt-nota-fiscal.it-codigo          = item-doc-est.it-codigo.
       ASSIGN tt-nota-fiscal.qt-faturada         = item-doc-est.quantidade * -1 
              tt-nota-fiscal.class-fiscal        = item-doc-est.class-fiscal                .
        ASSIGN tt-nota-fiscal.vl-preori          = item-doc-est.preco-unit[1].
        ASSIGN tt-nota-fiscal.vl-merc-liq        = (item-doc-est.preco-total[1] - item-doc-est.desconto[1]) * -1.
        ASSIGN tt-nota-fiscal.vl-merc-liq-me     = ((item-doc-est.preco-total[1] - item-doc-est.desconto[1])  * -1)  / IF AVAIL nota-fiscal THEN nota-fiscal.vl-taxa-exp ELSE 0.
       ASSIGN tt-nota-fiscal.vl-icmsub-it        = item-doc-est.vl-subs[1] * -1.
        ASSIGN tt-nota-fiscal.vl-bsubs-it        = item-doc-est.base-subs[1] * -1.
        ASSIGN tt-nota-fiscal.vl-frete-it        = 0
               tt-nota-fiscal.aliquota-icm       = item-doc-est.aliquota-icm 
               tt-nota-fiscal.aliquota-ipi       = item-doc-est.aliquota-ipi
               tt-nota-fiscal.vl-icms-it         = item-doc-est.valor-icm[1] * -1
               tt-nota-fiscal.vl-ipi-it          = item-doc-est.valor-ipi[1] * -1
               tt-nota-fiscal.vl-despes-it       = 0
               tt-nota-fiscal.vl-tot-item        =  ((item-doc-est.preco-total[1] - item-doc-est.desconto[1] + 
                                                     item-doc-est.valor-ipi[1] + item-doc-est.vl-subs[1]) * -1)
               tt-nota-fiscal.nr-seq-fat         = 0
               tt-nota-fiscal.nr-dcr-item        = ""
               tt-nota-fiscal.vl-dci             =  ((item-doc-est.preco-total[1] - item-doc-est.desconto[1] + 
                                                     item-doc-est.valor-ipi[1] + item-doc-est.vl-subs[1])  * 0.12) * -1
               tt-nota-fiscal.cod-unid-neg       = ITEM.cod-unid-neg.

       FIND INT-CLASSIF-FISC
            WHERE INT-CLASSIF-FISC.class-fiscal = ITEM.class-fiscal
            NO-LOCK NO-ERROR.
       IF AVAIL int-classif-fisc AND
          int-classif-fisc.inss-faturamento = YES THEN 
          ASSIGN tt-nota-fiscal.inss-faturamento = YES.
       ELSE
          ASSIGN tt-nota-fiscal.inss-faturamento = NO.
         
        FIND int-emitente 
             WHERE int-emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.
        IF AVAIL  int-emitente THEN
            CASE int-emitente.ind-forma-tributo:
                WHEN 1 THEN ASSIGN tt-nota-fiscal.cod-trib-cliente = "R".
                WHEN 2 THEN ASSIGN tt-nota-fiscal.cod-trib-cliente = "P".
                WHEN 3 THEN ASSIGN tt-nota-fiscal.cod-trib-cliente = "S".
                WHEN 4 THEN ASSIGN tt-nota-fiscal.cod-trib-cliente = "N".
                WHEN 5 THEN ASSIGN tt-nota-fiscal.cod-trib-cliente = "I".
            END CASE.
        IF AVAIL INT-nota-fiscal THEN
           ASSIGN tt-nota-fiscal.cod-mensagem = int-nota-fiscal.cod-mensagem.
        IF AVAIL it-nota-fisc THEN DO:
            IF substring(it-nota-fisc.char-2,96,1) = "1" THEN
               ASSIGN tt-nota-fiscal.vl-pis = (tt-nota-fiscal.vl-merc-liq * dec(substring(it-nota-fisc.char-2,76,5)) / 100) * -1.
            IF substring(it-nota-fisc.char-2,97,1) = "1" THEN
               ASSIGN tt-nota-fiscal.vl-finsocial  = (tt-nota-fiscal.vl-merc-liq * dec(substring(it-nota-fisc.char-2,81,5)) / 100) * -1.
        END.
        ASSIGN tt-nota-fiscal.user-calc          = docum-est.usuario.
   
        FOR EACH rat-lote OF item-doc-est:
            ASSIGN tt-nota-fiscal.cod-depos = rat-lote.cod-depos.
        END.
        ASSIGN tt-nota-fiscal.nro-comp  = item-doc-est.nro-comp     
               tt-nota-fiscal.serie-comp = item-doc-est.serie-comp
               tt-nota-fiscal.data-comp = item-doc-est.data-comp         
               tt-nota-fiscal.nat-comp  = item-doc-est.nat-comp.
   END.


   
       assign de-vl-merc-liq    = 0
              de-vl-merc-liq-me = 0
              de-vl-frete-it    = 0
              de-vl-icms-it     = 0
              de-vl-ipi-it      = 0
              de-vl-despes-it   = 0
              de-vl-pis         = 0
              de-vl-finsocial   = 0
              de-vl-tot-item    = 0
              de-vl-icmsub-it   = 0
              de-vl-bsubs-it    = 0
              de-vl-dci         = 0.  
       put "Est;Ser;Nr.Nota;Operacao;Fatura;Dt.Emissao ;Canal ;Pedido ;Cliente;Nome        ;CGC                ;Cidade                   ;UF     ;Pais;Embar;Natur.;Emite Duplic;Forma Obten‡Æo;Tipo ITEM;Comp/Fabr;INSS FATURAM.;Origem;ICMS%  ;IPI% ;Dep;GE;Item    ;Descricao do Item                   ;Cl. Fiscal;Unidade Neg;Familia Comercial;Descricao;Familia Materiais;Descricao;Quantidade   ;Pre‡o Unit rio ;Vlr.Merc.(Real);Vlr.Merc.(Dolar)         ;Frete        ;Vlr ICMS         ;Vlr.IPI ;Vl.Base S.Trib.    ;ICMS Sub.Tr.        ;Despesas       ;Vlr PIS    ;vlr COFINS       ;Vl.Tot.NF;Vl DCI;Usuario    ;CF ; Ins Estad. ;Trib.Cliente;DCR Item;Mensagem;Nota Origem Devolucao;Serie;Data Origem;Natureza Nota Origem;Observacao                                                                  ;Conta Contabil" skip.
       assign c-separador = ";".
       for each tt-nota-fiscal,
           first item no-lock
           where item.it-codigo = tt-nota-fiscal.it-codigo
           break by tt-nota-fiscal.cod-estabel
                 by tt-nota-fiscal.serie
                 by tt-nota-fiscal.nr-nota-fis: 
           RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo " + tt-nota-fiscal.nr-nota-fis).

           FIND natur-oper
               WHERE natur-oper.nat-operacao = tt-nota-fiscal.nat-operacao
               NO-LOCK NO-ERROR.
           FIND emitente
               WHERE emitente.cod-emitente = tt-nota-fiscal.cod-emitente
               NO-LOCK NO-ERROR.

           FIND int-familia
                WHERE int-familia.fm-codigo = ITEM.fm-codigo NO-LOCK NO-ERROR.
        

           ASSIGN de-total-faturamento = de-total-faturamento + tt-nota-fiscal.vl-merc-liq.

           ASSIGN l-inss-faturamento = tt-nota-fiscal.inss-faturamento.

          find ped-fiscal
               where ped-fiscal.cod-estabel = tt-nota-fiscal.cod-estabel
                 and ped-fiscal.serie       = tt-nota-fiscal.serie
                 and ped-fiscal.nr-nota-fis = tt-nota-fiscal.nr-nota-fis no-lock no-error.
          
          put tt-nota-fiscal.cod-estabel  c-separador
              tt-nota-fiscal.serie   format "x(03)"     c-separador   
              tt-nota-fiscal.nr-nota-fis format "x(07)" c-separador .

          IF natur-oper.tipo = 1 THEN
             PUT natur-oper.denominacao c-separador.
          ELSE
              IF natur-oper.atual-estat = YES THEN
                     PUT "Normal" c-separador.
              ELSE
                    PUT "Outras" c-separador.

          PUT tt-nota-fiscal.nr-fatura   format "x(07)" c-separador
              tt-nota-fiscal.dt-emis-nota c-separador
              tt-nota-fiscal.cod-canal-venda c-separador.
          if avail ped-fiscal then
             put ped-fiscal.nr-pedido        c-separador.
          else
             put tt-nota-fiscal.nr-pedcli    c-separador.
              
         put  tt-nota-fiscal.cod-emitente c-separador
              tt-nota-fiscal.nome-abrev   c-separador
              tt-nota-fiscal.cgc          c-separador
              tt-nota-fiscal.cidade       c-separador
              tt-nota-fiscal.estado       c-separador              
              tt-nota-fiscal.pais         c-separador              
              tt-nota-fiscal.nr-embarque  c-separador
              tt-nota-fiscal.nat-operacao c-separador
              natur-oper.emite-duplic     c-separador.

         IF CAN-find(FIRST estrutura
                     WHERE estrutura.it-codigo = ITEM.it-codigo NO-LOCK) THEN 
             PUT "Fabricado" c-separador.
         ELSE
             PUT "Comprado" c-separador.

         FIND item-uni-estab
             WHERE item-uni-estab.cod-estabel = tt-nota-fiscal.cod-estabel
               AND item-uni-estab.it-codigo   = tt-nota-fiscal.it-codigo NO-LOCK NO-ERROR.
         IF NOT AVAIL item-uni-estab THEN PUT c-separador.
         ELSE
         CASE substring(item-uni-estab.char-1, 133, 1):
             WHEN "X" THEN
                ASSIGN c-tp-item = "NÇO informado".
             WHEN "0" THEN
                ASSIGN c-tp-item = "0 - Mercadoria para Revenda".
             WHEN "1" THEN
                ASSIGN c-tp-item = "1 - Mat‚ria-prima".
             WHEN "2" THEN
                ASSIGN c-tp-item = "2 - Embalagem".
             WHEN "3" THEN
                ASSIGN c-tp-item = "3 - Produto em Processo".
             WHEN "4" THEN
                ASSIGN c-tp-item = "4 - Produto Acabado".
             WHEN "5" THEN
                ASSIGN c-tp-item = "5 - Subproduto".
             WHEN "6" THEN
                ASSIGN c-tp-item = "6 - Produto Intermedi rio".
             WHEN "7" THEN
                ASSIGN c-tp-item = "7 - Material de Uso e Consumo".
             WHEN "8" THEN
                ASSIGN c-tp-item = "8 - Ativo Imobilizado".
             WHEN "9" THEN
                ASSIGN c-tp-item = "9 - Servi‡os".
             WHEN "a" THEN
                ASSIGN c-tp-item = "10 - Outros Insumos".
           OTHERWISE DO:
                ASSIGN c-tp-item = "99 - Outras".
           END.
         END CASE.

         PUT c-tp-item c-separador.
         
         IF AVAIL int-familia                      AND
            int-familia.oem                  = NO  THEN
             PUT "Fabricado" c-separador.
         ELSE
             PUT "Comprado" c-separador.


         PUT  l-inss-faturamento          c-separador 
              item.codigo-orig            c-separador       
              tt-nota-fiscal.aliquota-icm c-separador
              tt-nota-fiscal.aliquota-ipi c-separador.

          assign de-vl-merc-liq    = de-vl-merc-liq    + tt-nota-fiscal.vl-merc-liq 
                 de-vl-merc-liq-me = de-vl-merc-liq-me + tt-nota-fiscal.vl-merc-liq-me     
                 de-vl-frete-it    = de-vl-frete-it    + tt-nota-fiscal.vl-frete-it        
                 de-vl-icms-it     = de-vl-icms-it     + tt-nota-fiscal.vl-icms-it         
                 de-vl-ipi-it      = de-vl-ipi-it      + tt-nota-fiscal.vl-ipi-it          
                 de-vl-despes-it   = de-vl-despes-it   + tt-nota-fiscal.vl-despes-it       
                 de-vl-pis         = de-vl-pis         + tt-nota-fiscal.vl-pis             
                 de-vl-finsocial   = de-vl-finsocial   + tt-nota-fiscal.vl-finsocial
                 de-vl-tot-item    = de-vl-tot-item    + tt-nota-fiscal.vl-tot-item
                 de-vl-icmsub-it   = de-vl-icmsub-it   + tt-nota-fiscal.vl-icmsub-it   
                 de-vl-bsubs-it    = de-vl-bsubs-it    + tt-nota-fiscal.vl-bsubs-it
                 de-vl-dci         = de-vl-dci         + tt-nota-fiscal.vl-dci   .
                 
          if item.ind-imp-desc = 1 THEN /* Descri‡Æo */
             ASSIGN c-desc-prod = item.desc-item.

          if  item.ind-imp-desc = 2           /* Descri‡Æo + Narrativa */
          or  item.ind-imp-desc = 5           /* Narrativa Item */
          or  item.ind-imp-desc = 6           /* Uma Linha Narrativa */
          or  item.ind-imp-desc = 10 THEN DO: /* Descri‡Æo + 24 Narrativa Item */

              if  item.ind-imp-desc = 2
              or  item.ind-imp-desc = 10 THEN
                  ASSIGN c-desc-prod = item.desc-item.
              ELSE 
                  ASSIGN c-desc-prod = "".

              FIND narrativa of item NO-LOCK NO-ERROR.

              IF AVAILABLE narrativa THEN 
                  ASSIGN c-desc-prod = c-desc-prod +
                                    if  item.ind-imp-desc = 6 THEN
                                        trim(entry(1,SUBSTRING(narrativa.descricao,1,76),chr(10)))
                                    ELSE if item.ind-imp-desc = 10 THEN
                                        trim(entry(1,SUBSTRING(narrativa.descricao,1,24),chr(10)))
                                    ELSE                        
                                        narrativa.descricao.
              if c-desc-prod = "" then
                 ASSIGN c-desc-prod = item.desc-item.
          END.

          if  item.ind-imp-desc = 3          /* Descri‡Æo + Narrativa Item/Cliente */
          or  item.ind-imp-desc = 8 THEN DO: /* Descri‡Æo + 24 Narrativa Item/Cliente */
              FIND item-cli
                 WHERE item-cli.nome-abrev = tt-nota-fiscal.nome-abrev
                 and   item-cli.it-codigo  = tt-nota-fiscal.it-codigo
                 NO-LOCK NO-ERROR.

              ASSIGN c-desc-prod = item.desc-item.

              IF AVAILABLE item-cli THEN
                  ASSIGN c-desc-prod = c-desc-prod +
                                     if item.ind-imp-desc = 3 THEN          
                                        item-cli.narrativa
                                     ELSE
                                        trim(entry(1,SUBSTRING(item-cli.narrativa,1,24),chr(10))).
          END.

          if  item.ind-imp-desc = 4            /* Descri‡Æo + Narrativa Informada */
          or  item.ind-imp-desc = 7            /* Narrativa Informada */
          or  item.ind-imp-desc = 9 THEN DO:   /* Descri‡Æo + 24 Narrativa Informada */

              if  item.ind-imp-desc = 4
              or  item.ind-imp-desc = 9 THEN
                  ASSIGN c-desc-prod = item.desc-item.
              ELSE 
                  ASSIGN c-desc-prod = "".

              FIND nar-it-nota
                 WHERE nar-it-nota.cod-estabel  = tt-nota-fiscal.cod-estabel
                 and   nar-it-nota.serie        = tt-nota-fiscal.serie
                 and   nar-it-nota.nr-nota-fis  = tt-nota-fiscal.nr-nota-fis
                 and   nar-it-nota.nr-sequencia = tt-nota-fiscal.nr-seq-fat
                 and   nar-it-nota.it-codigo    = tt-nota-fiscal.it-codigo
                 NO-LOCK NO-ERROR.

              IF AVAILABLE nar-it-nota THEN 
                  ASSIGN c-desc-prod = c-desc-prod +
                                    if item.ind-imp-desc = 9 THEN
                                       trim(entry(1,SUBSTRING(nar-it-nota.narrativa,1,24),chr(10)))
                                    ELSE
                                       nar-it-nota.narrativa.
          END.
                  
          ASSIGN c-desc-prod = replace(c-desc-prod,CHR(13),"")
                 c-desc-prod = trim(replace(c-desc-prod,CHR(10),"")).

          put tt-nota-fiscal.cod-depos      c-separador
              ITEM.ge-codigo                c-separador
              tt-nota-fiscal.it-codigo  format "x(08)"    c-separador
              c-desc-prod                   c-separador.
          
          PUT tt-nota-fiscal.class-fiscal c-separador.
          

/*             assign c-unid-neg = "".                                               */
/*             find first unid-neg-item no-lock                                      */
/*                  where unid-neg-item.it-codigo = item.it-codigo no-error.         */
/*             if   avail unid-neg-item then                                         */
/*                  assign c-unid-neg = unid-neg-item.cod_unid_negoc.                */
/*             ELSE DO:                                                              */
/*                 FIND FIRST unid-neg-fam-com NO-LOCK                               */
/*                      WHERE unid-neg-fam-com.fm-codigo = item.fm-cod-com NO-ERROR. */
/*                 if   avail unid-neg-fam-com then                                  */
/*                      assign c-unid-neg = unid-neg-fam-com.cod_unid_negoc.         */
/*                 else assign c-unid-neg = "INVALIDA".                              */
/*             END.                                                                  */
/*           assign c-unid-nota = "INVALIDA".                                        */
/*                                                                                   */
/*             for each unid-neg-fat no-lock                                         */
/*                 where unid-neg-fat.cod-estabel = it-nota-fisc.cod-estabel         */
/*                   and unid-neg-fat.serie       = it-nota-fisc.serie               */
/*                   and unid-neg-fat.nr-nota-fis = it-nota-fisc.nr-nota-fis         */
/*                   and unid-neg-fat.nr-seq-fat  = it-nota-fisc.nr-seq-fat          */
/*                   and unid-neg-fat.it-codigo   = it-nota-fisc.it-codigo:          */
/*                assign c-unid-nota = unid-neg-fat.cod_unid_negoc.                  */
/*             end.                                                                  */
/*             IF c-unid-nota = "INVALIDA" THEN                                      */
             
          ASSIGN c-unid-nota = tt-nota-fiscal.cod-unid-neg.

          FIND familia
                WHERE familia.fm-codigo = ITEM.fm-codigo NO-LOCK NO-ERROR.
           
          PUT
              c-unid-nota                   c-separador.

          FIND fam-comerc
               WHERE fam-comerc.fm-cod-com = ITEM.fm-cod-com
              NO-LOCK NO-ERROR.

          PUT ITEM.fm-cod-com                c-separador.
          IF AVAIL fam-comerc THEN
              PUT fam-comerc.descricao       c-separador.
          ELSE
              PUT ""                         c-separador.

          PUT ITEM.fm-codigo                c-separador.

          IF AVAIL familia THEN
             PUT familia.descricao          c-separador.
          ELSE
             PUT ""                         c-separador.

              
          PUT tt-nota-fiscal.qt-faturada     FORMAT "->>>,>>>,>>9.99"  c-separador
              tt-nota-fiscal.vl-preori       FORMAT "->>>,>>>,>>9.99"   c-separador 
              tt-nota-fiscal.vl-merc-liq     FORMAT "->>>,>>>,>>9.99"  c-separador
              tt-nota-fiscal.vl-merc-liq-me  FORMAT "->>>,>>>,>>9.99" c-separador
              tt-nota-fiscal.vl-frete-it     FORMAT "->>>,>>>,>>9.99" c-separador 
              tt-nota-fiscal.vl-icms-it      FORMAT "->>>,>>>,>>9.99" c-separador 
              tt-nota-fiscal.vl-ipi-it       FORMAT "->>>,>>>,>>9.99" c-separador 
              tt-nota-fiscal.vl-bsubs-it     FORMAT "->>>,>>>,>>9.99" c-separador                   
              tt-nota-fiscal.vl-icmsub-it    FORMAT "->>>,>>>,>>9.99" c-separador                                
              tt-nota-fiscal.vl-despes-it    FORMAT "->>>,>>>,>>9.99" c-separador
              tt-nota-fiscal.vl-pis          FORMAT "->>>,>>>,>>9.99" c-separador 
              tt-nota-fiscal.vl-finsocial    FORMAT "->>>,>>>,>>9.99" c-separador
              tt-nota-fiscal.vl-tot-item     FORMAT "->>>,>>>,>>9.99" c-separador
              tt-nota-fiscal.vl-dci          FORMAT "->>>,>>>,>>9.99" c-separador
              tt-nota-fiscal.user-calc      c-separador
              natur-oper.consum-final       c-separador
              emitente.ins-estadual         c-separador
              tt-nota-fiscal.cod-trib-cliente c-separador
              tt-nota-fiscal.nr-dcr-item      c-separador
              tt-nota-fiscal.cod-mensagem     c-separador
              tt-nota-fiscal.nro-comp             c-separador
              tt-nota-fiscal.serie-comp           c-separador
              tt-nota-fiscal.data-comp c-separador
              tt-nota-fiscal.nat-comp  c-separador.
          if avail ped-fiscal then
             put ped-fiscal.observacao[1]     c-separador .
          else
             put "        " c-separador.
          for each movto-estoq 
              where movto-estoq.cod-estabel  = tt-nota-fiscal.cod-estabel
              and   movto-estoq.serie-docto  = tt-nota-fiscal.serie              
              and   movto-estoq.nro-docto    = tt-nota-fiscal.nr-nota-fis
              and   movto-estoq.cod-emitente = tt-nota-fiscal.cod-emitente
              and   movto-estoq.nat-operacao = tt-nota-fiscal.nat-operacao 
              and   movto-estoq.it-codigo    = tt-nota-fiscal.it-codigo no-lock:
              assign de-valor-contabil = 0.
  
             find estabelec 
                  where estabelec.cod-estabel = movto-estoq.cod-estabel no-lock no-error.
   
             find contabiliza 
                  where contabiliza.cod-estabel = movto-estoq.cod-estabel 
                    and contabiliza.cod-depos   = movto-estoq.cod-depos   
                    and contabiliza.ge-codigo   = item.ge-codigo  no-lock no-error.
  
              assign de-valor-contabil =   movto-estoq.valor-mat-m[1] 
                                       + movto-estoq.valor-mob-m[1] 
                                       + movto-estoq.valor-ggf-m[1].     
  
              put movto-estoq.ct-codigo + movto-estoq.sc-codigo c-separador.
          end.             
            
           put skip.                                 

       end.   
       PUT skip
           
           "     Faturamento Total: " de-total-faturamento FORMAT "->>>>>>,>>>,>>9.99" SKIP.

END procedure.



PROCEDURE pi-busca-cotacao.
    
    DEF INPUT PARAMETER da-data as DATE NO-UNDO. 
    
    FIND cotacao NO-LOCK         WHERE
         cotacao.mo-codigo   = 1 AND
         cotacao.ano-periodo = STRING(year(da-data),"9999") + STRING(month(da-data),"99") NO-ERROR.
            
    IF AVAIL cotacao AND 
             cotacao.cotacao[day(da-data)] <> 0 THEN  
       ASSIGN de-cotacao = cotacao.cotacao[day(da-data)].
    ELSE
       ASSIGN de-cotacao = 1.
END.


