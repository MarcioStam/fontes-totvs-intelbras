{include/i-prgvrs.i ESFTP041 2.04.00.000}
/***********************************************************************
**  Programa..: ESP\REP\ESFTP041RP.P
**  Autor.....: Anderson Cenci
**  Data......: FEVEREIRO/2008 - Desenvolvimento
**  Descricao.: NF de Saida
**  Vers∆o....: 001 07/02/2008
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp/ftp/esftp041tt.i}

{utp/ut-glob.i}
{esp/es0018.i}
{include/i-rpvar.i}

DEFINE NEW SHARED TEMP-TABLE tt-ped-curva
    FIELD it-codigo   LIKE nota-fiscal.cod-estabel  
    FIELD serie       LIKE nota-fiscal.serie                
    FIELD nr-nota-fis LIKE nota-fiscal.nr-nota-fis 
    FIELD ct-codigo   LIKE conta-ft.ct-recven
    FIELD sc-codigo   LIKE conta-ft.sc-recven
    FIELD ct-desc     AS CHARACTER
    FIELD sc-desc     AS CHARACTER
    FIELD dec-1       LIKE sumar-ft.vl-contab
    FIELD vl-credito  LIKE sumar-ft.vl-contab
    FIELD vl-debito   LIKE sumar-ft.vl-contab
    .

DEFINE VARIABLE c-key-value          AS CHARACTER.
DEFINE VARIABLE c-grade-cont         AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cab-5-1            AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cab-corpo-1        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cab-corpo-2        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cab-corpo-3        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cab-corpo-4        AS CHARACTER NO-UNDO.
DEFINE VARIABLE de-valor             AS DECIMAL   NO-UNDO.
DEFINE VARIABLE l-indicador          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE h-cd9500             AS HANDLE    NO-UNDO.
DEFINE VARIABLE de-taxa-cofins       AS DECIMAL.
DEFINE VARIABLE de-desconto          AS decimal.
DEFINE VARIABLE de-desc-acum         AS DECIMAL.
DEFINE VARIABLE i-niv-trib-icms      AS INTEGER   NO-UNDO.
DEFINE VARIABLE l-sub                AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c-ct-desc            AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-sc-desc            AS CHARACTER NO-UNDO.
DEFINE VARIABLE de-vl-dci            AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-tot-vl-dci        AS DECIMAL   NO-UNDO.
DEFINE VARIABLE c-unid-neg           AS CHARACTER NO-UNDO.
DEFINE VARIABLE de-cotacao           AS DECIMAL   NO-UNDO.
DEFINE VARIABLE da-data              AS DATE      NO-UNDO.
DEFINE VARIABLE c-unid-nota          AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-dc                 AS CHARACTER FORMAT "X(01)".
DEFINE VARIABLE c-separador          AS CHARACTER FORMAT "x(2)".
DEFINE VARIABLE de-total-c           AS DECIMAL   FORMAT ">>>,>>>,>>9.99".
DEFINE VARIABLE de-total-d           AS DECIMAL   FORMAT ">>>,>>>,>>9.99".
DEFINE VARIABLE c-desc-prod          AS CHARACTER FORMAT "x(100)"             NO-UNDO.
DEFINE VARIABLE de-valor-contabil    AS DECIMAL   FORMAT ">>>,>>>,>>9.99"     NO-UNDO.
DEFINE VARIABLE de-vl-icmsub-it      AS DECIMAL   FORMAT ">>>,>>>,>>9.99"     NO-UNDO.
DEFINE VARIABLE de-tot-vl-icmsub-it  AS DECIMAL   FORMAT ">>>,>>>,>>9.99"     NO-UNDO.
DEFINE VARIABLE de-tot-vl-bsubs-it   AS DECIMAL   FORMAT ">>>,>>>,>>9.99"     NO-UNDO.
DEFINE VARIABLE de-vl-bsubs-it       AS DECIMAL   FORMAT ">>>,>>>,>>9.99"     NO-UNDO.
DEFINE VARIABLE de-vl-bc-uf-dest     AS DECIMAL   FORMAT "->>>>>>>>>>>9.99":U NO-UNDO.
DEFINE VARIABLE de-aliq-uf-dest      AS DECIMAL   FORMAT "->>9.99":U          NO-UNDO.
DEFINE VARIABLE de-aliq-inter        AS DECIMAL   FORMAT "->>9.99":U          NO-UNDO.
DEFINE VARIABLE de-perc-icms-fcp     AS DECIMAL   FORMAT "->>9.99":U          NO-UNDO.
DEFINE VARIABLE de-vl-icms-fcp       AS DECIMAL   FORMAT "->>>>>>>>>>>9.99":U NO-UNDO.
DEFINE VARIABLE de-vl-icms-uf-dest   AS DECIMAL   FORMAT "->>>>>>>>>>>9.99":U NO-UNDO.
DEFINE VARIABLE de-vl-icms-uf-remet  AS DECIMAL   FORMAT "->>>>>>>>>>>9.99":U NO-UNDO.
DEFINE VARIABLE de-tot-bc-uf-dest    AS DECIMAL   FORMAT "->>>>>>>>>>>9.99":U NO-UNDO.
DEFINE VARIABLE de-tot-aliq-uf-dest  AS DECIMAL   FORMAT "->>9.99":U          NO-UNDO.
DEFINE VARIABLE de-tot-aliq-inter    AS DECIMAL   FORMAT "->>9.99":U          NO-UNDO.
DEFINE VARIABLE de-tot-perc-icms-fcp AS DECIMAL   FORMAT "->>9.99":U          NO-UNDO.
DEFINE VARIABLE de-tot-icms-fcp      AS DECIMAL   FORMAT "->>>>>>>>>>>9.99":U NO-UNDO.
DEFINE VARIABLE de-tot-icms-uf-dest  AS DECIMAL   FORMAT "->>>>>>>>>>>9.99":U NO-UNDO.
DEFINE VARIABLE de-tot-icms-uf-remet AS DECIMAL   FORMAT "->>>>>>>>>>>9.99":U NO-UNDO.
DEFINE VARIABLE de-vl-merc-liq      LIKE it-nota-fisc.vl-merc-liq        NO-UNDO.
DEFINE VARIABLE de-vl-merc-liq-me   LIKE it-nota-fisc.vl-merc-liq-me     NO-UNDO.
DEFINE VARIABLE de-vl-frete-it      LIKE it-nota-fisc.vl-frete-it        NO-UNDO.
DEFINE VARIABLE de-vl-icms-it       LIKE it-nota-fisc.vl-icms-it         NO-UNDO.
DEFINE VARIABLE de-vl-bicms-it      LIKE it-nota-fisc.vl-bicms-it        NO-UNDO.
DEFINE VARIABLE de-vl-ipi-it        LIKE it-nota-fisc.vl-ipi-it          NO-UNDO.
DEFINE VARIABLE de-vl-despes-it     LIKE it-nota-fisc.vl-despes-it       NO-UNDO.
DEFINE VARIABLE de-vl-pis           LIKE it-nota-fisc.vl-pis             NO-UNDO.
DEFINE VARIABLE de-vl-finsocial     LIKE it-nota-fisc.vl-finsocial       NO-UNDO. 
DEFINE VARIABLE de-vl-tot-item      LIKE it-nota-fisc.vl-tot-item        NO-UNDO.
DEFINE VARIABLE de-tot-merc-liq     LIKE it-nota-fisc.vl-merc-liq        NO-UNDO.
DEFINE VARIABLE de-tot-merc-liq-me  LIKE it-nota-fisc.vl-merc-liq-me     NO-UNDO.
DEFINE VARIABLE de-tot-frete-it     LIKE it-nota-fisc.vl-frete-it        NO-UNDO.
DEFINE VARIABLE de-tot-icms-it      LIKE it-nota-fisc.vl-icms-it         NO-UNDO.
DEFINE VARIABLE de-tot-bicms-it     LIKE it-nota-fisc.vl-bicms-it        NO-UNDO.
DEFINE VARIABLE de-tot-ipi-it       LIKE it-nota-fisc.vl-ipi-it          NO-UNDO.
DEFINE VARIABLE de-tot-despes-it    LIKE it-nota-fisc.vl-despes-it       NO-UNDO.
DEFINE VARIABLE de-tot-pis          LIKE it-nota-fisc.vl-pis             NO-UNDO.
DEFINE VARIABLE de-tot-finsocial    LIKE it-nota-fisc.vl-finsocial       NO-UNDO. 
DEFINE VARIABLE de-tot-tot-item     LIKE it-nota-fisc.vl-tot-item        NO-UNDO.
DEFINE VARIABLE de-valor-d          LIKE docum-est.tot-valor INIT 0      NO-UNDO.     
DEFINE VARIABLE l-mov               AS LOGICAL INIT NO                   NO-UNDO.
DEFINE VARIABLE vlr-fcp-it          AS DEC                               NO-UNDO.
DEFINE VARIABLE perc-fcp            AS DEC FORMAT ">>9.99"               NO-UNDO.
DEFINE VARIABLE de-tot-valor-FCP    AS DEC                               NO-UNDO.
DEFINE VARIABLE c-pocliente         AS CHAR                              NO-UNDO.
DEFINE VARIABLE c-ct-codigo         AS CHAR                              NO-UNDO.
DEFINE VARIABLE c-trib              AS CHAR                              NO-UNDO.

DEFINE VARIABLE c-msg-rejeicao      AS CHAR                              NO-UNDO.

DEFINE NEW SHARED VARIABLE c-tabela       AS CHARACTER FORMAT "X(11)" INIT "1,2,3,4,5,6,7".
DEFINE NEW SHARED VARIABLE r-nota         AS ROWID NO-UNDO.
DEFINE NEW SHARED VARIABLE grade-contabil AS LOGICAL NO-UNDO FORMAT "Sim/Nao" INIT "Nao".
DEFINE NEW SHARED VARIABLE i-branco       AS INTEGER NO-UNDO.
DEFINE NEW SHARED VARIABLE i-contador     AS INTEGER.
DEFINE NEW SHARED VARIABLE i-cont         AS INTEGER.
DEFINE NEW SHARED VARIABLE i-sequencia    AS INTEGER NO-UNDO.
DEFINE NEW SHARED VARIABLE r-conta-ft     AS ROWID.
DEFINE NEW SHARED VARIABLE i-ct-conta     LIKE conta-contab.ct-codigo NO-UNDO.
DEFINE NEW SHARED VARIABLE i-sc-conta     LIKE conta-contab.sc-codigo NO-UNDO.
DEFINE NEW SHARED VARIABLE i-vl-debito    LIKE sumar-ft.vl-contab FORMAT "->>,>>>,>>9.99" NO-UNDO.
DEFINE NEW SHARED VARIABLE i-vl-credito   LIKE sumar-ft.vl-contab FORMAT "->>,>>>,>>9.99" no-undo.
DEFINE NEW SHARED VARIABLE imp-cod        AS LOGICAL FORMAT "Codigo/Nome" INIT YES NO-UNDO.
DEFINE NEW SHARED VARIABLE de-vl-contab   LIKE sumar-ft.vl-contab NO-UNDO.

DEFINE BUFFER b-it-nota-fisc FOR it-nota-fisc.

{upc/btb910za-upc.i} /* Definiá∆o da vari†vel New Global Shared "v_cod_estab_usuar_intelbras" */

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
    FIELD cod-estabel          LIKE nota-fiscal.cod-estabel
    FIELD serie                LIKE nota-fiscal.serie
    FIELD nr-nota-fis          LIKE nota-fiscal.nr-nota-fis
    FIELD nr-fatura            LIKE nota-fiscal.nr-fatura
    FIELD dt-emis-nota         LIKE nota-fiscal.dt-emis-nota
    FIELD cod-canal-venda      LIKE nota-fiscal.cod-canal-venda
    FIELD cod-emitente         LIKE nota-fiscal.cod-emitente
    FIELD nome-abrev           LIKE nota-fiscal.nome-ab-cli
    FIELD nr-pedcli            LIKE nota-fiscal.nr-pedcli
    FIELD cgc                  LIKE nota-fiscal.cgc
    FIELD estado               LIKE nota-fiscal.estado
    FIELD cidade               LIKE nota-fiscal.cidade 
    FIELD pais                 LIKE nota-fiscal.pais
    FIELD nat-operacao         LIKE nota-fiscal.nat-operacao
    FIELD nr-embarque          LIKE nota-fiscal.cdd-embarq
    FIELD it-codigo            LIKE it-nota-fisc.it-codigo 
    FIELD vl-merc-liq          LIKE it-nota-fisc.vl-merc-liq
    FIELD vl-merc-liq-me       LIKE it-nota-fisc.vl-merc-liq-me
    FIELD vl-icmsub-it         LIKE it-nota-fisc.vl-icmsub-it
    FIELD vl-bsubs-it          LIKE it-nota-fisc.vl-bsubs-it    
    FIELD vl-frete-it          LIKE it-nota-fisc.vl-frete-it
    FIELD aliquota-icm         LIKE it-nota-fisc.aliquota-icm
    FIELD aliquota-ipi         LIKE it-nota-fisc.aliquota-ipi    
    FIELD vl-icms-it           LIKE it-nota-fisc.vl-icms-it 
    FIELD vl-bicms-it          LIKE it-nota-fisc.vl-bicms-it
    FIELD vl-ipi-it            LIKE it-nota-fisc.vl-ipi-it
    FIELD vl-despes-it         LIKE it-nota-fisc.vl-despes-it
    FIELD vl-pis               LIKE it-nota-fisc.vl-pis
    FIELD vl-finsocial         LIKE it-nota-fisc.vl-finsocial
    FIELD vl-tot-item          LIKE it-nota-fisc.vl-tot-item
    FIELD vl-preori            LIKE it-nota-fisc.vl-preori
    FIELD cod-depos            LIKE fat-ser-lote.cod-depos
    FIELD class-fiscal         LIKE ITEM.class-fiscal
    FIELD nr-seq-fat           LIKE it-nota-fisc.nr-seq-fat
    FIELD user-calc            LIKE nota-fiscal.user-calc
    FIELD nr-dcr-item          LIKE int-it-nota-fisc.cod-dcr-e
    FIELD cod-unid-neg         LIKE it-nota-fisc.cod-unid-neg
    FIELD imposto              LIKE it-nota-fisc.vl-iss-it
    FIELD aliquota             LIKE it-nota-fisc.aliquota-iss
    FIELD dt-saida             LIKE nota-fiscal.dt-saida
    FIELD dt-entr-cli          LIKE nota-fiscal.dt-entr-cli
    FIELD cod-cond-pag         LIKE cond-pagto.descricao
    FIELD num-seq              LIKE it-nota-fisc.nr-seq-fat
    FIELD contrib-icms         AS CHARACTER
    FIELD qt-faturada          AS DECIMAL
    FIELD cod-mensagemm        AS INTEGER
    FIELD vl-dci               AS DECIMAL
    FIELD serie-comp           AS CHARACTER
    FIELD nro-comp             AS CHARACTER
    FIELD data-comp            AS DATE
    FIELD nat-comp             AS CHARACTER
    FIELD cod_admdra_cartao_cr AS CHARACTER
    FIELD cod-transp           AS INTEGER
    FIELD nivel-trib           AS CHARACTER FORMAT "X(3)"
    FIELD sit-nf-eletronica    AS CHARACTER FORMAT "X(25)"
    FIELD cod-trib-cliente     AS CHARACTER FORMAT "X(1)"
    FIELD nome-transp          AS CHARACTER FORMAT "X(30)"
    FIELD cif                  AS LOGICAL   FORMAT "Sim/Nao"
    FIELD auditoria            AS CHARACTER FORMAT "X(500)"
    FIELD d-vl-bc-uf-dest      AS DECIMAL   FORMAT "->>>>>>>>>>>9.99":U COLUMN-LABEL "Vl BC UF Dest"
    FIELD d-aliq-uf-dest       AS DECIMAL   FORMAT "->>9.99":U          COLUMN-LABEL "Aliq UF Dest"
    FIELD d-aliq-inter         AS DECIMAL   FORMAT "->>9.99":U          COLUMN-LABEL "Aliq Inter"
    FIELD d-perc-icms-fcp      AS DECIMAL   FORMAT "->>9.99":U          COLUMN-LABEL "% ICMS FCP"
    FIELD d-vl-icms-fcp        AS DECIMAL   FORMAT "->>>>>>>>>>>9.99":U COLUMN-LABEL "Vl ICMS FCP"
    FIELD d-vl-icms-uf-dest    AS DECIMAL   FORMAT "->>>>>>>>>>>9.99":U COLUMN-LABEL "Vl ICMS UF Dest"
    FIELD d-vl-icms-uf-remet   AS DECIMAL   FORMAT "->>>>>>>>>>>9.99":U COLUMN-LABEL "Vl ICMS UF Remet"
    FIELD dt-cancel            AS DATE
    FIELD situacao             AS CHAR FORMAT "x(100)"
    FIELD cod-chave-aces-nf-eletro AS CHAR
    FIELD vl-FCP               AS DEC
    FIELD aliqFcp              AS DEC FORMAT ">>9.99"
    FIELD portaria             LIKE int-portaria-movto.codigo
    FIELD desc-mctic           LIKE int-portaria-item.desc-mctic
    FIELD ind-item-fat         AS CHAR
    FIELD classificacao        AS CHAR
    FIELD dt-ini               LIKE int-portaria-movto.dt-ini
    FIELD dt-fim               LIKE int-portaria-movto.dt-fim
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
    FIELD calc-limit-cred      AS DEC
    FIELD nr-sequencia         AS INT
    FIELD msg-rejeicao         AS CHAR
    FIELD docto-referenciado   LIKE nota-fisc-adc.cod-docto-referado
    FIELD cod-repres           LIKE nota-fiscal.cod-rep
    FIELD desc-rep             LIKE nota-fiscal.no-ab-reppri
    FIELD desc-cc              AS CHAR FORMAT "x(1000)". 

DEFINE BUFFER b-nota FOR tt-nota-fiscal.
DEFINE BUFFER bint-portaria-movto FOR int-portaria-movto.
/****************************  Frames       ****************************/
DEF INPUT PARAMETER raw-param as raw no-undo.
DEF INPUT PARAMETER table for tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.

    IF tt-digita.nat-operacao = "" THEN
        DELETE tt-digita.
end.

DEF VAR h-acomp      as handle no-undo.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Notas Fiscais de Saida"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESFTP041"
       c-versao       = "2.04"
       c-revisao      = "000".


/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
/*     {include/i-rpcab.i} */
    {include/i-rpout.i &pagesize="0"}
/*     IF OPSYS = "unix" THEN                                                                   */
/*         OUTPUT TO value(session:temp-directory + trim(tt-param.usuario) +  "/esftp041.tmp"). */
/*     ELSE                                                                                     */
/*         OUTPUT TO value(session:temp-directory + "esftp041.tmp").                            */


    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

/*     if tt-param.excel = no then do: */
/*        VIEW FRAME f-cabec.          */
/*        VIEW FRAME f-rodape.         */
/*     end.                            */

    RUN piMontaRelat-1.

    RUN pi-finalizar in h-acomp.
/*     OUTPUT CLOSE. */

    
/*     MESSAGE "O Arquivo gerado encontra-se em : "  session:temp-directory + "esftp041.tmp" VIEW-AS ALERT-BOX. */

     {include/i-rpclo.i} 
    RETURN "OK".
END.



PROCEDURE piMontaRelat-1:
    RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").
    
    DO da-data = tt-param.ini-data TO tt-param.fim-data:
        RUN pi-acompanhar IN h-acomp (INPUT "Selecionando data:" + STRING(da-data,"99/99/9999")).

        FOR EACH nota-fiscal NO-LOCK USE-INDEX ch-distancia
            WHERE nota-fiscal.dt-emis-nota = da-data
            AND   nota-fiscal.cod-estabel  >= tt-param.ini-cod-estabel
            AND   nota-fiscal.cod-estabel  <= tt-param.fim-cod-estabel
            AND   nota-fiscal.cod-emitente >= tt-param.ini-cod-emitente 
            AND   nota-fiscal.cod-emitente <= tt-param.fim-cod-emitente 
            AND   nota-fiscal.estado       >= tt-param.ini-uf
            AND   nota-fiscal.estado       <= tt-param.fim-uf,
            EACH  it-nota-fisc OF nota-fiscal NO-LOCK
            WHERE it-nota-fisc.it-codigo >= tt-param.ini-it-codigo
            AND   it-nota-fisc.it-codigo <= tt-param.fim-it-codigo
            AND   it-nota-fisc.class-fiscal >= tt-param.classific-ini
            AND   it-nota-fisc.class-fiscal <= tt-param.classific-fim
            AND   it-nota-fisc.nat-operacao >= tt-param.ini-nat-operacao
            AND   it-nota-fisc.nat-operacao <= tt-param.fim-nat-operacao,
            FIRST item NO-LOCK
            WHERE item.it-codigo = it-nota-fisc.it-codigo
            AND   item.fm-codigo >= tt-param.fm-codigo-ini
            AND   item.fm-codigo <= tt-param.fm-codigo-fim:

            IF  tt-param.imprime-cancel THEN
                IF nota-fiscal.dt-cancel    = ? THEN NEXT.


            IF  NOT tt-param.imprime-cancel THEN
                IF nota-fiscal.dt-cancel    <> ? THEN NEXT.
                

            IF nota-fiscal.nr-pedcli <> "" THEN
                FIND ped-venda
                    WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli NO-LOCK NO-ERROR.

            IF CAN-FIND(FIRST tt-digita) THEN
                IF NOT CAN-FIND(FIRST tt-digita NO-LOCK
                                WHERE tt-digita.nat-operacao = it-nota-fisc.nat-operacao) THEN NEXT.

            FIND int-nota-fiscal
                WHERE int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                AND   int-nota-fiscal.serie       = nota-fiscal.serie
                AND   int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.


            FIND int-it-nota-fisc
                WHERE int-it-nota-fisc.cod-estabel = it-nota-fisc.cod-estabel
                AND   int-it-nota-fisc.serie       = it-nota-fisc.serie
                AND   int-it-nota-fisc.nr-nota-fis = it-nota-fisc.nr-nota-fis
                AND   int-it-nota-fisc.nr-seq-fat  = it-nota-fisc.nr-seq-fat
                AND   int-it-nota-fisc.it-codigo   = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.

            FOR FIRST ext-it-nota-fisc
                WHERE ext-it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
                  AND ext-it-nota-fisc.serie       = nota-fiscal.serie 
                  AND ext-it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
                  AND ext-it-nota-fisc.nr-seq-fat  = it-nota-fisc.nr-seq-fat
                  AND ext-it-nota-fisc.it-codigo   = it-nota-fisc.it-codigo
                  AND ext-it-nota-fisc.cod-param   = "inf-PIS/COFINS" NO-LOCK:
            END.
         

            ASSIGN c-msg-rejeicao = "".
            IF  tt-param.imprime-cancel THEN DO:
                
                  IF nota-fiscal.idi-sit-nf-eletro = 5 OR
                     nota-fiscal.idi-sit-nf-eletro = 7 THEN DO:

                 
                      FOR EACH ret-nf-eletro NO-LOCK
                         WHERE ret-nf-eletro.cod-estabel = nota-fiscal.cod-estabel
                           AND ret-nf-eletro.nr-nota-fis = nota-fiscal.nr-nota-fis
                           AND ret-nf-eletro.cod-serie   = nota-fiscal.serie
                           AND ret-nf-eletro.cod-livre-2 <> "":

                      
                          ASSIGN c-msg-rejeicao = ret-nf-eletro.cod-livre-2.
                      END.
                  END.

            END.

            CREATE tt-nota-fiscal.
            ASSIGN tt-nota-fiscal.cod-estabel        = nota-fiscal.cod-estabel
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
                   tt-nota-fiscal.num-seq            = it-nota-fisc.nr-seq-fat
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
                   tt-nota-fiscal.vl-icms-it         = IF it-nota-fisc.vl-bicms-it > 0 THEN it-nota-fisc.vl-icms-it ELSE 0
                   tt-nota-fiscal.vl-bicms-it        = it-nota-fisc.vl-bicms-it
                   tt-nota-fiscal.vl-ipi-it          = IF it-nota-fisc.cd-trib-ipi = 3 THEN 0 ELSE it-nota-fisc.vl-ipi-it
                   tt-nota-fiscal.vl-despes-it       = it-nota-fisc.vl-despes-it
                   tt-nota-fiscal.vl-tot-item        = it-nota-fisc.vl-tot-item                  
                   tt-nota-fiscal.nr-seq-fat         = it-nota-fisc.nr-seq-fat
                   tt-nota-fiscal.nr-dcr-item        = IF AVAIL int-it-nota-fisc THEN int-it-nota-fisc.cod-dcr-e ELSE ""
                   tt-nota-fiscal.vl-dci             = it-nota-fisc.vl-tot-item * 0.12
                   tt-nota-fiscal.cod-unid-neg       = it-nota-fisc.cod-unid-neg
                   tt-nota-fiscal.imposto            = it-nota-fisc.vl-iss-it
                   tt-nota-fiscal.aliquota           = it-nota-fisc.aliquota-iss
                   tt-nota-fiscal.dt-saida           = nota-fiscal.dt-saida
                   tt-nota-fiscal.dt-entr-cli        = nota-fiscal.dt-entr-cli
                   tt-nota-fiscal.auditoria          = IF AVAIL int-nota-fiscal THEN SUBSTRING(int-nota-fiscal.char-1,100,500) ELSE ""
                   tt-nota-fiscal.dt-cancel          = nota-fiscal.dt-cancel
                   tt-nota-fiscal.nr-sequencia       = it-nota-fisc.nr-seq-fat
                   tt-nota-fiscal.msg-rejeicao       = c-msg-rejeicao
                   tt-nota-fiscal.cod-rep            = nota-fiscal.cod-rep
                   tt-nota-fiscal.desc-rep           = nota-fiscal.no-ab-reppri.

            IF  tt-param.tg-lista-chave THEN
                ASSIGN tt-nota-fiscal.cod-chave-aces-nf-eletro = nota-fiscal.cod-chave-aces-nf-eletro.

            FIND FIRST nota-fisc-adc 
               WHERE nota-fisc-adc.cod-estab        = nota-fiscal.cod-estabel
                 AND nota-fisc-adc.cod-serie        = nota-fiscal.serie 
                 AND nota-fisc-adc.cod-nota-fisc    = nota-fiscal.nr-nota-fis
                 AND nota-fisc-adc.cdn-emitente     = nota-fiscal.cod-emitente 
                 AND nota-fisc-adc.cod-natur-operac = nota-fiscal.nat-operacao
                 AND nota-fisc-adc.idi-tip-dado      = 10 NO-LOCK NO-ERROR.

            IF  AVAIL nota-fisc-adc THEN DO:
                 CASE SUBSTRING(nota-fisc-adc.cod-livre-2,1,2):
                     WHEN "01" THEN tt-nota-fiscal.situacao = "Documento Regular".
                     WHEN "02" THEN tt-nota-fiscal.situacao = "Documento Regular ExtemporÉneo".
                     WHEN "03" THEN tt-nota-fiscal.situacao = "Documento Cancelado".
                     WHEN "04" THEN tt-nota-fiscal.situacao = "Documento Cancelado ExtemporÉneo".
                     WHEN "05" THEN tt-nota-fiscal.situacao = "NFe Denegada".
                     WHEN "06" THEN tt-nota-fiscal.situacao = "NFe - Numeraá∆o Inutilizada".
                     WHEN "07" THEN tt-nota-fiscal.situacao = "Documento Fiscal Complementar".
                     WHEN "08" THEN tt-nota-fiscal.situacao = "Documento Fiscal Complementar ExtemporÉneo".
                     WHEN "09" THEN tt-nota-fiscal.situacao = "Documento Fiscal Emitido com Base em Regime Especial ou Norma Espec°fica".
                 END CASE.
            END.
            ELSE
                tt-nota-fiscal.situacao = "Documento Regular".

            FIND transporte
                WHERE transporte.nome-abrev = nota-fiscal.nome-transp NO-LOCK NO-ERROR.

            IF AVAIL transporte THEN
                ASSIGN tt-nota-fiscal.cod-transp = transporte.cod-transp
                       tt-nota-fiscal.nome-transp = transporte.nome.
            ELSE
                ASSIGN tt-nota-fiscal.cod-transp = 0
                       tt-nota-fiscal.nome-transp = "".

            IF nota-fiscal.cidade-cif = "" THEN
                ASSIGN tt-nota-fiscal.cif = NO.
            ELSE
                ASSIGN tt-nota-fiscal.cif = YES.
            
            ASSIGN i-niv-trib-icms           = 0
                   tt-nota-fiscal.nivel-trib = "".

            FOR EACH item-nf-adc FIELDS(val-livre-1 cod-livre-1 cod-livre-2 val-livre-2 cod-livre-4
                                         val-livre-3 val-livre-4)
                WHERE item-nf-adc.idi-tip-dado     = 24 /* DIFAL */
                AND   item-nf-adc.cod-estab        = nota-fiscal.cod-estabel
                AND   item-nf-adc.cod-serie        = nota-fiscal.serie
                AND   item-nf-adc.cod-nota-fis     = nota-fiscal.nr-nota-fis
                AND   item-nf-adc.cod-natur-operac = it-nota-fisc.nat-operacao
                AND   item-nf-adc.cod-item         = it-nota-fisc.it-codigo
                AND   item-nf-adc.num-seq-item-nf  = it-nota-fisc.nr-seq-fat NO-LOCK:

                ASSIGN tt-nota-fiscal.d-vl-bc-uf-dest    = tt-nota-fiscal.d-vl-bc-uf-dest    + item-nf-adc.val-livre-1
                       tt-nota-fiscal.d-aliq-uf-dest     = tt-nota-fiscal.d-aliq-uf-dest     + DEC(item-nf-adc.cod-livre-1)
                       tt-nota-fiscal.d-aliq-inter       = tt-nota-fiscal.d-aliq-inter       + DEC(item-nf-adc.cod-livre-2)
                       tt-nota-fiscal.d-perc-icms-fcp    = tt-nota-fiscal.d-perc-icms-fcp    + item-nf-adc.val-livre-2
                       tt-nota-fiscal.d-vl-icms-fcp      = tt-nota-fiscal.d-vl-icms-fcp      + DEC(item-nf-adc.cod-livre-4)
                       tt-nota-fiscal.d-vl-icms-uf-dest  = tt-nota-fiscal.d-vl-icms-uf-dest  + item-nf-adc.val-livre-3
                       tt-nota-fiscal.d-vl-icms-uf-remet = tt-nota-fiscal.d-vl-icms-uf-remet + item-nf-adc.val-livre-4.
            END.

            /* adicionando coluna docto referenciado */
            RUN pi-docto-referado.

            /* ----------- Adicionar o valor do fundo de combate a pobresa ao icms subst. --------*/
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

            IF  vlr-fcp-it > 0 AND vlr-fcp-it <> ? THEN
                ASSIGN tt-nota-fiscal.vl-icmsub-it = tt-nota-fiscal.vl-icmsub-it  + vlr-fcp-it.
            

            ASSIGN tt-nota-fiscal.vl-FCP  = vlr-fcp-it 
                   tt-nota-fiscal.aliqFcp = perc-fcp. 
            /*------------------------------------------------------------------------------------*/

            FOR FIRST emitente FIELDS(contrib-icms)
                WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK:

                ASSIGN tt-nota-fiscal.contrib-icms = IF emitente.contrib-icms THEN "Sim" ELSE "N∆o".
            END.

            RUN ftp/ft0515a.p (INPUT  ROWID(it-nota-fisc), 
                               OUTPUT i-niv-trib-icms,      
                               OUTPUT l-sub).
            
            /* CST -> Codigo da Situacao Tributaria (conforme DANFE): Codigo Origem + Nivel Tributacao ICMS */
            ASSIGN i-niv-trib-icms           = INT(STRING(INT(SUBSTRING(it-nota-fisc.char-1,180,3))) + STRING(i-niv-trib-icms, "99"))
                   tt-nota-fiscal.nivel-trib = STRING(i-niv-trib-icms,"999").
            
            CASE nota-fiscal.idi-sit-nf-eletro:
                WHEN 1 THEN ASSIGN tt-nota-fiscal.sit-nf-eletronica = "N∆o Gerada".
                WHEN 2 THEN ASSIGN tt-nota-fiscal.sit-nf-eletronica = "Em Processamento".
                WHEN 3 THEN ASSIGN tt-nota-fiscal.sit-nf-eletronica = "Uso Autorizado".
                WHEN 4 THEN ASSIGN tt-nota-fiscal.sit-nf-eletronica = "Uso Denegado".
                WHEN 5 THEN ASSIGN tt-nota-fiscal.sit-nf-eletronica = "Rejeitado".
                WHEN 6 THEN ASSIGN tt-nota-fiscal.sit-nf-eletronica = "Cancelada".
                WHEN 7 THEN ASSIGN tt-nota-fiscal.sit-nf-eletronica = "Inutilizada".
                WHEN 8 THEN ASSIGN tt-nota-fiscal.sit-nf-eletronica = "Em Proc. Transmiss∆o".
                WHEN 9 THEN ASSIGN tt-nota-fiscal.sit-nf-eletronica = "Em Processamento SEFAZ".
            END CASE.
           
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

            IF AVAIL ext-it-nota-fisc THEN DO:
                ASSIGN tt-nota-fiscal.vl-pis = ext-it-nota-fisc.val-livre-3.
                       tt-nota-fiscal.vl-finsocial = ext-it-nota-fisc.val-livre-6.
            END.
                
            
           /* IF SUBSTRING(it-nota-fisc.char-2,96,1) = "1" THEN
                ASSIGN tt-nota-fiscal.vl-pis = (tt-nota-fiscal.vl-merc-liq + tt-nota-fiscal.vl-despes-it) * DEC(SUBSTRING(it-nota-fisc.char-2,76,5)) / 100.
                
            IF SUBSTRING(it-nota-fisc.char-2,97,1) = "1" THEN
                ASSIGN tt-nota-fiscal.vl-finsocial  = (tt-nota-fiscal.vl-merc-liq + tt-nota-fiscal.vl-despes-it) * DEC(SUBSTRING(it-nota-fisc.char-2,81,5)) / 100.*/
            
            IF nota-fiscal.nr-pedcli <> "" AND AVAIL ped-venda THEN DO:
                IF ped-venda.user-impl <> "adm" AND ped-venda.user-impl <> "super" THEN
                    ASSIGN tt-nota-fiscal.user-calc = ped-venda.user-impl.
                ELSE DO:
                    FIND atendente
                        WHERE atendente.cd-oper = INT(ped-venda.tp-pedido) NO-LOCK NO-ERROR.
            
                    IF AVAIL ATendente THEN DO:
                        ASSIGN tt-nota-fiscal.user-calc = atendente.user_magnus.
                    END.
                END.
                RUN VerificaCartaoCredito.
            END.
            ELSE
                ASSIGN tt-nota-fiscal.user-calc = nota-fiscal.user-calc.
            
            FOR FIRST fat-ser-lote OF it-nota-fisc NO-LOCK:
                ASSIGN tt-nota-fiscal.cod-depos = fat-ser-lote.cod-depos.
            END.

            IF tt-param.tg-lei-informatica THEN DO:

                FIND FIRST int-portaria-item NO-LOCK
                     WHERE int-portaria-item.it-codigo   = tt-nota-fiscal.it-codigo
                       AND int-portaria-item.cod-estabel = tt-nota-fiscal.cod-estabel NO-ERROR.
                IF NOT AVAIL int-portaria-item THEN NEXT.

                FIND FIRST int-portaria-movto NO-LOCK
                     WHERE int-portaria-movto.it-codigo      = tt-nota-fiscal.it-codigo
                       AND int-portaria-movto.cod-estabel    = tt-nota-fiscal.cod-estabel
                       AND int-portaria-movto.classificacao <> "BEM"
                       AND int-portaria-movto.dt-fim         = ? NO-ERROR.
                IF NOT AVAIL int-portaria-movto THEN NEXT.

                FIND FIRST bint-portaria-movto NO-LOCK
                     WHERE bint-portaria-movto.it-codigo     = tt-nota-fiscal.it-codigo
                       AND bint-portaria-movto.cod-estabel   = tt-nota-fiscal.cod-estabel
                       AND bint-portaria-movto.classificacao = "BEM"
                       AND bint-portaria-movto.dt-fim        = ? NO-ERROR.

                FIND FIRST int-portaria-perc NO-LOCK
                     WHERE int-portaria-perc.it-codigo   = tt-nota-fiscal.it-codigo
                       AND int-portaria-perc.cod-estabel = tt-nota-fiscal.cod-estabel
                       AND int-portaria-perc.dt-fim      = ? NO-ERROR.
                
                ASSIGN tt-nota-fiscal.portaria             = int-portaria-movto.codigo
                       tt-nota-fiscal.desc-mctic           = int-portaria-item.desc-mctic
                       tt-nota-fiscal.ind-item-fat         = STRING(item.ind-item-fat,"Sim/Nao")
                       tt-nota-fiscal.classificacao        = int-portaria-movto.classificacao 
                       tt-nota-fiscal.dt-ini               = int-portaria-movto.dt-ini
                       tt-nota-fiscal.dt-fim               = int-portaria-movto.dt-fim.

                IF AVAIL int-portaria-perc THEN DO:

                       ASSIGN tt-nota-fiscal.calc-ext-conv1       = ROUND(it-nota-fisc.vl-tot-item * int-portaria-perc.aliq-ext-conv1 / 100,2)                                                                           
                              tt-nota-fiscal.calc-ext-conv2a      = ROUND(it-nota-fisc.vl-tot-item * int-portaria-perc.aliq-ext-conv2a / 100,2)                                                                          
                              tt-nota-fiscal.calc-ext-conv2b      = ROUND(it-nota-fisc.vl-tot-item * int-portaria-perc.aliq-ext-conv2b / 100,2)                                                                          
                              tt-nota-fiscal.calc-ext-fndct       = ROUND(it-nota-fisc.vl-tot-item * int-portaria-perc.aliq-ext-fndct / 100,2)                                                                           
                              tt-nota-fiscal.calc-externo         = ROUND(tt-nota-fiscal.calc-ext-conv1 + tt-nota-fiscal.calc-ext-conv2a + tt-nota-fiscal.calc-ext-conv2b + tt-nota-fiscal.calc-ext-fndct,2)       
                              tt-nota-fiscal.calc-interno         = ROUND(it-nota-fisc.vl-tot-item * int-portaria-perc.aliq-int / 100,2)                                                                                 
                              tt-nota-fiscal.calc-tot             = ROUND(tt-nota-fiscal.calc-externo + tt-nota-fiscal.calc-interno,2)                                                                             
                              tt-nota-fiscal.calc-adic            = ROUND(it-nota-fisc.vl-tot-item * int-portaria-perc.aliq-adic / 100,2)                                                                                
                              tt-nota-fiscal.calc-cred-prod-hab   = IF NOT AVAIL bint-portaria-movto THEN ROUND(it-nota-fisc.vl-tot-item * int-portaria-perc.aliq-cred-hab / 100,2) ELSE 0                               
                              tt-nota-fiscal.calc-cred-bem-desenv = IF     AVAIL bint-portaria-movto THEN ROUND(it-nota-fisc.vl-tot-item * int-portaria-perc.aliq-cred-bem / 100,2) ELSE 0                               
                              tt-nota-fiscal.calc-limit-cred      = ROUND(tt-nota-fiscal.calc-cred-prod-hab + tt-nota-fiscal.calc-cred-bem-desenv,2). 

                END.
            END.

            FOR EACH carta-correc-eletro NO-LOCK
                WHERE carta-correc-eletro.cod-estab     = nota-fiscal.cod-estabel 
                  AND carta-correc-eletro.cod-serie     = nota-fiscal.serie
                  AND carta-correc-eletro.cod-nota-fisc = nota-fiscal.nr-nota-fis
                  AND carta-correc-eletro.idi-sit-event = 3:
            
                    ASSIGN tt-nota-fiscal.desc-cc = carta-correc-eletro.dsl-carta-correc-eletro.

                    ASSIGN tt-nota-fiscal.desc-cc = REPLACE(tt-nota-fiscal.desc-cc,CHR(13),"")
                           tt-nota-fiscal.desc-cc = REPLACE(tt-nota-fiscal.desc-cc,CHR(10),"")
                           tt-nota-fiscal.desc-cc = TRIM(REPLACE(tt-nota-fiscal.desc-cc,";"," ")). 
            END.
        END.
    END.

    IF tt-param.devolucao = YES THEN DO:
        FOR EACH devol-cli NO-LOCK
            WHERE devol-cli.dt-devol >= tt-param.ini-data
            AND   devol-cli.dt-devol <= tt-param.fim-data,
            EACH item-doc-est OF devol-cli NO-LOCK
            WHERE item-doc-est.it-codigo >= tt-param.ini-it-codigo
            AND   item-doc-est.it-codigo <= tt-param.fim-it-codigo,
            FIRST docum-est OF item-doc-est NO-LOCK
            WHERE docum-est.cod-estabel >= tt-param.ini-cod-estabel
            AND   docum-est.cod-estabel <= tt-param.fim-cod-estabel,
            FIRST natur-oper NO-LOCK
            WHERE natur-oper.nat-operacao = docum-est.nat-operacao,
            EACH emitente NO-LOCK
            WHERE emitente.cod-emitente = docum-est.cod-emitente,
            FIRST ITEM NO-LOCK
            WHERE item.it-codigo     = item-doc-est.it-codigo
            AND   item.fm-codigo    >= tt-param.fm-codigo-ini
            AND   item.fm-codigo    <= tt-param.fm-codigo-fim
            AND   item.class-fiscal >= tt-param.classific-ini
            AND   item.class-fiscal <= tt-param.classific-fim:

            RUN pi-acompanhar IN h-acomp (INPUT "Docto de Entrada " + docum-est.nro-docto).
            
            FIND nota-fiscal
                WHERE nota-fiscal.cod-estabel = docum-est.cod-estabel  
                AND   nota-fiscal.serie       = docum-est.serie-docto  
                AND   nota-fiscal.nr-nota-fis = docum-est.nro-docto NO-LOCK NO-ERROR.

            IF AVAIL nota-fiscal THEN DO:
                IF  tt-param.imprime-cancel THEN
                    IF nota-fiscal.dt-cancel    = ? THEN NEXT.
                IF  NOT tt-param.imprime-cancel THEN
                    IF nota-fiscal.dt-cancel    <> ? THEN NEXT.
            END.
            
            FIND nota-fiscal
                WHERE nota-fiscal.cod-estabel = docum-est.cod-estabel
                AND   nota-fiscal.serie       = item-doc-est.serie-comp
                AND   nota-fiscal.nr-nota-fis = item-doc-est.nro-comp NO-LOCK NO-ERROR.

            FIND it-nota-fisc
                WHERE it-nota-fisc.cod-estabel = docum-est.cod-estabel
                AND  it-nota-fisc.serie        = item-doc-est.serie-comp
                AND  it-nota-fisc.nr-nota-fis  = item-doc-est.nro-comp 
                AND  it-nota-fisc.nr-seq-fat   = item-doc-est.seq-comp
                AND  it-nota-fisc.it-codigo    = item-doc-est.it-codigo NO-LOCK NO-ERROR.
     
            IF AVAIL it-nota-fisc THEN DO:
                IF it-nota-fisc.atual-estat = NO THEN NEXT.
            END.
            ELSE NEXT.
            
            IF docum-est.cod-emitente > tt-param.fim-cod-emitente OR
               docum-est.cod-emitente < tt-param.ini-cod-emitente THEN NEXT.
     
            IF emitente.estado       < tt-param.ini-uf           OR
               emitente.estado       > tt-param.fim-uf           THEN NEXT. 


            RUN pi-cria-tt.

            IF  tt-param.tg-lista-chave THEN
                ASSIGN tt-nota-fiscal.cod-chave-aces-nf-eletro = nota-fiscal.cod-chave-aces-nf-eletro.

            FIND FIRST nota-fisc-adc 
               WHERE nota-fisc-adc.cod-estab        = nota-fiscal.cod-estabel
                 AND nota-fisc-adc.cod-serie        = nota-fiscal.serie 
                 AND nota-fisc-adc.cod-nota-fisc    = nota-fiscal.nr-nota-fis
                 AND nota-fisc-adc.cdn-emitente     = nota-fiscal.cod-emitente 
                 AND nota-fisc-adc.cod-natur-operac = nota-fiscal.nat-operacao
                 AND nota-fisc-adc.idi-tip-dado     = 10 NO-LOCK NO-ERROR.
    
            IF  AVAIL nota-fisc-adc THEN DO:
                 CASE SUBSTRING(nota-fisc-adc.cod-livre-2,1,2):
                     WHEN "01" THEN tt-nota-fiscal.situacao = "Documento Regular".
                     WHEN "02" THEN tt-nota-fiscal.situacao = "Documento Regular ExtemporÉneo".
                     WHEN "03" THEN tt-nota-fiscal.situacao = "Documento Cancelado".
                     WHEN "04" THEN tt-nota-fiscal.situacao = "Documento Cancelado ExtemporÉneo".
                     WHEN "05" THEN tt-nota-fiscal.situacao = "NFe Denegada".
                     WHEN "06" THEN tt-nota-fiscal.situacao = "NFe - Numeraá∆o Inutilizada".
                     WHEN "07" THEN tt-nota-fiscal.situacao = "Documento Fiscal Complementar".
                     WHEN "08" THEN tt-nota-fiscal.situacao = "Documento Fiscal Complementar ExtemporÉneo".
                     WHEN "09" THEN tt-nota-fiscal.situacao = "Documento Fiscal Emitido com Base em Regime Especial ou Norma Espec°fica".
                 END CASE.
            END.
            ELSE
                tt-nota-fiscal.situacao = "Documento Regular".

            FOR EACH item-nf-adc FIELDS(val-livre-1 cod-livre-1 cod-livre-2 val-livre-2 cod-livre-4
                                        val-livre-3 val-livre-4)
                WHERE item-nf-adc.cod-estab        = nota-fiscal.cod-estabel
                AND   item-nf-adc.cod-serie        = nota-fiscal.serie
                AND   item-nf-adc.cod-nota-fis     = nota-fiscal.nr-nota-fis
                AND   item-nf-adc.cod-natur-operac = it-nota-fisc.nat-operacao
                AND   item-nf-adc.cod-item         = it-nota-fisc.it-codigo
                AND   item-nf-adc.num-seq-item-nf  = it-nota-fisc.nr-seq-fat NO-LOCK:

                ASSIGN tt-nota-fiscal.d-vl-bc-uf-dest    = tt-nota-fiscal.d-vl-bc-uf-dest    + item-nf-adc.val-livre-1
                       tt-nota-fiscal.d-aliq-uf-dest     = tt-nota-fiscal.d-aliq-uf-dest     + DEC(item-nf-adc.cod-livre-1)
                       tt-nota-fiscal.d-aliq-inter       = tt-nota-fiscal.d-aliq-inter       + DEC(item-nf-adc.cod-livre-2)
                       tt-nota-fiscal.d-perc-icms-fcp    = tt-nota-fiscal.d-perc-icms-fcp    + item-nf-adc.val-livre-2
                       tt-nota-fiscal.d-vl-icms-fcp      = tt-nota-fiscal.d-vl-icms-fcp      + DEC(item-nf-adc.cod-livre-4)
                       tt-nota-fiscal.d-vl-icms-uf-dest  = tt-nota-fiscal.d-vl-icms-uf-dest  + item-nf-adc.val-livre-3
                       tt-nota-fiscal.d-vl-icms-uf-remet = tt-nota-fiscal.d-vl-icms-uf-remet + item-nf-adc.val-livre-4.
            END.
    
            
            /* ----------- Adicionar o valor do fundo de combate a pobresa ao icms subst. --------*/
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

            IF  vlr-fcp-it > 0 AND vlr-fcp-it <> ? THEN
                ASSIGN tt-nota-fiscal.vl-icmsub-it = tt-nota-fiscal.vl-icmsub-it  + vlr-fcp-it.
            

            ASSIGN tt-nota-fiscal.vl-FCP  = vlr-fcp-it 
                   tt-nota-fiscal.aliqFcp = perc-fcp.  
            /*------------------------------------------------------------------------------------*/

            CASE nota-fiscal.idi-sit-nf-eletro :
                WHEN 1 THEN ASSIGN tt-nota-fiscal.sit-nf-eletronica = "N∆o Gerada".
                WHEN 2 THEN ASSIGN tt-nota-fiscal.sit-nf-eletronica = "Em Processamento".
                WHEN 3 THEN ASSIGN tt-nota-fiscal.sit-nf-eletronica = "Uso Autorizado".
                WHEN 4 THEN ASSIGN tt-nota-fiscal.sit-nf-eletronica = "Uso Denegado".
                WHEN 5 THEN ASSIGN tt-nota-fiscal.sit-nf-eletronica = "Rejeitado".
                WHEN 6 THEN ASSIGN tt-nota-fiscal.sit-nf-eletronica = "Cancelada".
                WHEN 7 THEN ASSIGN tt-nota-fiscal.sit-nf-eletronica = "Inutilizada".
                WHEN 8 THEN ASSIGN tt-nota-fiscal.sit-nf-eletronica = "Em Proc. Transmiss∆o".
                WHEN 9 THEN ASSIGN tt-nota-fiscal.sit-nf-eletronica = "Em Processamento SEFAZ".
            END CASE.
    
            ASSIGN i-niv-trib-icms           = 0
                   tt-nota-fiscal.nivel-trib = "".
         
            RUN ftp/ft0515a.p (INPUT  ROWID(it-nota-fisc), 
                               OUTPUT i-niv-trib-icms,      
                               OUTPUT l-sub).
         
            /* CST -> Codigo da Situacao Tributaria (conforme DANFE): Codigo Origem + Nivel Tributacao ICMS */
            ASSIGN i-niv-trib-icms           = INT(STRING(INT(SUBSTRING(it-nota-fisc.char-1,180,3))) + STRING(i-niv-trib-icms, "99"))
                   tt-nota-fiscal.nivel-trib = string(i-niv-trib-icms,"999").

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
                IF SUBSTRING(it-nota-fisc.char-2,96,1) = "1" THEN
                    //ASSIGN tt-nota-fiscal.vl-pis = (tt-nota-fiscal.vl-merc-liq + tt-nota-fiscal.vl-despes-it) * dec(substring(it-nota-fisc.char-2,76,5)) / 100.
                    ASSIGN tt-nota-fiscal.vl-pis = ext-it-nota-fisc.val-livre-3.

                IF SUBSTRING(it-nota-fisc.char-2,97,1) = "1" THEN
                   //ASSIGN tt-nota-fiscal.vl-finsocial  = (tt-nota-fiscal.vl-merc-liq + tt-nota-fiscal.vl-despes-it) * dec(substring(it-nota-fisc.char-2,81,5)) / 100.
                    ASSIGN tt-nota-fiscal.vl-finsocial = ext-it-nota-fisc.val-livre-6.
            END.
    
            ASSIGN tt-nota-fiscal.user-calc = docum-est.usuario.
            
            FOR EACH rat-lote OF item-doc-est:
                ASSIGN tt-nota-fiscal.cod-depos = rat-lote.cod-depos.
            END.

            ASSIGN tt-nota-fiscal.nro-comp   = item-doc-est.nro-comp     
                   tt-nota-fiscal.serie-comp = item-doc-est.serie-comp
                   tt-nota-fiscal.data-comp  = item-doc-est.data-comp         
                   tt-nota-fiscal.nat-comp   = item-doc-est.nat-comp.
    
            IF AVAIL nota-fiscal AND nota-fiscal.nr-pedcli <> "" THEN DO:
                FIND ped-venda
                    WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli
                    AND ped-venda.nome-abrev  = nota-fiscal.nome-ab-cli NO-LOCK NO-ERROR.

                RUN VerificaCartaoCredito.
            END.

            IF tt-param.tg-lei-informatica THEN DO:

                FIND FIRST int-portaria-item NO-LOCK
                     WHERE int-portaria-item.it-codigo   = tt-nota-fiscal.it-codigo
                       AND int-portaria-item.cod-estabel = tt-nota-fiscal.cod-estabel NO-ERROR.
                IF NOT AVAIL int-portaria-item THEN NEXT.

                FIND FIRST int-portaria-movto NO-LOCK
                     WHERE int-portaria-movto.it-codigo      = tt-nota-fiscal.it-codigo
                       AND int-portaria-movto.cod-estabel    = tt-nota-fiscal.cod-estabel
                       AND int-portaria-movto.classificacao <> "BEM"
                       AND int-portaria-movto.dt-fim         = ? NO-ERROR.
                IF NOT AVAIL int-portaria-movto THEN NEXT.

                FIND FIRST bint-portaria-movto NO-LOCK
                     WHERE bint-portaria-movto.it-codigo     = tt-nota-fiscal.it-codigo
                       AND bint-portaria-movto.cod-estabel   = tt-nota-fiscal.cod-estabel
                       AND bint-portaria-movto.classificacao = "BEM"
                       AND bint-portaria-movto.dt-fim        = ? NO-ERROR.

                FIND FIRST int-portaria-perc NO-LOCK
                     WHERE int-portaria-perc.it-codigo   = tt-nota-fiscal.it-codigo
                       AND int-portaria-perc.cod-estabel = tt-nota-fiscal.cod-estabel
                       AND int-portaria-perc.dt-fim      = ? NO-ERROR.
                
                ASSIGN tt-nota-fiscal.portaria             = int-portaria-movto.codigo
                       tt-nota-fiscal.desc-mctic           = int-portaria-item.desc-mctic
                       tt-nota-fiscal.ind-item-fat         = STRING(item.ind-item-fat,"Sim/Nao")
                       tt-nota-fiscal.classificacao        = int-portaria-movto.classificacao 
                       tt-nota-fiscal.dt-ini               = int-portaria-movto.dt-ini
                       tt-nota-fiscal.dt-fim               = int-portaria-movto.dt-fim.

                IF AVAIL int-portaria-perc THEN DO:

                    ASSIGN tt-nota-fiscal.calc-ext-conv1       = ROUND(it-nota-fisc.vl-tot-item * int-portaria-perc.aliq-ext-conv1 / 100,2)                                                                           
                           tt-nota-fiscal.calc-ext-conv2a      = ROUND(it-nota-fisc.vl-tot-item * int-portaria-perc.aliq-ext-conv2a / 100,2)                                                                          
                           tt-nota-fiscal.calc-ext-conv2b      = ROUND(it-nota-fisc.vl-tot-item * int-portaria-perc.aliq-ext-conv2b / 100,2)                                                                          
                           tt-nota-fiscal.calc-ext-fndct       = ROUND(it-nota-fisc.vl-tot-item * int-portaria-perc.aliq-ext-fndct / 100,2)                                                                           
                           tt-nota-fiscal.calc-externo         = ROUND(tt-nota-fiscal.calc-ext-conv1 + tt-nota-fiscal.calc-ext-conv2a + tt-nota-fiscal.calc-ext-conv2b + tt-nota-fiscal.calc-ext-fndct,2)       
                           tt-nota-fiscal.calc-interno         = ROUND(it-nota-fisc.vl-tot-item * int-portaria-perc.aliq-int / 100,2)                                                                                 
                           tt-nota-fiscal.calc-tot             = ROUND(tt-nota-fiscal.calc-externo + tt-nota-fiscal.calc-interno,2)                                                                             
                           tt-nota-fiscal.calc-adic            = ROUND(it-nota-fisc.vl-tot-item * int-portaria-perc.aliq-adic / 100,2)                                                                                
                           tt-nota-fiscal.calc-cred-prod-hab   = IF NOT AVAIL bint-portaria-movto THEN ROUND(it-nota-fisc.vl-tot-item * int-portaria-perc.aliq-cred-hab / 100,2) ELSE 0                               
                           tt-nota-fiscal.calc-cred-bem-desenv = IF     AVAIL bint-portaria-movto THEN ROUND(it-nota-fisc.vl-tot-item * int-portaria-perc.aliq-cred-bem / 100,2) ELSE 0                               
                           tt-nota-fiscal.calc-limit-cred      = ROUND(tt-nota-fiscal.calc-cred-prod-hab + tt-nota-fiscal.calc-cred-bem-desenv,2). 
                    
                    ASSIGN tt-nota-fiscal.calc-ext-conv1       = tt-nota-fiscal.calc-ext-conv1       * -1
                           tt-nota-fiscal.calc-ext-conv2a      = tt-nota-fiscal.calc-ext-conv2a      * -1
                           tt-nota-fiscal.calc-ext-conv2b      = tt-nota-fiscal.calc-ext-conv2b      * -1
                           tt-nota-fiscal.calc-ext-fndct       = tt-nota-fiscal.calc-ext-fndct       * -1
                           tt-nota-fiscal.calc-externo         = tt-nota-fiscal.calc-externo         * -1
                           tt-nota-fiscal.calc-interno         = tt-nota-fiscal.calc-interno         * -1
                           tt-nota-fiscal.calc-tot             = tt-nota-fiscal.calc-tot             * -1
                           tt-nota-fiscal.calc-adic            = tt-nota-fiscal.calc-adic            * -1
                           tt-nota-fiscal.calc-cred-prod-hab   = tt-nota-fiscal.calc-cred-prod-hab   * -1
                           tt-nota-fiscal.calc-cred-bem-desenv = tt-nota-fiscal.calc-cred-bem-desenv * -1
                           tt-nota-fiscal.calc-limit-cred      = tt-nota-fiscal.calc-limit-cred      * -1.

                END.
            END.
        END.

        /** verificar itens da nota fiscal de devoluá∆o que n∆o tiveram a tabela 
            devol-cli criada, porque n∆o foi referenciado uma nota fiscal de sa°da **/    
        FOR EACH tt-nota-fiscal,
           FIRST natur-oper NO-LOCK
           WHERE natur-oper.nat-operacao = tt-nota-fiscal.nat-operacao
             AND natur-oper.tipo = 1 /* devolucao */
        BREAK BY tt-nota-fiscal.cod-estabel    
              BY tt-nota-fiscal.serie         
              BY tt-nota-fiscal.cod-emitente
              BY tt-nota-fiscal.nat-operacao
              BY tt-nota-fiscal.nr-nota-fis:
        
            IF FIRST-OF (tt-nota-fiscal.nr-nota-fis) THEN DO:
                
               FOR EACH item-doc-est NO-LOCK
                  WHERE item-doc-est.cod-estab    = tt-nota-fiscal.cod-estabel  
                    AND item-doc-est.serie-docto  = tt-nota-fiscal.serie        
                    AND item-doc-est.cod-emitente = tt-nota-fiscal.cod-emitente 
                    AND item-doc-est.nat-operacao = tt-nota-fiscal.nat-operacao 
                    AND item-doc-est.nro-docto    = tt-nota-fiscal.nr-nota-fis:

                   FIND FIRST nota-fiscal NO-LOCK
                        WHERE nota-fiscal.cod-estabel = tt-nota-fiscal.cod-estabel  
                          AND nota-fiscal.serie       = tt-nota-fiscal.serie  
                          AND nota-fiscal.nr-nota-fis = tt-nota-fiscal.nr-nota-fis NO-ERROR.

                   FIND FIRST emitente NO-LOCK
                        WHERE emitente.cod-emitente = item-doc-est.cod-emitente NO-ERROR.
        
                   FIND FIRST b-nota NO-LOCK /* b-nota deve ser buffer da tt-nota-fiscal */
                        WHERE b-nota.cod-estabel  = item-doc-est.cod-estab
                          AND b-nota.serie        = item-doc-est.serie-comp
                          AND b-nota.cod-emitente = item-doc-est.cod-emitente
                          AND b-nota.nat-operacao = item-doc-est.nat-comp
                          AND b-nota.nr-nota-fis  = item-doc-est.nro-comp
                          AND b-nota.it-codigo    = item-doc-est.it-codigo NO-ERROR.
                   IF NOT AVAIL b-nota THEN DO:
                       RUN pi-cria-tt.   
                   END.
               END.
            END.
        END.
        
        /** selecionar notas complementares de impostos
            de devoluá‰es recebidas **/
        RUN esp/es0018p.p (INPUT "esftp041", /* Nome do programa */
                           INPUT 1,         /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

        FOR EACH docum-est
           WHERE docum-est.cod-estabel >= tt-param.ini-cod-estabel
             AND docum-est.cod-estabel <= tt-param.fim-cod-estabel
             AND docum-est.dt-trans    >= tt-param.ini-data  
             AND docum-est.dt-trans    <= tt-param.fim-data NO-LOCK,
           FIRST natur-oper NO-LOCK
           WHERE natur-oper.nat-operacao = docum-est.nat-operacao
             AND natur-oper.especie-doc = 'NFE',
            EACH item-doc-est OF docum-est NO-LOCK     
           WHERE item-doc-est.it-codigo >= tt-param.ini-it-codigo
             AND item-doc-est.it-codigo <= tt-param.fim-it-codigo:
        
            IF NOT CAN-FIND (FIRST tt-prog-ponto
                             WHERE tt-prog-ponto.conteudo = item-doc-est.it-codigo) THEN
                NEXT.

            FIND FIRST emitente NO-LOCK
                 WHERE emitente.cod-emitente = docum-est.cod-emitente NO-ERROR.
            
            FIND FIRST ITEM NO-LOCK
                 WHERE item.it-codigo = item-doc-est.it-codigo NO-ERROR.

            FIND FIRST nota-fiscal NO-LOCK 
                 WHERE nota-fiscal.cod-estabel = docum-est.cod-estabel  
                   AND nota-fiscal.serie       = docum-est.serie-docto  
                   AND nota-fiscal.nr-nota-fis = docum-est.nro-docto NO-ERROR.
            
            RUN pi-cria-tt.   
        END.
    END.

    
    IF tt-param.tipo = 1 THEN DO:
        IF tt-param.excel = YES THEN DO:

            ASSIGN c-separador = ";".

            IF  tt-param.segmento = YES THEN
                IF  tt-param.imprime-cancel THEN
                    IF  tt-param.tg-lista-chave THEN
                        PUT "Est;Ser;Nr.Nota;Operacao;Fatura;Dt.Emissao;Canal ;Pedido  ;Cliente;Nome           ;UF;Embar;Natur.;ICMS%  ;IPI%  ;Vlr.Merc.(Real);Vlr.Merc.(Dolar)         ;Frete        ;Vlr ICMS ;Base Calculo ICMS        ;Vlr.IPI ;Vl.Base S.Trib. ;ICMS Sub.Tr.       ;Despesas       ;Vlr PIS    ;Vlr COFINS       ;Vl.Tot.NF;Vl.DCI;Usuario    ;CF;Ins Estadual;Trib.Cliente;Mensagem;Nota Origem Devolucao;Serie;Data Origem;Natureza;Situaá∆o;Observacao                                                                   ;Cond Pagto;Bandeira Cart;Segmento;Des.Segmento;Vlr Imposto ISS;Aliquota.ISS;Inf.Impst.Retido;Dt.Saida;Dt.Entrega Efetiva;Cod.Transp;Nome transportadora;CIF;Depos;Auditoria;Vl BC UF Dest;Vl ICMS FCP;Vl ICMS UF Dest;Vl ICMS UF Remet;Contrib.ICMS;Sit.Documento;Dt.Cancel;DANFE;Aliq FCP;Vl FCP;Conta Contabil;PO Cliente;NR Seq Fat;Suframa;Motivo Inutilizacao/Rejeicao;Docto Referenciado".
                    ELSE
                        PUT "Est;Ser;Nr.Nota;Operacao;Fatura;Dt.Emissao;Canal ;Pedido  ;Cliente;Nome           ;UF;Embar;Natur.;ICMS%  ;IPI%  ;Vlr.Merc.(Real);Vlr.Merc.(Dolar)         ;Frete        ;Vlr ICMS ;Base Calculo ICMS        ;Vlr.IPI ;Vl.Base S.Trib. ;ICMS Sub.Tr.       ;Despesas       ;Vlr PIS    ;Vlr COFINS       ;Vl.Tot.NF;Vl.DCI;Usuario    ;CF;Ins Estadual;Trib.Cliente;Mensagem;Nota Origem Devolucao;Serie;Data Origem;Natureza;Situaá∆o;Observacao                                                                   ;Cond Pagto;Bandeira Cart;Segmento;Des.Segmento;Vlr Imposto ISS;Aliquota.ISS;Inf.Impst.Retido;Dt.Saida;Dt.Entrega Efetiva;Cod.Transp;Nome transportadora;CIF;Depos;Auditoria;Vl BC UF Dest;Vl ICMS FCP;Vl ICMS UF Dest;Vl ICMS UF Remet;Contrib.ICMS;Sit.Documento;Dt.Cancel;Aliq FCP;Vl FCP;Conta Contabil;PO Cliente;NR Seq Fat;Suframa;Motivo Inutilizacao/Rejeicao;Docto Referenciado".
                ELSE
                    IF  tt-param.tg-lista-chave THEN
                        PUT "Est;Ser;Nr.Nota;Operacao;Fatura;Dt.Emissao;Canal ;Pedido  ;Cliente;Nome           ;UF;Embar;Natur.;ICMS%  ;IPI%  ;Vlr.Merc.(Real);Vlr.Merc.(Dolar)         ;Frete        ;Vlr ICMS ;Base Calculo ICMS        ;Vlr.IPI ;Vl.Base S.Trib. ;ICMS Sub.Tr.       ;Despesas       ;Vlr PIS    ;Vlr COFINS       ;Vl.Tot.NF;Vl.DCI;Usuario    ;CF;Ins Estadual;Trib.Cliente;Mensagem;Nota Origem Devolucao;Serie;Data Origem;Natureza;Situaá∆o;Observacao                                                                   ;Cond Pagto;Bandeira Cart;Segmento;Des.Segmento;Vlr Imposto ISS;Aliquota.ISS;Inf.Impst.Retido;Dt.Saida;Dt.Entrega Efetiva;Cod.Transp;Nome transportadora;CIF;Depos;Auditoria;Vl BC UF Dest;Vl ICMS FCP;Vl ICMS UF Dest;Vl ICMS UF Remet;Contrib.ICMS;Sit.Documento;DANFE;Aliq FCP;Vl FCP;Conta Contabil;PO Cliente;NR Seq Fat;Suframa;Docto Referenciado".
                    ELSE
                        PUT "Est;Ser;Nr.Nota;Operacao;Fatura;Dt.Emissao;Canal ;Pedido  ;Cliente;Nome           ;UF;Embar;Natur.;ICMS%  ;IPI%  ;Vlr.Merc.(Real);Vlr.Merc.(Dolar)         ;Frete        ;Vlr ICMS ;Base Calculo ICMS        ;Vlr.IPI ;Vl.Base S.Trib. ;ICMS Sub.Tr.       ;Despesas       ;Vlr PIS    ;Vlr COFINS       ;Vl.Tot.NF;Vl.DCI;Usuario    ;CF;Ins Estadual;Trib.Cliente;Mensagem;Nota Origem Devolucao;Serie;Data Origem;Natureza;Situaá∆o;Observacao                                                                   ;Cond Pagto;Bandeira Cart;Segmento;Des.Segmento;Vlr Imposto ISS;Aliquota.ISS;Inf.Impst.Retido;Dt.Saida;Dt.Entrega Efetiva;Cod.Transp;Nome transportadora;CIF;Depos;Auditoria;Vl BC UF Dest;Vl ICMS FCP;Vl ICMS UF Dest;Vl ICMS UF Remet;Contrib.ICMS;Sit.Documento;Aliq FCP;Vl FCP;Conta Contabil;PO Cliente;NR Seq Fat;Suframa;Docto Referenciado".
            ELSE
                IF  tt-param.imprime-cancel THEN
                    IF  tt-param.tg-lista-chave THEN
                        PUT "Est;Ser;Nr.Nota;Operacao;Fatura;Dt.Emissao;Canal ;Pedido  ;Cliente;Nome           ;UF;Embar;Natur.;ICMS%  ;IPI%  ;Vlr.Merc.(Real);Vlr.Merc.(Dolar)         ;Frete        ;Vlr ICMS ;Base Calculo ICMS        ;Vlr.IPI ;Vl.Base S.Trib. ;ICMS Sub.Tr.       ;Despesas       ;Vlr PIS    ;Vlr COFINS       ;Vl.Tot.NF;Vl.DCI;Usuario    ;CF;Ins Estadual;Trib.Cliente;Mensagem;Nota Origem Devolucao;Serie;Data Origem;Natureza;Situaá∆o;Observacao                                                                   ;Cond Pagto;Bandeira Cart;Vlr Imposto ISS;Aliquota.ISS;Inf.Impst.Retido;Dt.Saida;Dt.Entrega Efetiva;Cod.Transp;Nome Transportadora;CIF;Depos;Auditoria;Vl BC UF Dest;Vl ICMS FCP;Vl ICMS UF Dest;Vl ICMS UF Remet;Contrib.ICMS;Sit.Documento;Dt.Cancel;DANFE;Aliq FCP;Vl FCP;Conta Contabil;PO Cliente;NR Seq Fat;Suframa;Motivo Inutilizacao/Rejeicao;Docto Referenciado".
                    ELSE
                        PUT "Est;Ser;Nr.Nota;Operacao;Fatura;Dt.Emissao;Canal ;Pedido  ;Cliente;Nome           ;UF;Embar;Natur.;ICMS%  ;IPI%  ;Vlr.Merc.(Real);Vlr.Merc.(Dolar)         ;Frete        ;Vlr ICMS ;Base Calculo ICMS        ;Vlr.IPI ;Vl.Base S.Trib. ;ICMS Sub.Tr.       ;Despesas       ;Vlr PIS    ;Vlr COFINS       ;Vl.Tot.NF;Vl.DCI;Usuario    ;CF;Ins Estadual;Trib.Cliente;Mensagem;Nota Origem Devolucao;Serie;Data Origem;Natureza;Situaá∆o;Observacao                                                                   ;Cond Pagto;Bandeira Cart;Vlr Imposto ISS;Aliquota.ISS;Inf.Impst.Retido;Dt.Saida;Dt.Entrega Efetiva;Cod.Transp;Nome Transportadora;CIF;Depos;Auditoria;Vl BC UF Dest;Vl ICMS FCP;Vl ICMS UF Dest;Vl ICMS UF Remet;Contrib.ICMS;Sit.Documento;Dt.Cancel;Aliq FCP;Vl FCP;Conta Contabil;PO Cliente;NR Seq Fat;Suframa;Motivo Inutilizacao/Rejeicao;Docto Referenciado".
                ELSE
                    IF  tt-param.tg-lista-chave THEN
                        PUT "Est;Ser;Nr.Nota;Operacao;Fatura;Dt.Emissao;Canal ;Pedido  ;Cliente;Nome           ;UF;Embar;Natur.;ICMS%  ;IPI%  ;Vlr.Merc.(Real);Vlr.Merc.(Dolar)         ;Frete        ;Vlr ICMS ;Base Calculo ICMS        ;Vlr.IPI ;Vl.Base S.Trib. ;ICMS Sub.Tr.       ;Despesas       ;Vlr PIS    ;Vlr COFINS       ;Vl.Tot.NF;Vl.DCI;Usuario    ;CF;Ins Estadual;Trib.Cliente;Mensagem;Nota Origem Devolucao;Serie;Data Origem;Natureza;Situaá∆o;Observacao                                                                   ;Cond Pagto;Bandeira Cart;Vlr Imposto ISS;Aliquota.ISS;Inf.Impst.Retido;Dt.Saida;Dt.Entrega Efetiva;Cod.Transp;Nome Transportadora;CIF;Depos;Auditoria;Vl BC UF Dest;Vl ICMS FCP;Vl ICMS UF Dest;Vl ICMS UF Remet;Contrib.ICMS;Sit.Documento;DANFE;Aliq FCP;Vl FCP;Conta Contabil;PO Cliente;NR Seq Fat;Suframa;Docto Referenciado".
                    ELSE
                        PUT "Est;Ser;Nr.Nota;Operacao;Fatura;Dt.Emissao;Canal ;Pedido  ;Cliente;Nome           ;UF;Embar;Natur.;ICMS%  ;IPI%  ;Vlr.Merc.(Real);Vlr.Merc.(Dolar)         ;Frete        ;Vlr ICMS ;Base Calculo ICMS        ;Vlr.IPI ;Vl.Base S.Trib. ;ICMS Sub.Tr.       ;Despesas       ;Vlr PIS    ;Vlr COFINS       ;Vl.Tot.NF;Vl.DCI;Usuario    ;CF;Ins Estadual;Trib.Cliente;Mensagem;Nota Origem Devolucao;Serie;Data Origem;Natureza;Situaá∆o;Observacao                                                                   ;Cond Pagto;Bandeira Cart;Vlr Imposto ISS;Aliquota.ISS;Inf.Impst.Retido;Dt.Saida;Dt.Entrega Efetiva;Cod.Transp;Nome Transportadora;CIF;Depos;Auditoria;Vl BC UF Dest;Vl ICMS FCP;Vl ICMS UF Dest;Vl ICMS UF Remet;Contrib.ICMS;Sit.Documento;Aliq FCP;Vl FCP;Conta Contabil;PO Cliente;NR Seq Fat;Suframa;Docto Referenciado".

            IF tt-param.tg-lei-informatica THEN
                PUT ";Portaria;Desc Item MCTIC;Item Fat;Classif Atual;Valid Ini;Valid Fim;Ext Conv1;Ext Conv2a;Ext Conv2b;Ext FNDCT;%Externo;%Interno;Tot Contra Partida;Calc %Adic P&D;Calc Cred Prod Habilit;Calc Cred Bem Desenv;Limite Cred Informat".

            PUT SKIP.

        END.
        ELSE DO:
            ASSIGN c-separador = " ". 

            IF tt-param.segmento = YES THEN
                IF  tt-param.imprime-cancel THEN
                    IF  tt-param.tg-lista-chave THEN
                        PUT "Est Ser   Nr.Nota Operacao Fatura  Dt.Emissao   Canal Pedido          Cliente  Nome             UF Embar  Natur.   ICMS%    IPI%   Vlr.Merc.(Real)  Vlr.Merc.(Dolar)           Frete         Vlr ICMS  BC ICMS        Vlr.IPI  Vl.Base S.Trib.    ICMS Sub.Tr.         Despesas         Vlr PIS      Vlr COFINS        Vl.Tot.NF  Vl.DCI    Usuario      CF   Ins Estadual         T           M   Nota Origem Devolucao Serie  Data Origem  Natureza Situaá∆o Observacao Cond Pagto Bandeira Cart Segmento Descriá∆o.Segmento                                  Vlr.Imposto ISS  Aliquota.Iss  Inf.Impst.Retido Dt.Saida Dt.Entrega Efetiva Cod.Transp Nome Transportadora CIF Dep Auditoria Vl BC UF Dest Vl ICMS FCP Vl ICMS UF Dest Vl ICMS UF Remet Contrib.ICMS Sit.Documento Dt.Cancel DANFE Aliq.FCP Vl.FCP Conta Contabil NR Seq Fat Suframa Docto Referenciado" SKIP.
                    ELSE
                        PUT "Est Ser   Nr.Nota Operacao Fatura  Dt.Emissao   Canal Pedido          Cliente  Nome             UF Embar  Natur.   ICMS%    IPI%   Vlr.Merc.(Real)  Vlr.Merc.(Dolar)           Frete         Vlr ICMS  BC ICMS        Vlr.IPI  Vl.Base S.Trib.    ICMS Sub.Tr.         Despesas         Vlr PIS      Vlr COFINS        Vl.Tot.NF  Vl.DCI    Usuario      CF   Ins Estadual         T           M   Nota Origem Devolucao Serie  Data Origem  Natureza Situaá∆o Observacao Cond Pagto Bandeira Cart Segmento Descriá∆o.Segmento                                  Vlr.Imposto ISS  Aliquota.Iss  Inf.Impst.Retido Dt.Saida Dt.Entrega Efetiva Cod.Transp Nome Transportadora CIF Dep Auditoria Vl BC UF Dest Vl ICMS FCP Vl ICMS UF Dest Vl ICMS UF Remet Contrib.ICMS Sit.Documento Dt.Cancel Aliq.FCP Vl.FCP Conta Contabil NR Seq Fat Suframa Docto Referenciado" SKIP.
                ELSE
                    IF  tt-param.tg-lista-chave THEN
                        PUT "Est Ser   Nr.Nota Operacao Fatura  Dt.Emissao   Canal Pedido          Cliente  Nome             UF Embar  Natur.   ICMS%    IPI%   Vlr.Merc.(Real)  Vlr.Merc.(Dolar)           Frete         Vlr ICMS  BC ICMS        Vlr.IPI  Vl.Base S.Trib.    ICMS Sub.Tr.         Despesas         Vlr PIS      Vlr COFINS        Vl.Tot.NF  Vl.DCI    Usuario      CF   Ins Estadual         T           M   Nota Origem Devolucao Serie  Data Origem  Natureza Situaá∆o Observacao Cond Pagto Bandeira Cart Segmento Descriá∆o.Segmento                                  Vlr.Imposto ISS  Aliquota.Iss  Inf.Impst.Retido Dt.Saida Dt.Entrega Efetiva Cod.Transp Nome Transportadora CIF Dep Auditoria Vl BC UF Dest Vl ICMS FCP Vl ICMS UF Dest Vl ICMS UF Remet Contrib.ICMS Sit.Documento DANFE Aliq.FCP Vl.FCP Conta Contabil NR Seq Fat Suframa Docto Referenciado" SKIP.
                    ELSE
                        PUT "Est Ser   Nr.Nota Operacao Fatura  Dt.Emissao   Canal Pedido          Cliente  Nome             UF Embar  Natur.   ICMS%    IPI%   Vlr.Merc.(Real)  Vlr.Merc.(Dolar)           Frete         Vlr ICMS  BC ICMS        Vlr.IPI  Vl.Base S.Trib.    ICMS Sub.Tr.         Despesas         Vlr PIS      Vlr COFINS        Vl.Tot.NF  Vl.DCI    Usuario      CF   Ins Estadual         T           M   Nota Origem Devolucao Serie  Data Origem  Natureza Situaá∆o Observacao Cond Pagto Bandeira Cart Segmento Descriá∆o.Segmento                                  Vlr.Imposto ISS  Aliquota.Iss  Inf.Impst.Retido Dt.Saida Dt.Entrega Efetiva Cod.Transp Nome Transportadora CIF Dep Auditoria Vl BC UF Dest Vl ICMS FCP Vl ICMS UF Dest Vl ICMS UF Remet Contrib.ICMS Sit.Documento Aliq.FCP Vl.FCP Conta Contabil NR Seq Fat Suframa Docto Referenciado" SKIP.

            ELSE
                IF  tt-param.imprime-cancel THEN
                    IF  tt-param.tg-lista-chave THEN
                        PUT "Est Ser   Nr.Nota Operacao Fatura  Dt.Emissao   Canal Pedido          Cliente  Nome             UF Embar  Natur.   ICMS%    IPI%   Vlr.Merc.(Real)  Vlr.Merc.(Dolar)           Frete         Vlr ICMS  BC ICMS        Vlr.IPI  Vl.Base S.Trib.    ICMS Sub.Tr.         Despesas         Vlr PIS      Vlr COFINS        Vl.Tot.NF  Vl.DCI    Usuario      CF   Ins Estadual         T           M   Nota Origem Devolucao Serie  Data Origem  Natureza Situaá∆o Observacao Cond Pagto Bandeira Cart Vlr.Imposto ISS  Aliquota.Iss  Inf.Impst.Retido Dt.Saida Dt.Entrega Efetiva Cod.Transp Nome Transportadora CIF Dep Auditoria Vl BC UF Dest Vl ICMS FCP Vl ICMS UF Dest Vl ICMS UF Remet Contrib.ICMS Sit.Documento Dt.Cancel DANFE Aliq.FCP Vl.FCP Conta Contabil PO Cliente NR Seq Fat Suframa Docto Referenciado" SKIP.
                    ELSE
                        PUT "Est Ser   Nr.Nota Operacao Fatura  Dt.Emissao   Canal Pedido          Cliente  Nome             UF Embar  Natur.   ICMS%    IPI%   Vlr.Merc.(Real)  Vlr.Merc.(Dolar)           Frete         Vlr ICMS  BC ICMS        Vlr.IPI  Vl.Base S.Trib.    ICMS Sub.Tr.         Despesas         Vlr PIS      Vlr COFINS        Vl.Tot.NF  Vl.DCI    Usuario      CF   Ins Estadual         T           M   Nota Origem Devolucao Serie  Data Origem  Natureza Situaá∆o Observacao Cond Pagto Bandeira Cart Vlr.Imposto ISS  Aliquota.Iss  Inf.Impst.Retido Dt.Saida Dt.Entrega Efetiva Cod.Transp Nome Transportadora CIF Dep Auditoria Vl BC UF Dest Vl ICMS FCP Vl ICMS UF Dest Vl ICMS UF Remet Contrib.ICMS Sit.Documento Dt.Cancel Sit.Documento Aliq.FCP Vl.FCP Conta Contabil PO Cliente NR Seq Fat Suframa Docto Referenciado" SKIP.
                ELSE
                    IF  tt-param.tg-lista-chave THEN
                        PUT "Est Ser   Nr.Nota Operacao Fatura  Dt.Emissao   Canal Pedido          Cliente  Nome             UF Embar  Natur.   ICMS%    IPI%   Vlr.Merc.(Real)  Vlr.Merc.(Dolar)           Frete         Vlr ICMS  BC ICMS        Vlr.IPI  Vl.Base S.Trib.    ICMS Sub.Tr.         Despesas         Vlr PIS      Vlr COFINS        Vl.Tot.NF  Vl.DCI    Usuario      CF   Ins Estadual         T           M   Nota Origem Devolucao Serie  Data Origem  Natureza Situaá∆o Observacao Cond Pagto Bandeira Cart Vlr.Imposto ISS  Aliquota.Iss  Inf.Impst.Retido Dt.Saida Dt.Entrega Efetiva Cod.Transp Nome Transportadora CIF Dep Auditoria Vl BC UF Dest Vl ICMS FCP Vl ICMS UF Dest Vl ICMS UF Remet Contrib.ICMS Sit.Documento DANFE Aliq.FCP Vl.FCP Conta Contabil PO Cliente NR Seq Fat Suframa Docto Referenciado" SKIP.
                    ELSE
                        PUT "Est Ser   Nr.Nota Operacao Fatura  Dt.Emissao   Canal Pedido          Cliente  Nome             UF Embar  Natur.   ICMS%    IPI%   Vlr.Merc.(Real)  Vlr.Merc.(Dolar)           Frete         Vlr ICMS  BC ICMS        Vlr.IPI  Vl.Base S.Trib.    ICMS Sub.Tr.         Despesas         Vlr PIS      Vlr COFINS        Vl.Tot.NF  Vl.DCI    Usuario      CF   Ins Estadual         T           M   Nota Origem Devolucao Serie  Data Origem  Natureza Situaá∆o Observacao Cond Pagto Bandeira Cart Vlr.Imposto ISS  Aliquota.Iss  Inf.Impst.Retido Dt.Saida Dt.Entrega Efetiva Cod.Transp Nome Transportadora CIF Dep Auditoria Vl BC UF Dest Vl ICMS FCP Vl ICMS UF Dest Vl ICMS UF Remet Contrib.ICMS Sit.Documento Aliq.FCP Vl.FCP Conta Contabil PO Cliente NR Seq Fat Suframa Docto Referenciado" SKIP.
        END.

        FOR EACH tt-nota-fiscal
            WHERE tt-nota-fiscal.user-calc >= tt-param.ini-usuario
            AND   tt-nota-fiscal.user-calc <= tt-param.fim-usuario NO-LOCK,
            FIRST item
            WHERE item.it-codigo = tt-nota-fiscal.it-codigo NO-LOCK
            BREAK BY tt-nota-fiscal.cod-estabel
                  BY tt-nota-fiscal.serie
                  BY tt-nota-fiscal.nr-nota-fis:

            RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo " + tt-nota-fiscal.nr-nota-fis).

            FIND FIRST int-ped-venda NO-LOCK
                 WHERE int-ped-venda.nr-pedido = int(tt-nota-fiscal.nr-pedcli) NO-ERROR.
            IF AVAIL int-ped-venda THEN
                ASSIGN c-pocliente = SUBSTRING(int-ped-venda.char-1,53,12).
            ELSE
                 ASSIGN c-pocliente = "".

            FIND natur-oper
                WHERE natur-oper.nat-operacao = tt-nota-fiscal.nat-operacao NO-LOCK NO-ERROR.

            FIND emitente
                WHERE emitente.cod-emitente = tt-nota-fiscal.cod-emitente NO-LOCK NO-ERROR.

            FIND FIRST tt-class
                WHERE tt-class.ncm = tt-nota-fiscal.class-fiscal NO-ERROR.

            IF NOT AVAIL tt-class THEN DO:
                CREATE tt-class.
                ASSIGN tt-class.ncm = tt-nota-fiscal.class-fiscal.
            END.

            ASSIGN tt-class.valor = tt-class.valor + tt-nota-fiscal.vl-merc-liq.

            FOR FIRST movto-estoq
                WHERE movto-estoq.cod-estabel  = tt-nota-fiscal.cod-estabel
                AND   movto-estoq.serie-docto  = tt-nota-fiscal.serie              
                AND   movto-estoq.nro-docto    = tt-nota-fiscal.nr-nota-fis
                AND   movto-estoq.cod-emitente = tt-nota-fiscal.cod-emitente
                AND   movto-estoq.nat-operacao = tt-nota-fiscal.nat-operacao NO-LOCK: END.

            IF FIRST-OF(tt-nota-fiscal.nr-nota-fis) THEN DO:
                ASSIGN de-vl-merc-liq      = 0
                       de-vl-merc-liq-me   = 0
                       de-vl-frete-it      = 0
                       de-vl-icms-it       = 0
                       de-vl-bicms-it      = 0
                       de-vl-ipi-it        = 0
                       de-vl-despes-it     = 0
                       de-vl-pis           = 0
                       de-vl-finsocial     = 0
                       de-vl-tot-item      = 0
                       de-vl-icmsub-it     = 0
                       de-vl-bsubs-it      = 0
                       de-vl-dci           = 0
                       de-vl-bc-uf-dest    = 0
                       de-aliq-uf-dest     = 0
                       de-aliq-inter       = 0
                       de-perc-icms-fcp    = 0
                       de-vl-icms-fcp      = 0
                       de-vl-icms-uf-dest  = 0
                       de-vl-icms-uf-remet = 0
                       de-tot-valor-FCP    = 0.

                FIND ped-fiscal
                    WHERE ped-fiscal.cod-estabel = tt-nota-fiscal.cod-estabel
                    AND   ped-fiscal.serie       = tt-nota-fiscal.serie
                    AND   ped-fiscal.nr-nota-fis = tt-nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.

                PUT UNFORMATTED 
                    tt-nota-fiscal.cod-estabel FORMAT "x(03)" c-separador
                    tt-nota-fiscal.serie       FORMAT "x(03)" c-separador
                    tt-nota-fiscal.nr-nota-fis FORMAT "x(10)" c-separador.

                IF natur-oper.tipo = 1 THEN
                    PUT UNFORMATTED  "Devolucao" c-separador.
                ELSE
                    IF natur-oper.atual-estat = YES THEN
                        PUT UNFORMATTED  "Normal" c-separador.
                    ELSE
                        PUT UNFORMATTED "Outras" c-separador.

                PUT UNFORMATTED
                    tt-nota-fiscal.nr-fatura   FORMAT "X(10)"  c-separador
                    tt-nota-fiscal.dt-emis-nota                c-separador
                    tt-nota-fiscal.cod-canal-venda             c-separador.

                IF AVAIL ped-fiscal THEN
                    PUT UNFORMATTED STRING(ped-fiscal.nr-pedido) c-separador.
                ELSE
                    PUT UNFORMATTED tt-nota-fiscal.nr-pedcli    c-separador.

                PUT  UNFORMATTED 
                    tt-nota-fiscal.cod-emitente c-separador
                    tt-nota-fiscal.nome-abrev   c-separador
                    tt-nota-fiscal.estado       c-separador              
                    tt-nota-fiscal.nr-embarque  c-separador
                    tt-nota-fiscal.nat-operacao c-separador
                    tt-nota-fiscal.aliquota-icm c-separador
                    tt-nota-fiscal.aliquota-ipi c-separador.
            END.

            ASSIGN de-vl-merc-liq      = de-vl-merc-liq      + tt-nota-fiscal.vl-merc-liq 
                   de-vl-merc-liq-me   = de-vl-merc-liq-me   + tt-nota-fiscal.vl-merc-liq-me     
                   de-vl-frete-it      = de-vl-frete-it      + tt-nota-fiscal.vl-frete-it        
                   de-vl-icms-it       = de-vl-icms-it       + tt-nota-fiscal.vl-icms-it         
                   de-vl-bicms-it      = de-vl-bicms-it      + tt-nota-fiscal.vl-bicms-it
                   de-vl-ipi-it        = de-vl-ipi-it        + tt-nota-fiscal.vl-ipi-it          
                   de-vl-despes-it     = de-vl-despes-it     + tt-nota-fiscal.vl-despes-it       
                   de-vl-pis           = de-vl-pis           + tt-nota-fiscal.vl-pis             
                   de-vl-finsocial     = de-vl-finsocial     + tt-nota-fiscal.vl-finsocial
                   de-vl-tot-item      = de-vl-tot-item      + tt-nota-fiscal.vl-tot-item
                   de-vl-icmsub-it     = de-vl-icmsub-it     + tt-nota-fiscal.vl-icmsub-it   
                   de-vl-bsubs-it      = de-vl-bsubs-it      + tt-nota-fiscal.vl-bsubs-it
                   de-vl-dci           = de-vl-dci           + tt-nota-fiscal.vl-dci
                   de-vl-bc-uf-dest    = de-vl-bc-uf-dest    + tt-nota-fiscal.d-vl-bc-uf-dest   
                   de-aliq-uf-dest     = tt-nota-fiscal.d-aliq-uf-dest    
                   de-aliq-inter       = tt-nota-fiscal.d-aliq-inter      
                   de-perc-icms-fcp    = tt-nota-fiscal.d-perc-icms-fcp   
                   de-vl-icms-fcp      = de-vl-icms-fcp      + tt-nota-fiscal.d-vl-icms-fcp     
                   de-vl-icms-uf-dest  = de-vl-icms-uf-dest  + tt-nota-fiscal.d-vl-icms-uf-dest 
                   de-vl-icms-uf-remet = de-vl-icms-uf-remet + tt-nota-fiscal.d-vl-icms-uf-remet
                   de-tot-valor-FCP    = de-tot-valor-FCP     + tt-nota-fiscal.vl-FCP.

            ASSIGN de-tot-merc-liq      = de-tot-merc-liq      + tt-nota-fiscal.vl-merc-liq 
                   de-tot-merc-liq-me   = de-tot-merc-liq-me   + tt-nota-fiscal.vl-merc-liq-me     
                   de-tot-frete-it      = de-tot-frete-it      + tt-nota-fiscal.vl-frete-it        
                   de-tot-icms-it       = de-tot-icms-it       + tt-nota-fiscal.vl-icms-it
                   de-tot-bicms-it      = de-tot-bicms-it      + tt-nota-fiscal.vl-bicms-it
                   de-tot-ipi-it        = de-tot-ipi-it        + tt-nota-fiscal.vl-ipi-it          
                   de-tot-despes-it     = de-tot-despes-it     + tt-nota-fiscal.vl-despes-it       
                   de-tot-pis           = de-tot-pis           + tt-nota-fiscal.vl-pis             
                   de-tot-finsocial     = de-tot-finsocial     + tt-nota-fiscal.vl-finsocial
                   de-tot-tot-item      = de-tot-tot-item      + tt-nota-fiscal.vl-tot-item
                   de-tot-vl-icmsub-it  = de-tot-vl-icmsub-it  + tt-nota-fiscal.vl-icmsub-it   
                   de-tot-vl-bsubs-it   = de-tot-vl-bsubs-it   + tt-nota-fiscal.vl-bsubs-it
                   de-tot-vl-dci        = de-tot-vl-dci        + tt-nota-fiscal.vl-dci
                   de-tot-bc-uf-dest    = de-tot-bc-uf-dest    + tt-nota-fiscal.d-vl-bc-uf-dest    
                   de-tot-aliq-uf-dest  = de-tot-aliq-uf-dest  + tt-nota-fiscal.d-aliq-uf-dest     
                   de-tot-aliq-inter    = de-tot-aliq-inter    + tt-nota-fiscal.d-aliq-inter       
                   de-tot-perc-icms-fcp = de-tot-perc-icms-fcp + tt-nota-fiscal.d-perc-icms-fcp      
                   de-tot-icms-fcp      = de-tot-icms-fcp      + tt-nota-fiscal.d-vl-icms-fcp      
                   de-tot-icms-uf-dest  = de-tot-icms-uf-dest  + tt-nota-fiscal.d-vl-icms-uf-dest  
                   de-tot-icms-uf-remet = de-tot-icms-uf-remet + tt-nota-fiscal.d-vl-icms-uf-remet.

            IF LAST-OF(tt-nota-fiscal.nr-nota-fis) THEN DO:
                PUT UNFORMATTED
                    de-vl-merc-liq                   c-separador
                    de-vl-merc-liq-me                c-separador
                    de-vl-frete-it                   c-separador
                    de-vl-icms-it                    c-separador
                    de-vl-bicms-it                   c-separador
                    de-vl-ipi-it                     c-separador
                    de-vl-bsubs-it                   c-separador            
                    de-vl-icmsub-it                  c-separador           
                    de-vl-despes-it                  c-separador
                    de-vl-pis                        c-separador
                    de-vl-finsocial                  c-separador
                    de-vl-tot-item                   c-separador
                    de-vl-dci                        c-separador
                    tt-nota-fiscal.user-calc         c-separador
                    natur-oper.consum-final          c-separador
                    emitente.ins-estadual            c-separador
                    tt-nota-fiscal.cod-trib-cliente  c-separador
                    tt-nota-fiscal.cod-mensagem      c-separador
                    tt-nota-fiscal.nro-comp          c-separador
                    tt-nota-fiscal.serie-comp        c-separador
                    tt-nota-fiscal.data-comp         c-separador
                    tt-nota-fiscal.nat-comp          c-separador
                    tt-nota-fiscal.sit-nf-eletronica c-separador.

                IF AVAIL ped-fiscal THEN
                    PUT UNFORMATTED ped-fiscal.observacao[1]    c-separador.
                ELSE
                    PUT UNFORMATTED "        " c-separador.

                PUT UNFORMATTED tt-nota-fiscal.cod-cond-pag c-separador
                    tt-nota-fiscal.cod_admdra_cartao_cr c-separador.

                IF tt-param.segmento = YES THEN DO:
                    
                    PUT UNFORMATTED SUBSTRING(item.fm-cod-com,1,4) c-separador.
                    
                    FIND fam-com-item NO-LOCK
                        WHERE fam-com-item.fm-cod-com = substring(item.fm-cod-com,1,4) NO-ERROR.
                
                    IF AVAIL fam-com-item THEN
                        PUT UNFORMATTED fam-com-item.descricao c-separador.
                    ELSE
                        PUT UNFORMATTED c-separador.
                END.

                PUT UNFORMATTED tt-nota-fiscal.imposto c-separador.
                PUT UNFORMATTED tt-nota-fiscal.aliquota c-separador.

                IF  SUBSTRING(natur-oper.char-2,123,1) = "1" THEN
                    PUT UNFORMATTED "Sim" c-separador.
                ELSE
                    PUT UNFORMATTED "N∆o" c-separador.

                PUT UNFORMATTED tt-nota-fiscal.dt-saida c-separador.
                PUT UNFORMATTED tt-nota-fiscal.dt-entr-cli  c-separador
                    tt-nota-fiscal.cod-transp c-separador
                    tt-nota-fiscal.nome-transp c-separador.

                IF tt-nota-fiscal.cif = YES THEN
                    PUT "Sim" c-separador.
                ELSE
                    PUT "Nao" c-separador.

                PUT UNFORMATTED tt-nota-fiscal.cod-depos      c-separador
                                tt-nota-fiscal.auditoria      c-separador.

                PUT UNFORMATTED de-vl-bc-uf-dest            c-separador
                                de-vl-icms-fcp              c-separador  
                                de-vl-icms-uf-dest          c-separador
                                de-vl-icms-uf-remet         c-separador
                                tt-nota-fiscal.contrib-icms c-separador
                                tt-nota-fiscal.situacao     c-separador.

                IF  tt-param.imprime-cancel THEN
                    IF  tt-param.tg-lista-chave THEN
                        PUT UNFORMATTED tt-nota-fiscal.dt-cancel c-separador "'" tt-nota-fiscal.cod-chave-aces-nf-eletro "'" c-separador.
                    ELSE
                        PUT UNFORMATTED tt-nota-fiscal.dt-cancel c-separador.
                ELSE
                    IF  tt-param.tg-lista-chave THEN
                        PUT UNFORMATTED "'" tt-nota-fiscal.cod-chave-aces-nf-eletro "'" c-separador.

                PUT UNFORMATTED tt-nota-fiscal.aliqFcp c-separador de-tot-valor-FCP c-separador.

                ASSIGN c-ct-codigo = "".
                                
                FOR EACH movto-estoq
                    WHERE movto-estoq.cod-estabel  = tt-nota-fiscal.cod-estabel
                    AND   movto-estoq.serie-docto  = tt-nota-fiscal.serie
                    AND   movto-estoq.nro-docto    = tt-nota-fiscal.nr-nota-fis
                    AND   movto-estoq.cod-emitente = tt-nota-fiscal.cod-emitente
                    AND   movto-estoq.nat-operacao = tt-nota-fiscal.nat-operacao NO-LOCK
                    BREAK BY movto-estoq.ct-codigo
                          BY movto-estoq.sc-codigo:

                    IF LAST-OF(movto-estoq.ct-codigo) OR LAST-OF(movto-estoq.sc-codigo) THEN DO:
                        ASSIGN de-valor-contabil = 0.
                
                       FIND estabelec
                           WHERE estabelec.cod-estabel = movto-estoq.cod-estabel NO-LOCK NO-ERROR.

                       FIND contabiliza
                           WHERE contabiliza.cod-estabel = movto-estoq.cod-estabel
                           AND   contabiliza.cod-depos   = movto-estoq.cod-depos
                           AND   contabiliza.ge-codigo   = item.ge-codigo  NO-LOCK NO-ERROR.

                       ASSIGN de-valor-contabil =   movto-estoq.valor-mat-m[1] +
                                                    movto-estoq.valor-mob-m[1] +
                                                    movto-estoq.valor-ggf-m[1].

                       IF c-ct-codigo = "" THEN
                           ASSIGN c-ct-codigo = c-ct-codigo + movto-estoq.ct-codigo + movto-estoq.sc-codigo.
                       ELSE
                           ASSIGN c-ct-codigo = c-ct-codigo + ", " + movto-estoq.ct-codigo + movto-estoq.sc-codigo.
                    END.
                END.

                PUT UNFORMATTED c-ct-codigo c-separador.

                PUT c-pocliente FORMAT "x(12)" c-separador. /*pd cliente pd4000*/

                PUT UNFORMATTED tt-nota-fiscal.nr-sequencia c-separador.
                FIND FIRST emitente NO-LOCK
                     WHERE emitente.cod-emitente = tt-nota-fiscal.cod-emitente NO-ERROR.

                PUT UNFORMATTED emitente.cod-suframa c-separador.
                PUT UNFORMATTED tt-nota-fiscal.docto-referenciado.

                IF tt-param.imprime-cancel THEN
                    PUT UNFORMATTED tt-nota-fiscal.msg-rejeicao c-separador.

                IF tt-param.tg-lei-informatica THEN DO:
                    PUT UNFORMATTED tt-nota-fiscal.portaria             c-separador
                                    tt-nota-fiscal.desc-mctic           c-separador
                                    tt-nota-fiscal.ind-item-fat         c-separador
                                    tt-nota-fiscal.classificacao        c-separador
                                    tt-nota-fiscal.dt-ini               c-separador
                                    tt-nota-fiscal.dt-fim               c-separador
                                    tt-nota-fiscal.calc-ext-conv1       c-separador
                                    tt-nota-fiscal.calc-ext-conv2a      c-separador
                                    tt-nota-fiscal.calc-ext-conv2b      c-separador
                                    tt-nota-fiscal.calc-ext-fndct       c-separador
                                    tt-nota-fiscal.calc-externo         c-separador
                                    tt-nota-fiscal.calc-interno         c-separador
                                    tt-nota-fiscal.calc-tot             c-separador
                                    tt-nota-fiscal.calc-adic            c-separador
                                    tt-nota-fiscal.calc-cred-prod-hab   c-separador
                                    tt-nota-fiscal.calc-cred-bem-desenv c-separador
                                    tt-nota-fiscal.calc-limit-cred      c-separador.     
                END.
                
                PUT SKIP.
                
                IF tt-param.imprime-conta THEN DO:
                    FIND nota-fiscal
                        WHERE nota-fiscal.cod-estabel = tt-nota-fiscal.cod-estabel
                        AND   nota-fiscal.serie       = tt-nota-fiscal.serie
                        AND   nota-fiscal.nr-nota-fis = tt-nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.

                    RUN pi-imprime-grade-contabil.
                END.
            END.
        END.

        IF tt-param.excel = NO THEN DO:
            PUT SKIP (1) "Total "
                de-tot-merc-liq AT 81 " "
                de-tot-merc-liq-me   " "
                de-tot-frete-it      " "
                de-tot-icms-it       " "
                de-tot-ipi-it        " "
                de-vl-bsubs-it       " "                   
                de-vl-icmsub-it      " "                                   
                de-tot-despes-it     " "
                de-tot-pis           " "
                de-tot-finsocial     " "
                de-tot-tot-item      " " 
                de-tot-vl-dci        " "
                de-tot-bc-uf-dest    " "
                de-tot-icms-fcp      " "
                de-tot-icms-uf-dest  " "
                de-tot-icms-uf-remet " ".
            PUT SKIP.
        END.

        PUT SKIP (2) "Resumo Por NCM" SKIP(2)
            "Class Fiscal         Valor" SKIP
            "------------ -------------" SKIP.

        ASSIGN de-tot-tot-item = 0.

        FOR EACH tt-class BY tt-class.ncm:
            PUT tt-class.ncm
                c-separador
                tt-class.valor FORMAT ">>>>,>>>,>>9.99" SKIP.

            ASSIGN de-tot-tot-item = de-tot-tot-item + tt-class.valor.
        END.

        IF tt-param.excel = YES THEN DO:
            PUT "---------- ---------------" SKIP.
            PUT "Total      " de-tot-tot-item FORMAT ">>>>,>>>,>>9.99".
        END.
    END.
    ELSE DO:
        ASSIGN de-vl-merc-liq      = 0
               de-vl-merc-liq-me   = 0
               de-vl-frete-it      = 0
               de-vl-icms-it       = 0
               de-vl-bicms-it      = 0
               de-vl-ipi-it        = 0
               de-vl-despes-it     = 0
               de-vl-pis           = 0
               de-vl-finsocial     = 0
               de-vl-tot-item      = 0
               de-vl-icmsub-it     = 0
               de-vl-bsubs-it      = 0
               de-vl-dci           = 0
               de-vl-bc-uf-dest    = 0
               de-aliq-uf-dest     = 0
               de-aliq-inter       = 0
               de-perc-icms-fcp    = 0
               de-vl-icms-fcp      = 0
               de-vl-icms-uf-dest  = 0
               de-vl-icms-uf-remet = 0.

        IF tt-param.excel = YES THEN DO:

            ASSIGN c-separador = ";".

            IF tt-param.segmento = YES THEN
                IF  tt-param.imprime-cancel THEN
                    IF  tt-param.tg-lista-chave THEN
                        PUT "Est;Ser;Nr.Nota;Operacao;Fatura;Dt.Emissao ;Canal ;Pedido ;Cliente;Nome        ;CGC                ;Cidade                   ;UF     ;Pais;Embar;Natur.  ;ST;ICMS%  ;IPI% ;Dep;GE;Item    ;Descricao do Item                   ;Cl. Fiscal;Unidade Neg;Familia Comercial;Descricao;Familia Materiais;Descricao;Quantidade   ;Preªo Unitˇrio ;Vlr.Merc.(Real);Vlr.Merc.(Dolar)         ;Frete        ;Vlr ICMS  ;Base Calculo ICMS       ;Vlr.IPI ;Vl.Base S.Trib.    ;ICMS Sub.Tr.        ;Despesas       ;Vlr PIS    ;vlr COFINS       ;Vl.Tot.NF;Vl DCI;Usuario    ;CF ; Ins Estad. ;Trib.Cliente;DCR Item;Mensagem;Nota Origem Devolucao;Serie;Data Origem;Natureza; Situaá∆o;Observacao                                                                  ;Tipo do Item;Segmento;Des.Segmento;Vlr Imposto ISS;Aliquota.ISS;Inf.Impst.Retido;Dt.Saida;Dt.Entrega Efetiva;Cod.Transp;Nome transportadora;CIF;Vl BC UF Dest;Aliq UF Dest;Aliq Inter;% ICMS FCP;Vl ICMS FCP;Vl ICMS UF Dest;Vl ICMS UF Remet;Contrib.ICMS;Sit.Documento;Dt.Cancel;DANFE;Aliq FCP;Vl FCP;Conta Contabil;NR Seq Fat;Suframa;Peso Bru Unit;Peso Liq Unit; Docto Referenciado; Cod Repres; Desc Repres; Motivo CC".
                    ELSE
                        PUT "Est;Ser;Nr.Nota;Operacao;Fatura;Dt.Emissao ;Canal ;Pedido ;Cliente;Nome        ;CGC                ;Cidade                   ;UF     ;Pais;Embar;Natur.  ;ST;ICMS%  ;IPI% ;Dep;GE;Item    ;Descricao do Item                   ;Cl. Fiscal;Unidade Neg;Familia Comercial;Descricao;Familia Materiais;Descricao;Quantidade   ;Preªo Unitˇrio ;Vlr.Merc.(Real);Vlr.Merc.(Dolar)         ;Frete        ;Vlr ICMS  ;Base Calculo ICMS       ;Vlr.IPI ;Vl.Base S.Trib.    ;ICMS Sub.Tr.        ;Despesas       ;Vlr PIS    ;vlr COFINS       ;Vl.Tot.NF;Vl DCI;Usuario    ;CF ; Ins Estad. ;Trib.Cliente;DCR Item;Mensagem;Nota Origem Devolucao;Serie;Data Origem;Natureza; Situaá∆o;Observacao                                                                  ;Tipo do Item;Segmento;Des.Segmento;Vlr Imposto ISS;Aliquota.ISS;Inf.Impst.Retido;Dt.Saida;Dt.Entrega Efetiva;Cod.Transp;Nome transportadora;CIF;Vl BC UF Dest;Aliq UF Dest;Aliq Inter;% ICMS FCP;Vl ICMS FCP;Vl ICMS UF Dest;Vl ICMS UF Remet;Contrib.ICMS;Sit.Documento;Dt.Cancel;Aliq FCP;Vl FCP;Conta Contabil;NR Seq Fat;Suframa;Peso Bru Unit;Peso Liq Unit; Docto Referenciado; Cod Repres; Desc Repres; Motivo CC".
                ELSE
                    IF  tt-param.tg-lista-chave THEN
                        PUT "Est;Ser;Nr.Nota;Operacao;Fatura;Dt.Emissao ;Canal ;Pedido ;Cliente;Nome        ;CGC                ;Cidade                   ;UF     ;Pais;Embar;Natur.  ;ST;ICMS%  ;IPI% ;Dep;GE;Item    ;Descricao do Item                   ;Cl. Fiscal;Unidade Neg;Familia Comercial;Descricao;Familia Materiais;Descricao;Quantidade   ;Preªo Unitˇrio ;Vlr.Merc.(Real);Vlr.Merc.(Dolar)         ;Frete        ;Vlr ICMS  ;Base Calculo ICMS       ;Vlr.IPI ;Vl.Base S.Trib.    ;ICMS Sub.Tr.        ;Despesas       ;Vlr PIS    ;vlr COFINS       ;Vl.Tot.NF;Vl DCI;Usuario    ;CF ; Ins Estad. ;Trib.Cliente;DCR Item;Mensagem;Nota Origem Devolucao;Serie;Data Origem;Natureza; Situaá∆o;Observacao                                                                  ;Tipo do Item;Segmento;Des.Segmento;Vlr Imposto ISS;Aliquota.ISS;Inf.Impst.Retido;Dt.Saida;Dt.Entrega Efetiva;Cod.Transp;Nome transportadora;CIF;Vl BC UF Dest;Aliq UF Dest;Aliq Inter;% ICMS FCP;Vl ICMS FCP;Vl ICMS UF Dest;Vl ICMS UF Remet;Contrib.ICMS;Sit.Documento;DANFE;Aliq FCP;Vl FCP;Conta Contabil;NR Seq Fat;Suframa;Peso Bru Unit;Peso Liq Unit; Docto Referenciado; Cod Repres; Desc Repres; Motivo CC".
                    ELSE
                        PUT "Est;Ser;Nr.Nota;Operacao;Fatura;Dt.Emissao ;Canal ;Pedido ;Cliente;Nome        ;CGC                ;Cidade                   ;UF     ;Pais;Embar;Natur.  ;ST;ICMS%  ;IPI% ;Dep;GE;Item    ;Descricao do Item                   ;Cl. Fiscal;Unidade Neg;Familia Comercial;Descricao;Familia Materiais;Descricao;Quantidade   ;Preªo Unitˇrio ;Vlr.Merc.(Real);Vlr.Merc.(Dolar)         ;Frete        ;Vlr ICMS  ;Base Calculo ICMS       ;Vlr.IPI ;Vl.Base S.Trib.    ;ICMS Sub.Tr.        ;Despesas       ;Vlr PIS    ;vlr COFINS       ;Vl.Tot.NF;Vl DCI;Usuario    ;CF ; Ins Estad. ;Trib.Cliente;DCR Item;Mensagem;Nota Origem Devolucao;Serie;Data Origem;Natureza; Situaá∆o;Observacao                                                                  ;Tipo do Item;Segmento;Des.Segmento;Vlr Imposto ISS;Aliquota.ISS;Inf.Impst.Retido;Dt.Saida;Dt.Entrega Efetiva;Cod.Transp;Nome transportadora;CIF;Vl BC UF Dest;Aliq UF Dest;Aliq Inter;% ICMS FCP;Vl ICMS FCP;Vl ICMS UF Dest;Vl ICMS UF Remet;Contrib.ICMS;Sit.Documento;Aliq FCP;Vl FCP;Conta Contabil;NR Seq Fat;Suframa;Peso Bru Unit;Peso Liq Unit; Docto Referenciado; Cod Repres; Desc Repres; Motivo CC".
            ELSE
                IF  tt-param.imprime-cancel THEN
                    IF  tt-param.tg-lista-chave THEN
                        PUT "Est;Ser;Nr.Nota;Operacao;Fatura;Dt.Emissao ;Canal ;Pedido ;Cliente;Nome        ;CGC                ;Cidade                   ;UF     ;Pais;Embar;Natur.  ;ST;ICMS%  ;IPI% ;Dep;GE;Item    ;Descricao do Item                   ;Cl. Fiscal;Unidade Neg;Familia Comercial;Descricao;Familia Materiais;Descricao;Quantidade   ;Preªo Unitˇrio ;Vlr.Merc.(Real);Vlr.Merc.(Dolar)         ;Frete        ;Vlr ICMS  ;Base Calculo ICMS       ;Vlr.IPI ;Vl.Base S.Trib.    ;ICMS Sub.Tr.        ;Despesas       ;Vlr PIS    ;vlr COFINS       ;Vl.Tot.NF;Vl DCI;Usuario    ;CF ; Ins Estad. ;Trib.Cliente;DCR Item;Mensagem;Nota Origem Devolucao;Serie;Data Origem;Natureza; Situaá∆o;Observacao                                                                  ;Tipo do ITEM;Vlr Imposto ISS;Aliquota.ISS;Inf.Impst.Retido;Dt.Saida;Dt.Entrega Efetiva;Cod.Transp;Nome transportadora;CIF;Vl BC UF Dest;Aliq UF Dest;Aliq Inter;% ICMS FCP;Vl ICMS FCP;Vl ICMS UF Dest;Vl ICMS UF Remet;Contrib.ICMS;Sit.Documento;Dt.Cancel;DANFE;Aliq FCP;Vl FCP;Conta Contabil;NR Seq Fat;Suframa;Peso Bru Unit;Peso Liq Unit; Docto Referenciado; Cod Repres; Desc Repres; Motivo CC".
                    ELSE
                        PUT "Est;Ser;Nr.Nota;Operacao;Fatura;Dt.Emissao ;Canal ;Pedido ;Cliente;Nome        ;CGC                ;Cidade                   ;UF     ;Pais;Embar;Natur.  ;ST;ICMS%  ;IPI% ;Dep;GE;Item    ;Descricao do Item                   ;Cl. Fiscal;Unidade Neg;Familia Comercial;Descricao;Familia Materiais;Descricao;Quantidade   ;Preªo Unitˇrio ;Vlr.Merc.(Real);Vlr.Merc.(Dolar)         ;Frete        ;Vlr ICMS  ;Base Calculo ICMS       ;Vlr.IPI ;Vl.Base S.Trib.    ;ICMS Sub.Tr.        ;Despesas       ;Vlr PIS    ;vlr COFINS       ;Vl.Tot.NF;Vl DCI;Usuario    ;CF ; Ins Estad. ;Trib.Cliente;DCR Item;Mensagem;Nota Origem Devolucao;Serie;Data Origem;Natureza; Situaá∆o;Observacao                                                                  ;Tipo do ITEM;Vlr Imposto ISS;Aliquota.ISS;Inf.Impst.Retido;Dt.Saida;Dt.Entrega Efetiva;Cod.Transp;Nome transportadora;CIF;Vl BC UF Dest;Aliq UF Dest;Aliq Inter;% ICMS FCP;Vl ICMS FCP;Vl ICMS UF Dest;Vl ICMS UF Remet;Contrib.ICMS;Sit.Documento;Dt.Cancel;Aliq FCP;Vl FCP;Conta Contabil;NR Seq Fat;Suframa;Peso Bru Unit;Peso Liq Unit; Docto Referenciado; Cod Repres; Desc Repres; Motivo CC".
                ELSE
                    IF  tt-param.tg-lista-chave THEN
                        PUT "Est;Ser;Nr.Nota;Operacao;Fatura;Dt.Emissao ;Canal ;Pedido ;Cliente;Nome        ;CGC                ;Cidade                   ;UF     ;Pais;Embar;Natur.  ;ST;ICMS%  ;IPI% ;Dep;GE;Item    ;Descricao do Item                   ;Cl. Fiscal;Unidade Neg;Familia Comercial;Descricao;Familia Materiais;Descricao;Quantidade   ;Preªo Unitˇrio ;Vlr.Merc.(Real);Vlr.Merc.(Dolar)         ;Frete        ;Vlr ICMS  ;Base Calculo ICMS       ;Vlr.IPI ;Vl.Base S.Trib.    ;ICMS Sub.Tr.        ;Despesas       ;Vlr PIS    ;vlr COFINS       ;Vl.Tot.NF;Vl DCI;Usuario    ;CF ; Ins Estad. ;Trib.Cliente;DCR Item;Mensagem;Nota Origem Devolucao;Serie;Data Origem;Natureza; Situaá∆o;Observacao                                                                  ;Tipo do ITEM;Vlr Imposto ISS;Aliquota.ISS;Inf.Impst.Retido;Dt.Saida;Dt.Entrega Efetiva;Cod.Transp;Nome transportadora;CIF;Vl BC UF Dest;Aliq UF Dest;Aliq Inter;% ICMS FCP;Vl ICMS FCP;Vl ICMS UF Dest;Vl ICMS UF Remet;Contrib.ICMS;Sit.Documento;DANFE;Aliq FCP;Vl FCP;Conta Contabil;NR Seq Fat;Suframa;Peso Bru Unit;Peso Liq Unit; Docto Referenciado; Cod Repres; Desc Repres; Motivo CC".
                    ELSE
                        PUT "Est;Ser;Nr.Nota;Operacao;Fatura;Dt.Emissao ;Canal ;Pedido ;Cliente;Nome        ;CGC                ;Cidade                   ;UF     ;Pais;Embar;Natur.  ;ST;ICMS%  ;IPI% ;Dep;GE;Item    ;Descricao do Item                   ;Cl. Fiscal;Unidade Neg;Familia Comercial;Descricao;Familia Materiais;Descricao;Quantidade   ;Preªo Unitˇrio ;Vlr.Merc.(Real);Vlr.Merc.(Dolar)         ;Frete        ;Vlr ICMS  ;Base Calculo ICMS       ;Vlr.IPI ;Vl.Base S.Trib.    ;ICMS Sub.Tr.        ;Despesas       ;Vlr PIS    ;vlr COFINS       ;Vl.Tot.NF;Vl DCI;Usuario    ;CF ; Ins Estad. ;Trib.Cliente;DCR Item;Mensagem;Nota Origem Devolucao;Serie;Data Origem;Natureza; Situaá∆o;Observacao                                                                  ;Tipo do ITEM;Vlr Imposto ISS;Aliquota.ISS;Inf.Impst.Retido;Dt.Saida;Dt.Entrega Efetiva;Cod.Transp;Nome transportadora;CIF;Vl BC UF Dest;Aliq UF Dest;Aliq Inter;% ICMS FCP;Vl ICMS FCP;Vl ICMS UF Dest;Vl ICMS UF Remet;Contrib.ICMS;Sit.Documento;Aliq FCP;Vl FCP;Conta Contabil;NR Seq Fat;Suframa;Peso Bru Unit;Peso Liq Unit; Docto Referenciado; Cod Repres; Desc Repres; Motivo CC".
        
            IF tt-param.tg-lei-informatica THEN
                PUT ";Portaria;Desc Item MCTIC;Item Fat;Classif Atual;Valid Ini;Valid Fim;Ext Conv1;Ext Conv2a;Ext Conv2b;Ext FNDCT;%Externo;%Interno;Tot Contra Partida;Calc %Adic P&D;Calc Cred Prod Habilit;Calc Cred Bem Desenv;Limite Cred Informat".

            PUT SKIP.
                        
        END.
        ELSE DO:
            ASSIGN c-separador = " ".

            IF  tt-param.segmento = YES THEN
                IF  tt-param.imprime-cancel THEN
                    IF  tt-param.tg-lista-chave THEN
                        PUT "Est Ser   Nr.Nota Operacao Fatura   Dt.Emissao Canal Pedido           Cliente  Nome          CGC                  Cidade                     UF      Pais                  Embar   Natur.   ST     ICMS%    IPI%  Dep GE Item Descricao do Item             Cl. Fiscal Unidade Neg  Familia Comercial Descricao Familia Materiais Descricao       Quantidade     Preªo Unitˇrio   Vlr.Merc.(Real)  Vlr.Merc.(Dolar)           Frete          Vlr ICMS           Vlr.IPI   Vl.Base S.Trib.      ICMS Sub.Tr.          Despesas         Vlr PIS      vlr COFINS         Vl.Tot.NF   Vl DCI    Usuario      CF   Ins Estad.          T DCR Item            M Nota Origem Devolucao  Serie Data Origem     Natureza  Situaªío Observacao Tipo do Item Conta Segmento Descriá∆o.Segmento                                  Vlr.Imposto ISS  Aliquota.Iss  Inf.Impst.Retido Dt.Saida ;Dt.Entrega Efetiva Cod.Transp Nome transportadora CIF Vl BC UF Dest Aliq UF Dest Aliq Inter % ICMS FCP Vl ICMS FCP Vl ICMS UF Dest Vl ICMS UF Remet Contrib.ICMS Sit.Documento Dt.Cancel DANFE Aliq.FCP Vl.FCP Conta Contabil NR Seq Fat Suframa Peso Bru Unit Peso Liq Unit Docto Referenciado Cod Repres Desc Repres; Motivo CC" SKIP.
                    ELSE
                        PUT "Est Ser   Nr.Nota Operacao Fatura   Dt.Emissao Canal Pedido           Cliente  Nome          CGC                  Cidade                     UF      Pais                  Embar   Natur.   ST     ICMS%    IPI%  Dep GE Item Descricao do Item             Cl. Fiscal Unidade Neg  Familia Comercial Descricao Familia Materiais Descricao       Quantidade     Preªo Unitˇrio   Vlr.Merc.(Real)  Vlr.Merc.(Dolar)           Frete          Vlr ICMS           Vlr.IPI   Vl.Base S.Trib.      ICMS Sub.Tr.          Despesas         Vlr PIS      vlr COFINS         Vl.Tot.NF   Vl DCI    Usuario      CF   Ins Estad.          T DCR Item            M Nota Origem Devolucao  Serie Data Origem     Natureza  Situaªío Observacao Tipo do Item Conta Segmento Descriá∆o.Segmento                                  Vlr.Imposto ISS  Aliquota.Iss  Inf.Impst.Retido Dt.Saida ;Dt.Entrega Efetiva Cod.Transp Nome transportadora CIF Vl BC UF Dest Aliq UF Dest Aliq Inter % ICMS FCP Vl ICMS FCP Vl ICMS UF Dest Vl ICMS UF Remet Contrib.ICMS Sit.Documento Dt.Cancel Aliq.FCP Vl.FCP Conta Contabil NR Seq Fat Suframa Peso Bru Unit Peso Liq Unit Docto Referenciado Cod Repres Desc Repres; Motivo CC" SKIP.
                ELSE
                    IF  tt-param.tg-lista-chave THEN
                        PUT "Est Ser   Nr.Nota Operacao Fatura   Dt.Emissao Canal Pedido           Cliente  Nome          CGC                  Cidade                     UF      Pais                  Embar   Natur.   ST     ICMS%    IPI%  Dep GE Item Descricao do Item             Cl. Fiscal Unidade Neg  Familia Comercial Descricao Familia Materiais Descricao       Quantidade     Preªo Unitˇrio   Vlr.Merc.(Real)  Vlr.Merc.(Dolar)           Frete          Vlr ICMS           Vlr.IPI   Vl.Base S.Trib.      ICMS Sub.Tr.          Despesas         Vlr PIS      vlr COFINS         Vl.Tot.NF   Vl DCI    Usuario      CF   Ins Estad.          T DCR Item            M Nota Origem Devolucao  Serie Data Origem     Natureza  Situaªío Observacao Tipo do Item Conta Segmento Descriá∆o.Segmento                                  Vlr.Imposto ISS  Aliquota.Iss  Inf.Impst.Retido Dt.Saida ;Dt.Entrega Efetiva Cod.Transp Nome transportadora CIF Vl BC UF Dest Aliq UF Dest Aliq Inter % ICMS FCP Vl ICMS FCP Vl ICMS UF Dest Vl ICMS UF Remet Contrib.ICMS Sit.Documento DANFE Aliq.FCP Vl.FCP Conta Contabil NR Seq Fat Suframa Peso Bru Unit Peso Liq Unit Docto Referenciado Cod Repres Desc Repres; Motivo CC" SKIP.
                    ELSE
                        PUT "Est Ser   Nr.Nota Operacao Fatura   Dt.Emissao Canal Pedido           Cliente  Nome          CGC                  Cidade                     UF      Pais                  Embar   Natur.   ST     ICMS%    IPI%  Dep GE Item Descricao do Item             Cl. Fiscal Unidade Neg  Familia Comercial Descricao Familia Materiais Descricao       Quantidade     Preªo Unitˇrio   Vlr.Merc.(Real)  Vlr.Merc.(Dolar)           Frete          Vlr ICMS           Vlr.IPI   Vl.Base S.Trib.      ICMS Sub.Tr.          Despesas         Vlr PIS      vlr COFINS         Vl.Tot.NF   Vl DCI    Usuario      CF   Ins Estad.          T DCR Item            M Nota Origem Devolucao  Serie Data Origem     Natureza  Situaªío Observacao Tipo do Item Conta Segmento Descriá∆o.Segmento                                  Vlr.Imposto ISS  Aliquota.Iss  Inf.Impst.Retido Dt.Saida ;Dt.Entrega Efetiva Cod.Transp Nome transportadora CIF Vl BC UF Dest Aliq UF Dest Aliq Inter % ICMS FCP Vl ICMS FCP Vl ICMS UF Dest Vl ICMS UF Remet Contrib.ICMS Sit.Documento Aliq.FCP Vl.FCP Conta Contabil NR Seq Fat Suframa Peso Bru Unit Peso Liq Unit Docto Referenciado Cod Repres Desc Repres; Motivo CC" SKIP.
            ELSE
                IF  tt-param.imprime-cancel THEN
                    IF  tt-param.tg-lista-chave THEN
                        PUT "Est Ser   Nr.Nota Operacao Fatura   Dt.Emissao Canal Pedido           Cliente  Nome          CGC                  Cidade                     UF      Pais                  Embar   Natur.   ST     ICMS%    IPI%  Dep GE Item Descricao do Item             Cl. Fiscal Unidade Neg  Familia Comercial Descricao Familia Materiais Descricao       Quantidade     Preªo Unitˇrio   Vlr.Merc.(Real)  Vlr.Merc.(Dolar)           Frete          Vlr ICMS           Vlr.IPI   Vl.Base S.Trib.      ICMS Sub.Tr.          Despesas         Vlr PIS      vlr COFINS         Vl.Tot.NF   Vl DCI    Usuario      CF   Ins Estad.          T DCR Item            M Nota Origem Devolucao  Serie Data Origem     Natureza  Situaªío Observacao Tipo do Item Conta Vlr.Imposto ISS  Aliquota.Iss  Inf.Impst.Retido Dt.Saida  Cod.Transp Nome transportadora CIF Vl BC UF Dest Aliq UF Dest Aliq Inter % ICMS FCP Vl ICMS FCP Vl ICMS UF Dest Vl ICMS UF Remet Contrib.ICMS Sit.Documento Dt.Cancel DANFE Aliq.FCP Vl.FCP Conta Contabil NR Seq Fat Suframa Peso Bru Unit Peso Liq Unit Docto Referenciado Cod Repres Desc Repres; Motivo CC" SKIP.
                    ELSE
                        PUT "Est Ser   Nr.Nota Operacao Fatura   Dt.Emissao Canal Pedido           Cliente  Nome          CGC                  Cidade                     UF      Pais                  Embar   Natur.   ST     ICMS%    IPI%  Dep GE Item Descricao do Item             Cl. Fiscal Unidade Neg  Familia Comercial Descricao Familia Materiais Descricao       Quantidade     Preªo Unitˇrio   Vlr.Merc.(Real)  Vlr.Merc.(Dolar)           Frete          Vlr ICMS           Vlr.IPI   Vl.Base S.Trib.      ICMS Sub.Tr.          Despesas         Vlr PIS      vlr COFINS         Vl.Tot.NF   Vl DCI    Usuario      CF   Ins Estad.          T DCR Item            M Nota Origem Devolucao  Serie Data Origem     Natureza  Situaªío Observacao Tipo do Item Conta Vlr.Imposto ISS  Aliquota.Iss  Inf.Impst.Retido Dt.Saida  Cod.Transp Nome transportadora CIF Vl BC UF Dest Aliq UF Dest Aliq Inter % ICMS FCP Vl ICMS FCP Vl ICMS UF Dest Vl ICMS UF Remet Contrib.ICMS Sit.Documento Dt.Cancel Aliq.FCP Vl.FCP Conta Contabil NR Seq Fat Suframa Peso Bru Unit Peso Liq Unit Docto Referenciado Cod Repres Desc Repres; Motivo CC" SKIP.
                ELSE
                    IF  tt-param.tg-lista-chave THEN
                        PUT "Est Ser   Nr.Nota Operacao Fatura   Dt.Emissao Canal Pedido           Cliente  Nome          CGC                  Cidade                     UF      Pais                  Embar   Natur.   ST     ICMS%    IPI%  Dep GE Item Descricao do Item             Cl. Fiscal Unidade Neg  Familia Comercial Descricao Familia Materiais Descricao       Quantidade     Preªo Unitˇrio   Vlr.Merc.(Real)  Vlr.Merc.(Dolar)           Frete          Vlr ICMS           Vlr.IPI   Vl.Base S.Trib.      ICMS Sub.Tr.          Despesas         Vlr PIS      vlr COFINS         Vl.Tot.NF   Vl DCI    Usuario      CF   Ins Estad.          T DCR Item            M Nota Origem Devolucao  Serie Data Origem     Natureza  Situaªío Observacao Tipo do Item Conta Vlr.Imposto ISS  Aliquota.Iss  Inf.Impst.Retido Dt.Saida  Cod.Transp Nome transportadora CIF Vl BC UF Dest Aliq UF Dest Aliq Inter % ICMS FCP Vl ICMS FCP Vl ICMS UF Dest Vl ICMS UF Remet Contrib.ICMS Sit.Documento DANFE Aliq.FCP Vl.FCP Conta Contabil NR Seq Fat Suframa Peso Bru Unit Peso Liq Unit Docto Referenciado Cod Repres Desc Repres; Motivo CC" SKIP.
                    ELSE
                        PUT "Est Ser   Nr.Nota Operacao Fatura   Dt.Emissao Canal Pedido           Cliente  Nome          CGC                  Cidade                     UF      Pais                  Embar   Natur.   ST     ICMS%    IPI%  Dep GE Item Descricao do Item             Cl. Fiscal Unidade Neg  Familia Comercial Descricao Familia Materiais Descricao       Quantidade     Preªo Unitˇrio   Vlr.Merc.(Real)  Vlr.Merc.(Dolar)           Frete          Vlr ICMS           Vlr.IPI   Vl.Base S.Trib.      ICMS Sub.Tr.          Despesas         Vlr PIS      vlr COFINS         Vl.Tot.NF   Vl DCI    Usuario      CF   Ins Estad.          T DCR Item            M Nota Origem Devolucao  Serie Data Origem     Natureza  Situaªío Observacao Tipo do Item Conta Vlr.Imposto ISS  Aliquota.Iss  Inf.Impst.Retido Dt.Saida  Cod.Transp Nome transportadora CIF Vl BC UF Dest Aliq UF Dest Aliq Inter % ICMS FCP Vl ICMS FCP Vl ICMS UF Dest Vl ICMS UF Remet Contrib.ICMS Sit.Documento Aliq.FCP Vl.FCP Conta Contabil NR Seq Fat Suframa Peso Bru Unit Peso Liq Unit Docto Referenciado Cod Repres Desc Repres; Motivo CC" SKIP.
        END.

        FOR EACH tt-nota-fiscal
            WHERE tt-nota-fiscal.user-calc >= tt-param.ini-usuario
            AND   tt-nota-fiscal.user-calc <= tt-param.fim-usuario NO-LOCK,
            FIRST item NO-LOCK
            WHERE item.it-codigo = tt-nota-fiscal.it-codigo
            BREAK BY tt-nota-fiscal.cod-estabel
                  BY tt-nota-fiscal.serie
                  BY tt-nota-fiscal.nr-nota-fis:

            RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo " + tt-nota-fiscal.nr-nota-fis).

            FIND natur-oper
                WHERE natur-oper.nat-operacao = tt-nota-fiscal.nat-operacao NO-LOCK NO-ERROR.

            FIND emitente
                WHERE emitente.cod-emitente = tt-nota-fiscal.cod-emitente NO-LOCK NO-ERROR.

            FIND ped-fiscal
                WHERE ped-fiscal.cod-estabel = tt-nota-fiscal.cod-estabel
                AND   ped-fiscal.serie       = tt-nota-fiscal.serie
                AND   ped-fiscal.nr-nota-fis = tt-nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.

            PUT UNFORMATTED
                tt-nota-fiscal.cod-estabel  c-separador
                tt-nota-fiscal.serie   format "x(03)"     c-separador
                tt-nota-fiscal.nr-nota-fis format "x(15)" c-separador.

            IF natur-oper.tipo = 1 THEN
                PUT UNFORMATTED "Devolucao" c-separador.
            ELSE
                IF natur-oper.atual-estat = YES THEN
                    PUT UNFORMATTED "Normal" c-separador.
                ELSE
                    PUT UNFORMATTED "Outras" c-separador.

            PUT UNFORMATTED tt-nota-fiscal.nr-fatura FORMAT "x(15)" c-separador
                tt-nota-fiscal.dt-emis-nota c-separador
                tt-nota-fiscal.cod-canal-venda c-separador.

            IF AVAIL ped-fiscal THEN
                PUT UNFORMATTED ped-fiscal.nr-pedido c-separador.
            ELSE
                PUT UNFORMATTED tt-nota-fiscal.nr-pedcli c-separador.

            IF LENGTH(tt-nota-fiscal.nivel-trib) < 3 THEN DO:
                IF LENGTH(tt-nota-fiscal.nivel-trib) = 1  THEN
                    ASSIGN c-trib = "00". 
                ELSE
                    ASSIGN c-trib = "0".
            END.

            PUT UNFORMATTED tt-nota-fiscal.cod-emitente c-separador
                tt-nota-fiscal.nome-abrev   c-separador
                tt-nota-fiscal.cgc          c-separador
                tt-nota-fiscal.cidade       c-separador
                tt-nota-fiscal.estado       c-separador
                tt-nota-fiscal.pais         c-separador
                tt-nota-fiscal.nr-embarque  c-separador
                tt-nota-fiscal.nat-operacao c-separador
                string("'")c-trib + tt-nota-fiscal.nivel-trib FORMAT "x(03)"  c-separador
                tt-nota-fiscal.aliquota-icm c-separador
                tt-nota-fiscal.aliquota-ipi c-separador.

            ASSIGN de-vl-merc-liq      = de-vl-merc-liq      + tt-nota-fiscal.vl-merc-liq 
                   de-vl-merc-liq-me   = de-vl-merc-liq-me   + tt-nota-fiscal.vl-merc-liq-me     
                   de-vl-frete-it      = de-vl-frete-it      + tt-nota-fiscal.vl-frete-it        
                   de-vl-icms-it       = de-vl-icms-it       + tt-nota-fiscal.vl-icms-it         
                   de-vl-bicms-it      = de-vl-bicms-it      + tt-nota-fiscal.vl-bicms-it
                   de-vl-ipi-it        = de-vl-ipi-it        + tt-nota-fiscal.vl-ipi-it          
                   de-vl-despes-it     = de-vl-despes-it     + tt-nota-fiscal.vl-despes-it       
                   de-vl-pis           = de-vl-pis           + tt-nota-fiscal.vl-pis             
                   de-vl-finsocial     = de-vl-finsocial     + tt-nota-fiscal.vl-finsocial
                   de-vl-tot-item      = de-vl-tot-item      + tt-nota-fiscal.vl-tot-item
                   de-vl-icmsub-it     = de-vl-icmsub-it     + tt-nota-fiscal.vl-icmsub-it   
                   de-vl-bsubs-it      = de-vl-bsubs-it      + tt-nota-fiscal.vl-bsubs-it
                   de-vl-dci           = de-vl-dci           + tt-nota-fiscal.vl-dci
                   de-vl-bc-uf-dest    = de-vl-bc-uf-dest    + tt-nota-fiscal.d-vl-bc-uf-dest    
                   de-aliq-uf-dest     = tt-nota-fiscal.d-aliq-uf-dest     
                   de-aliq-inter       = tt-nota-fiscal.d-aliq-inter       
                   de-perc-icms-fcp    = tt-nota-fiscal.d-perc-icms-fcp    
                   de-vl-icms-fcp      = de-vl-icms-fcp      + tt-nota-fiscal.d-vl-icms-fcp      
                   de-vl-icms-uf-dest  = de-vl-icms-uf-dest  + tt-nota-fiscal.d-vl-icms-uf-dest  
                   de-vl-icms-uf-remet = de-vl-icms-uf-remet + tt-nota-fiscal.d-vl-icms-uf-remet.

            IF item.ind-imp-desc = 1 THEN /* Descriá∆o */
                ASSIGN c-desc-prod = item.desc-item.

            IF  item.ind-imp-desc = 2 OR        /* Descriá∆o + Narrativa */
                item.ind-imp-desc = 5 OR        /* Narrativa Item */
                item.ind-imp-desc = 6 OR        /* Uma Linha Narrativa */
                item.ind-imp-desc = 10 THEN DO: /* Descriá∆o + 24 Narrativa Item */

                IF item.ind-imp-desc = 2 OR  item.ind-imp-desc = 10 THEN
                    ASSIGN c-desc-prod = item.desc-item.
                ELSE
                    ASSIGN c-desc-prod = "".

                FIND narrativa of item NO-LOCK NO-ERROR.

                IF AVAILABLE narrativa THEN
                    ASSIGN c-desc-prod = c-desc-prod +
                                            IF item.ind-imp-desc = 6 THEN
                                                TRIM(ENTRY(1,SUBSTRING(narrativa.descricao,1,76),CHR(10)))
                                            ELSE IF item.ind-imp-desc = 10 THEN
                                                TRIM(ENTRY(1,SUBSTRING(narrativa.descricao,1,24),CHR(10)))
                                            ELSE narrativa.descricao.

                IF c-desc-prod = "" THEN
                    ASSIGN c-desc-prod = item.desc-item.
            END.

            IF  item.ind-imp-desc = 3 OR       /* Descriá∆o + Narrativa Item/Cliente */
                item.ind-imp-desc = 8 THEN DO: /* Descriá∆o + 24 Narrativa Item/Cliente */

                FIND item-cli
                    WHERE item-cli.nome-abrev = tt-nota-fiscal.nome-abrev
                    AND   item-cli.it-codigo  = tt-nota-fiscal.it-codigo NO-LOCK NO-ERROR.

                ASSIGN c-desc-prod = item.desc-item.

                IF AVAILABLE item-cli THEN
                    ASSIGN c-desc-prod = c-desc-prod +
                                         IF item.ind-imp-desc = 3 THEN
                                             item-cli.narrativa
                                         ELSE
                                             TRIM(ENTRY(1,SUBSTRING(item-cli.narrativa,1,24),CHR(10))).
            END.

            IF  item.ind-imp-desc = 4 OR         /* Descriá∆o + Narrativa Informada */
                item.ind-imp-desc = 7 OR         /* Narrativa Informada */
                item.ind-imp-desc = 9 THEN DO:   /* Descriá∆o + 24 Narrativa Informada */

                IF  item.ind-imp-desc = 4 OR  item.ind-imp-desc = 9 THEN
                    ASSIGN c-desc-prod = item.desc-item.
                ELSE
                    ASSIGN c-desc-prod = "".

                FIND nar-it-nota
                    WHERE nar-it-nota.cod-estabel  = tt-nota-fiscal.cod-estabel
                    AND   nar-it-nota.serie        = tt-nota-fiscal.serie
                    AND   nar-it-nota.nr-nota-fis  = tt-nota-fiscal.nr-nota-fis
                    AND   nar-it-nota.nr-sequencia = tt-nota-fiscal.nr-seq-fat
                    AND   nar-it-nota.it-codigo    = tt-nota-fiscal.it-codigo NO-LOCK NO-ERROR.

                IF AVAILABLE nar-it-nota THEN
                    ASSIGN c-desc-prod = c-desc-prod +
                                         IF item.ind-imp-desc = 9 THEN
                                             TRIM(ENTRY(1,SUBSTRING(nar-it-nota.narrativa,1,24),CHR(10)))
                                         ELSE
                                             nar-it-nota.narrativa.
            END.

            ASSIGN c-desc-prod = REPLACE(c-desc-prod,CHR(13),"")
                   c-desc-prod = TRIM(REPLACE(c-desc-prod,CHR(10),""))
                   c-desc-prod = TRIM(REPLACE(c-desc-prod,";"," ")).

            PUT UNFORMATTED tt-nota-fiscal.cod-depos c-separador
                item.ge-codigo                          c-separador
                tt-nota-fiscal.it-codigo FORMAT "x(08)" c-separador 
                c-desc-prod                             c-separador.

            PUT tt-nota-fiscal.class-fiscal c-separador.

            ASSIGN c-unid-nota = tt-nota-fiscal.cod-unid-neg.

            FIND familia
                WHERE familia.fm-codigo = item.fm-codigo NO-LOCK NO-ERROR.

            PUT UNFORMATTED c-unid-nota c-separador.

            FIND fam-comerc
                WHERE fam-comerc.fm-cod-com = item.fm-cod-com NO-LOCK NO-ERROR.

            PUT UNFORMATTED ITEM.fm-cod-com c-separador.

            IF AVAIL fam-comerc THEN
                PUT UNFORMATTED fam-comerc.descricao c-separador.
            ELSE
                PUT "" c-separador.

            PUT UNFORMATTED item.fm-codigo c-separador.

            IF AVAIL familia THEN
                PUT UNFORMATTED familia.descricao c-separador.
            ELSE
                PUT "" c-separador.

            PUT UNFORMATTED
                tt-nota-fiscal.qt-faturada       c-separador
                tt-nota-fiscal.vl-preori         c-separador
                tt-nota-fiscal.vl-merc-liq       c-separador
                tt-nota-fiscal.vl-merc-liq-me    c-separador
                tt-nota-fiscal.vl-frete-it       c-separador
                tt-nota-fiscal.vl-icms-it        c-separador
                tt-nota-fiscal.vl-bicms-it       c-separador
                tt-nota-fiscal.vl-ipi-it         c-separador
                tt-nota-fiscal.vl-bsubs-it       c-separador
                tt-nota-fiscal.vl-icmsub-it      c-separador
                tt-nota-fiscal.vl-despes-it      c-separador
                tt-nota-fiscal.vl-pis            c-separador
                tt-nota-fiscal.vl-finsocial      c-separador
                tt-nota-fiscal.vl-tot-item       c-separador
                tt-nota-fiscal.vl-dci            c-separador
                tt-nota-fiscal.user-calc         c-separador
                natur-oper.consum-final          c-separador
                emitente.ins-estadual            c-separador
                tt-nota-fiscal.cod-trib-cliente  c-separador
                tt-nota-fiscal.nr-dcr-item       c-separador
                tt-nota-fiscal.cod-mensagem      c-separador
                tt-nota-fiscal.nro-comp          c-separador
                tt-nota-fiscal.serie-comp        c-separador
                tt-nota-fiscal.data-comp         c-separador
                tt-nota-fiscal.nat-comp          c-separador
                tt-nota-fiscal.sit-nf-eletronica c-separador.

            IF AVAIL ped-fiscal THEN
                PUT UNFORMATTED ped-fiscal.observacao[1] c-separador.
            ELSE
                PUT "        " c-separador.

            FIND item-uni-estab
                WHERE item-uni-estab.cod-estabel = tt-nota-fiscal.cod-estabel
                AND   item-uni-estab.it-codigo   = tt-nota-fiscal.it-codigo NO-LOCK NO-ERROR.

            IF AVAIL item-uni-estab THEN DO:
                CASE SUBSTRING(item-uni-estab.char-1, 133, 1):
                    WHEN "0" THEN PUT "0 - Mercadoria para Revenda".
                    WHEN "1" THEN PUT "1 - Materia-prima".
                    WHEN "2" THEN PUT "2 - Embalagem".
                    WHEN "3" THEN PUT "3 - Produto em Processo".
                    WHEN "4" THEN PUT "4 - Produto Acabado".
                    WHEN "5" THEN PUT "5 - Subproduto".
                    WHEN "6" THEN PUT "6 - Produto Intermediario".
                    WHEN "7" THEN PUT "7 - Material de Uso e Consumo".
                    WHEN "8" THEN PUT "8 - Ativo Imobilizado".
                    WHEN "9" THEN PUT "9 - Servicos".
                    WHEN "a" THEN PUT "10 - Outros Insumos".
                    WHEN "b" THEN PUT "99 - Outras".
                    OTHERWISE PUT "N∆o Informado".
                END.
            END.

            PUT c-separador.

            IF tt-param.segmento = YES THEN DO:

                PUT UNFORMATTED SUBSTRING(item.fm-cod-com,1,4) c-separador.

                FIND fam-com-item NO-LOCK
                    WHERE fam-com-item.fm-cod-com = SUBSTRING(item.fm-cod-com,1,4) NO-ERROR.

                IF AVAIL fam-com-item THEN
                    PUT UNFORMATTED fam-com-item.descricao c-separador.
                ELSE
                    PUT UNFORMATTED c-separador.
            END.

            PUT UNFORMATTED tt-nota-fiscal.imposto c-separador.
            PUT UNFORMATTED tt-nota-fiscal.aliquota c-separador.

            IF SUBSTRING(natur-oper.char-2,123,1) = "1" THEN
                PUT UNFORMATTED "Sim" c-separador.
            ELSE
                PUT UNFORMATTED "N∆o" c-separador.

            PUT UNFORMATTED tt-nota-fiscal.dt-saida c-separador.

            PUT UNFORMATTED
                tt-nota-fiscal.dt-entr-cli c-separador
                tt-nota-fiscal.cod-transp  c-separador
                tt-nota-fiscal.nome-transp c-separador.

            IF tt-nota-fiscal.cif = YES THEN
                PUT "Sim" c-separador.
            ELSE
                PUT "Nao" c-separador.

            PUT UNFORMATTED tt-nota-fiscal.d-vl-bc-uf-dest c-separador
                tt-nota-fiscal.d-aliq-uf-dest     c-separador
                tt-nota-fiscal.d-aliq-inter       c-separador
                tt-nota-fiscal.d-perc-icms-fcp    c-separador
                tt-nota-fiscal.d-vl-icms-fcp      c-separador
                tt-nota-fiscal.d-vl-icms-uf-dest  c-separador
                tt-nota-fiscal.d-vl-icms-uf-remet c-separador
                tt-nota-fiscal.contrib-icms       c-separador
                tt-nota-fiscal.situacao           c-separador.
            
            IF  tt-param.imprime-cancel THEN
                IF  tt-param.tg-lista-chave THEN
                    PUT UNFORMATTED tt-nota-fiscal.dt-cancel c-separador  "'" tt-nota-fiscal.cod-chave-aces-nf-eletro "'" c-separador.
                ELSE
                    PUT UNFORMATTED tt-nota-fiscal.dt-cancel c-separador.
            ELSE
                IF  tt-param.tg-lista-chave THEN
                    PUT UNFORMATTED "'" tt-nota-fiscal.cod-chave-aces-nf-eletro "'" c-separador.

            PUT UNFORMATTED tt-nota-fiscal.aliqFcp c-separador tt-nota-fiscal.vl-FCP c-separador.

            ASSIGN c-ct-codigo = "".

            FOR EACH movto-estoq
                WHERE movto-estoq.cod-estabel  = tt-nota-fiscal.cod-estabel
                AND   movto-estoq.serie-docto  = tt-nota-fiscal.serie
                AND   movto-estoq.nro-docto    = tt-nota-fiscal.nr-nota-fis
                AND   movto-estoq.cod-emitente = tt-nota-fiscal.cod-emitente
                AND   movto-estoq.nat-operacao = tt-nota-fiscal.nat-operacao
                AND   movto-estoq.it-codigo    = tt-nota-fiscal.it-codigo NO-LOCK:

                ASSIGN de-valor-contabil = 0.

                FIND estabelec
                    WHERE estabelec.cod-estabel = movto-estoq.cod-estabel NO-LOCK NO-ERROR.

                FIND contabiliza
                    WHERE contabiliza.cod-estabel = movto-estoq.cod-estabel
                    AND   contabiliza.cod-depos   = movto-estoq.cod-depos
                    AND   contabiliza.ge-codigo   = item.ge-codigo  NO-LOCK NO-ERROR.

                ASSIGN de-valor-contabil =  movto-estoq.valor-mat-m[1] +
                                            movto-estoq.valor-mob-m[1] +
                                            movto-estoq.valor-ggf-m[1].

                IF c-ct-codigo = "" THEN
                    ASSIGN c-ct-codigo = c-ct-codigo + movto-estoq.ct-codigo + movto-estoq.sc-codigo.
                ELSE
                    ASSIGN c-ct-codigo = c-ct-codigo + ", " + movto-estoq.ct-codigo + movto-estoq.sc-codigo.

            END.

            PUT UNFORMATTED c-ct-codigo c-separador.
            PUT UNFORMATTED tt-nota-fiscal.nr-sequencia c-separador.

            FIND FIRST emitente NO-LOCK
                 WHERE emitente.cod-emitente = tt-nota-fiscal.cod-emitente NO-ERROR.

            PUT UNFORMATTED emitente.cod-suframa c-separador.

            PUT UNFORMATTED ITEM.peso-bruto c-separador.
            PUT UNFORMATTED ITEM.peso-liquido c-separador.

            PUT UNFORMATTED tt-nota-fiscal.docto-referenciado c-separador.

            PUT UNFORMATTED tt-nota-fiscal.cod-rep c-separador.
            PUT UNFORMATTED tt-nota-fiscal.desc-rep c-separador.

            PUT UNFORMATTED tt-nota-fiscal.desc-cc c-separador.

            IF tt-param.tg-lei-informatica THEN DO:
                PUT UNFORMATTED tt-nota-fiscal.portaria             c-separador
                                tt-nota-fiscal.desc-mctic           c-separador
                                tt-nota-fiscal.ind-item-fat         c-separador
                                tt-nota-fiscal.classificacao        c-separador
                                tt-nota-fiscal.dt-ini               c-separador
                                tt-nota-fiscal.dt-fim               c-separador
                                tt-nota-fiscal.calc-ext-conv1       c-separador
                                tt-nota-fiscal.calc-ext-conv2a      c-separador
                                tt-nota-fiscal.calc-ext-conv2b      c-separador
                                tt-nota-fiscal.calc-ext-fndct       c-separador
                                tt-nota-fiscal.calc-externo         c-separador
                                tt-nota-fiscal.calc-interno         c-separador
                                tt-nota-fiscal.calc-tot             c-separador
                                tt-nota-fiscal.calc-adic            c-separador
                                tt-nota-fiscal.calc-cred-prod-hab   c-separador
                                tt-nota-fiscal.calc-cred-bem-desenv c-separador
                                tt-nota-fiscal.calc-limit-cred      c-separador.
            END.

            PUT SKIP.

            IF LAST-OF(tt-nota-fiscal.nr-nota-fis) THEN DO:
                IF tt-param.imprime-conta THEN DO:

                    FIND nota-fiscal
                        WHERE nota-fiscal.cod-estabel = tt-nota-fiscal.cod-estabel
                        AND   nota-fiscal.serie       = tt-nota-fiscal.serie
                        AND   nota-fiscal.nr-nota-fis = tt-nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.

                    RUN pi-imprime-grade-contabil.
                END.
            END.
        END.

        IF tt-param.excel = YES THEN
            PUT SKIP "Total "
                de-vl-merc-liq    AT 273 " "
                de-vl-merc-liq-me        " "
                de-vl-frete-it           " "
                de-vl-icms-it            " "
                de-vl-bicms-it           " "
                de-vl-ipi-it             " "
                de-vl-bsubs-it           " "
                de-vl-icmsub-it          " "
                de-vl-despes-it          " "
                de-vl-pis                " "
                de-vl-finsocial          " "
                de-vl-tot-item           " "
                de-vl-dci                " "
                de-vl-bc-uf-dest         " "
                de-aliq-uf-dest          " "
                de-aliq-inter            " "
                de-perc-icms-fcp         " "
                de-vl-icms-fcp           " "
                de-vl-icms-uf-dest       " "
                de-vl-icms-uf-remet SKIP.
    END.

END PROCEDURE.

PROCEDURE pi-gera-grade-contabil-inter:

    ASSIGN l-indicador = NO.

    FOR EACH tt-ped-curva:
        DELETE tt-ped-curva.
    END.

    FIND FIRST para-fat NO-LOCK NO-ERROR.

    FIND FIRST fat-duplic
        WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel
        AND   fat-duplic.serie       = nota-fiscal.serie
        AND   fat-duplic.nr-fatura   = nota-fiscal.nr-fatura NO-LOCK NO-ERROR.

    RUN cdp/cd9500.p PERSISTENT SET h-cd9500.
END.

{esp/ftp/esftp041.i2}

PROCEDURE pi-busca-cotacao.
    DEFINE INPUT PARAMETER da-data AS DATE NO-UNDO. 

    FIND cotacao NO-LOCK
        WHERE cotacao.mo-codigo   = 1
        AND   cotacao.ano-periodo = STRING(YEAR(da-data),"9999") + STRING(MONTH(da-data),"99") NO-ERROR.

    IF AVAIL cotacao AND cotacao.cotacao[DAY(da-data)] <> 0 THEN
        ASSIGN de-cotacao = cotacao.cotacao[day(da-data)].
    ELSE
        ASSIGN de-cotacao = 1.
END.

PROCEDURE VerificaCartaoCredito:

    FIND cond-pagto
        WHERE cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-LOCK NO-ERROR.

    IF AVAIL cond-pagto THEN
        ASSIGN tt-nota-fiscal.cod-cond-pag = cond-pagto.descricao.

    FIND int-ped-venda
        WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
        AND   int-ped-venda.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.

    IF AVAIL int-ped-venda THEN DO:

        FIND emitente-cartao-cred NO-LOCK
            WHERE emitente-cartao-cred.cod-emitente = ped-venda.cod-emitente
            AND   emitente-cartao-cred.sequencia    = int-ped-venda.seq-cartao-cred NO-ERROR.
    
        IF AVAIL emitente-cartao-cred THEN DO:

            IF  emitente-cartao-cred.tipo-cartao = 02 AND  /*B2C*/
                emitente-cartao-cred.bandeira    = 07 THEN /*Hipercard*/
                ASSIGN tt-nota-fiscal.cod_admdra_cartao_cr = 'HIP'.

            IF  emitente-cartao-cred.tipo-cartao = 02 AND  /*B2C*/
                emitente-cartao-cred.bandeira    = 11 THEN /*Visa*/
                ASSIGN tt-nota-fiscal.cod_admdra_cartao_cr = 'VIS'.
        
            IF  emitente-cartao-cred.tipo-cartao = 02 AND  /*B2C*/
                emitente-cartao-cred.bandeira    = 10 THEN /*Mastercard*/
                ASSIGN tt-nota-fiscal.cod_admdra_cartao_cr = 'MCI'.    
          
            IF  emitente-cartao-cred.tipo-cartao = 02 AND  /*B2C*/
                emitente-cartao-cred.bandeira    = 06 THEN /*Diners*/
                ASSIGN tt-nota-fiscal.cod_admdra_cartao_cr = 'DIN'.
        
            IF  emitente-cartao-cred.tipo-cartao = 01 AND  /*B2B*/
                emitente-cartao-cred.bandeira    = 10 THEN /*Mastercard*/
                ASSIGN tt-nota-fiscal.cod_admdra_cartao_cr =  'MCI'.   /*Bandeira*/
                                
            IF  emitente-cartao-cred.tipo-cartao = 02 AND  /*B2C*/
                emitente-cartao-cred.bandeira    = 01 THEN /*American Express*/
                ASSIGN tt-nota-fiscal.cod_admdra_cartao_cr = 'AEX'.  /*Bandeira*/
        END.
    END.
END PROCEDURE.

PROCEDURE pi-cria-tt:
    CREATE tt-nota-fiscal.
    ASSIGN tt-nota-fiscal.cod-estabel        = docum-est.cod-estabel
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
           tt-nota-fiscal.nat-operacao       = item-doc-est.nat-of
           tt-nota-fiscal.nr-embarque        = 0
           tt-nota-fiscal.it-codigo          = item-doc-est.it-codigo
           tt-nota-fiscal.num-seq            = item-doc-est.sequencia
           tt-nota-fiscal.qt-faturada        = item-doc-est.quantidade
           tt-nota-fiscal.class-fiscal       = item-doc-est.class-fiscal
           tt-nota-fiscal.vl-preori          = item-doc-est.preco-unit[1]
           tt-nota-fiscal.vl-merc-liq        = item-doc-est.preco-total[1] - item-doc-est.desconto[1]
           tt-nota-fiscal.vl-merc-liq-me     = (item-doc-est.preco-total[1] - item-doc-est.desconto[1])  / IF AVAIL nota-fiscal THEN nota-fiscal.vl-taxa-exp ELSE 0
           tt-nota-fiscal.vl-icmsub-it       = item-doc-est.vl-subs[1] 
           tt-nota-fiscal.vl-bsubs-it        = item-doc-est.base-subs[1]
           tt-nota-fiscal.vl-frete-it        = 0
           tt-nota-fiscal.aliquota-icm       = item-doc-est.aliquota-icm
           tt-nota-fiscal.aliquota-ipi       = item-doc-est.aliquota-ipi
           tt-nota-fiscal.vl-icms-it         = IF item-doc-est.base-icm[1] > 0 THEN item-doc-est.valor-icm[1] ELSE 0
           tt-nota-fiscal.vl-ipi-it          = item-doc-est.valor-ipi[1]
           tt-nota-fiscal.vl-despes-it       = item-doc-est.despesas[1]
           tt-nota-fiscal.vl-tot-item        =  (item-doc-est.preco-total[1] - item-doc-est.desconto[1] + 
                                                 item-doc-est.valor-ipi[1] + item-doc-est.vl-subs[1])                 
           tt-nota-fiscal.nr-seq-fat         = 0
           tt-nota-fiscal.nr-dcr-item        = ""
           tt-nota-fiscal.vl-dci             =  (item-doc-est.preco-total[1] - item-doc-est.desconto[1] + 
                                                 item-doc-est.valor-ipi[1] + item-doc-est.vl-subs[1])  * 0.12
           tt-nota-fiscal.cod-unid-neg       = it-nota-fisc.cod-unid-neg
           tt-nota-fiscal.vl-bicms-it        = item-doc-est.base-icm[1]
           tt-nota-fiscal.imposto            = IF AVAIL it-nota-fisc THEN it-nota-fisc.vl-iss-it ELSE 0
           tt-nota-fiscal.aliquota           = IF AVAIL it-nota-fisc THEN it-nota-fisc.aliquota-iss ELSE 0
           tt-nota-fiscal.dt-saida           = IF AVAIL nota-fiscal THEN nota-fiscal.dt-saida ELSE ?
           tt-nota-fiscal.contrib-icms       = IF emitente.contrib-icms THEN "Sim" ELSE "N∆o"
           tt-nota-fiscal.dt-cancel          = IF AVAIL nota-fiscal THEN nota-fiscal.dt-cancel ELSE ?
           tt-nota-fiscal.nr-sequencia       = it-nota-fisc.nr-seq-fat.
END PROCEDURE.

PROCEDURE pi-docto-referado:
  IF tt-param.tipo = 1 THEN DO:
    FOR EACH nota-fisc-adc                                          
        WHERE nota-fisc-adc.cod-estab        = nota-fiscal.cod-estabel 
          AND nota-fisc-adc.cod-serie        = nota-fiscal.serie       
          AND nota-fisc-adc.cod-nota-fisc    = nota-fiscal.nr-nota-fis 
          AND nota-fisc-adc.cdn-emitente     = nota-fiscal.cod-emitente
          AND nota-fisc-adc.cod-natur-operac = nota-fiscal.nat-operacao NO-LOCK:

        IF tt-nota-fiscal.docto-referenciado = ""  THEN 
            ASSIGN tt-nota-fiscal.docto-referenciado = nota-fisc-adc.cod-docto-referado.
        ELSE
            ASSIGN tt-nota-fiscal.docto-referenciado =  tt-nota-fiscal.docto-referenciado + "|" + nota-fisc-adc.cod-docto-referado. 
        
    END.
  END.
  ELSE
      ASSIGN tt-nota-fiscal.docto-referenciado =  it-nota-fisc.nr-docum
             tt-nota-fiscal.cod-rep = nota-fiscal.cod-rep
             tt-nota-fiscal.desc-rep = nota-fiscal.no-ab-reppri.
END PROCEDURE.
/*
 CASE b-nota-fiscal.idi-sit-nf-eletro:
     WHEN 5 THEN assign c-msg = " Nota fiscal :" +  b-nota-fiscal.nr-nota-fis + "\ Serie: " + b-nota-fiscal.serie  + " referente pedido " +  b-nota-fiscal.nr-pedcli + "  , foi Rejeitada pelo SEFAZ. ".
     WHEN 7 THEN assign c-msg = " Nota fiscal :" +  b-nota-fiscal.nr-nota-fis + "\ Serie: " + b-nota-fiscal.serie  + " referente pedido " +  b-nota-fiscal.nr-pedcli + "  , foi Inutilizada.          ".
 END CASE. 

 FOR EACH ret-nf-eletro NO-LOCK
    WHERE ret-nf-eletro.cod-estabel = b-old-nota-fiscal.cod-estabel
      AND ret-nf-eletro.nr-nota-fis = b-old-nota-fiscal.nr-nota-fis
      AND ret-nf-eletro.cod-serie   = b-old-nota-fiscal.serie
      AND ret-nf-eletro.cod-livre-2 <> "":
 
     ASSIGN c-msg = c-msg + chr(13) + "Motivo Rejeiá∆o " + ret-nf-eletro.cod-msg + " - " +  ret-nf-eletro.cod-livre-2.
 END.*/
