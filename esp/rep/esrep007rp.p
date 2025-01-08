/***********************************************************************
**  Programa..: ESP\REP\ESREP007RP.P
**  Autor.....: Giovane Oliveira
**  Data......: FEVEREIRO/2006 - Desenvolvimento
**  Descricao.: NF de Entrada
**  VersÆo....: 001 07/02/2006
**                  Desenvolvimento Programa
compile \\tsclient\c\fontes\esp\rep\esrep007rp.p save into c:\temp\esp\rep.

************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESREP007 2.04.00.003}

/****************************  Definitions  ****************************/
{esp/rep/esrep007tt.i}

{utp/ut-glob.i}
{include/i-rpvar.i}

def var de-ali-icm like  it-nota-fisc.aliquota-icm no-undo.
def var c-aliquotas  as character format "x(06)" no-undo.
def var de-tot-ipi   as decimal  format ">>>>>>>>9.99"  init 0 no-undo.
def var de-tot-ii    as decimal  format ">>>>>>>>9.99" init 0 no-undo.
def var de-tot-des   as decimal  format ">>>>>>>>9.99" init 0 no-undo.
DEFINE VARIABLE i-nr-seq AS INTEGER     NO-UNDO.

def var nota-cre as dec NO-UNDO.
def var nota-deb-1 as dec  NO-UNDO.
def var c-emb        like embarque-imp.embarque  NO-UNDO.
/* def var v-aliq like docum-est.aliquota-icm init 0  NO-UNDO. */
def var c-nr-di like embarque-imp.declaracao-import NO-UNDO.

DEF VAR de-cotacao-entrada AS DEC  NO-UNDO.
DEF VAR de-cotacao-emb     AS DEC  NO-UNDO.
DEF VAR tx-adm             AS DEC  NO-UNDO.
DEF VAR de-cotacao-di      AS DEC  NO-UNDO.
DEF VAR vlr-fcp            AS DEC  NO-UNDO.

DEF VAR de-tot-icm  AS decimal  format ">>>>>>>>9.99"  init 0 no-undo.
DEF VAR de-tot-pis  AS decimal  format ">>>>>>>>9.99" init 0 no-undo.
DEF VAR de-tot-cof  AS decimal  format ">>>>>>>>9.99" init 0 no-undo.
DEF VAR de-tot-vl-icms-simples-nac AS decimal  format ">>>>>>>>9.99" init 0 no-undo.
DEF VAR de-tot-aliq-icms-simples-nac AS decimal  format ">>>>>>>>9.99" init 0 no-undo.
DEF VAR de-tot-base-icms-simples-nac AS decimal  format ">>>>>>>>9.99" init 0 no-undo.
DEF VAR de-tot-impostos as decimal FORMAT ">,>>>,>>>,>>9.99" no-undo.
DEF VAR de-impostos as decimal FORMAT ">,>>>,>>>,>>9.99" no-undo.
def var de-tot-frete as decimal FORMAT ">>,>>>,>>>,>>9.99" no-undo.
def var de-frete as decimal FORMAT ">>,>>>,>>>,>>9.99" no-undo.
def var de-seguro      as decimal FORMAT ">>,>>>,>>>,>>9.99" no-undo.
def var de-vl-mercadoria LIKE docum-est.valor-mercad no-undo.
def var de-vl-invoice LIKE invoice-emb-imp.vl-invoice no-undo.
def var de-nota-deb   LIKE item-doc-est.valor-ipi[1] no-undo.
def var de-tot-valor  like docum-est.tot-valor no-undo.
def var l-imp as logical no-undo.
DEFINE VARIABLE c-atendente AS CHARACTER   NO-UNDO.
DEF VAR v-aliq        LIKE docum-est.aliquota-icm init 0  NO-UNDO.
DEF VAR cod-motivacao LIKE int-docum-est.cod-msg-devolucao.
def var de-proporcao as decimal no-undo.

DEFINE VARIABLE de-tx-adm           AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-tx-adm2          AS DECIMAL NO-UNDO.
DEFINE VARIABLE v-log-listar        AS LOGICAL NO-UNDO.
DEFINE VARIABLE de-vl-bc-uf-dest    AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-aliq-uf-dest     AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-aliq-inter       AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-perc-icms-fcp    AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-vl-icms-fcp      AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-vl-icms-uf-dest  AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-vl-icms-uf-remet AS DECIMAL NO-UNDO.
DEFINE VARIABLE i-sequencia         AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-bc-pis-aces      AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-bc-cofins-aces   AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-pis-aces         AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-cofins-aces      AS DECIMAL NO-UNDO.
DEFINE VARIABLE i-colunas           AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-linha-corrente    AS INTEGER     NO-UNDO.

DEFINE BUFFER b-historico-embarque FOR historico-embarque.

/****************************  Temp-Tables  ****************************/
DEF TEMP-TABLE tt-class
    FIELD ncm like item.class-fiscal
    FIELD valor as dec format ">>,>>>,>>9.99"
    INDEX codigo is primary ncm.


/****************************  Temp-Tables  ****************************/
DEF TEMP-TABLE tt-documento NO-UNDO
    FIELD dt-trans          LIKE docum-est.dt-trans
    FIELD dt-emissao        LIKE docum-est.dt-emissao
    FIELD serie-docto       LIKE docum-est.serie-docto
    FIELD nro-docto         LIKE docum-est.nro-docto
    FIELD cod-emitente      LIKE docum-est.cod-emitente
    FIELD nome-abrev        LIKE emitente.nome-abrev 
    FIELD cgc               LIKE emitente.cgc
    FIELD estado            LIKE emitente.estado
    FIELD cidade            LIKE emitente.cidade
    FIELD pais              LIKE emitente.pais
    FIELD nat-operacao      LIKE docum-est.nat-operacao
    FIELD v-aliq            LIKE item-doc-est.aliquota-icm
    FIELD cod-devolucao     LIKE int-docum-est.cod-msg-devolucao
    FIELD cod_unid_negoc      AS CHARACTER FORMAT "x(3)":U  LABEL "Unid Neg¢cio":U COLUMN-LABEL "Un Neg":U
    FIELD des_unid_negoc      AS CHARACTER FORMAT "x(40)":U LABEL "Descri‡Æo":U    COLUMN-LABEL "Descri‡Æo":U
    FIELD it-codigo         LIKE item-doc-est.it-codigo
    FIELD descricao-1       LIKE item.descricao-1
    FIELD descricao-2       LIKE item.descricao-2
    FIELD cod-dcr-item      LIKE item.cod-dcr-item
    FIELD narrativa           AS CHAR
    FIELD class-fiscal      LIKE item-doc-est.class-fiscal
    FIELD aliquota-ipi      LIKE item-doc-est.aliquota-ipi
    FIELD aliq-ipi-ncm      LIKE classif-fisc.aliquota-ipi
    FIELD cod-depos         LIKE item-doc-est.cod-depos
    FIELD cod-localiz       LIKE item-doc-est.cod-localiz
    FIELD quantidade        LIKE item-doc-est.quantidade
    FIELD valor-mercadoria  LIKE docum-est.valor-mercad
    FIELD icm-deb-cre       LIKE item-doc-est.valor-icm[1]
    FIELD icm-complem       LIKE item-doc-est.icm-complem[1]
    FIELD nota-deb          LIKE item-doc-est.valor-ipi[1]
    FIELD de-tot-pis          AS DECIMAL  FORMAT ">>>>>>>>9.99"
    FIELD de-tot-cof          AS DECIMAL  FORMAT ">>>>>>>>9.99"
    FIELD tot-valor           AS DECIMAL  FORMAT ">>>>>>>>9.99"
    FIELD nro-comp          LIKE item-doc-est.nro-comp
    FIELD usuario           LIKE docum-est.usuario
    FIELD valor-frete       LIKE docum-est.valor-frete
    FIELD valor-seguro      LIKE docum-est.valor-frete
    FIELD tx-adm            LIKE desp-embarque.val-desp
    FIELD vl-invoice        LIKE invoice-emb-imp.vl-invoice
    FIELD char-1            LIKE docum-est.char-1
    FIELD aliquota-icm      LIKE docum-est.aliquota-icm
    FIELD de-tot-ii           AS DECIMAL  FORMAT ">>>>>>>>9.99" /*init 0 no-undo */
    FIELD c-emb             LIKE embarque-imp.embarque
    FIELD c-nr-di           LIKE embarque-imp.declaracao-import
    FIELD de-tot-icm          AS DECIMAL  format ">>>>>>>>9.99"
    FIELD de-tot-ipi          as decimal  format ">>>>>>>>9.99"
    field preco-unit        like item-doc-est.preco-unit[1]
    FIELD dt-vencto           AS DATE
    FIELD dt-pagto            AS DATE
    FIELD esp-dupli         LIKE dupli-apagar.cod-esp
    FIELD r-docum-est         AS ROWID
    field preco-unit-dl       as decimal 
    field cotacao-di          as dec 
    FIELD cotacao-entrada     AS DEC
    FIELD cotacao-emb         AS DEC
    FIELD nr-ord-prod       LIKE item-doc-est.nr-ord-prod
    FIELD nf-rateio         LIKE rat-docum.nro-docto
    FIELD vlr-rateio          as dec format ">>>,>>9.99"
    FIELD nf-desp-aces      LIKE docum-est.nro-docto
    FIELD vlr-desp-aces       as dec format ">>>,>>9.99"
    FIELD cod-estabel         AS CHARACTER FORMAT "x(3)"
    FIELD data-di             AS CHARACTER FORMAT "x(10)"
    FIELD hr-atualiza       LIKE docum-est.hr-atualiza
    FIELD base-subs         LIKE item-doc-est.base-subs 
    FIELD vl-subs           LIKE item-doc-est.vl-subs
    FIELD ins-estadual      LIKE emitente.ins-estadual
    FIELD log-atualizado      AS LOG FORMAT "Sim/NÆo"
    FIELD cod-origem-item   LIKE ITEM.codigo-orig
    FIELD val-base-pis      LIKE item-doc-est.base-pis            
    FIELD val-base-cofins   LIKE item-doc-est.val-base-calc-cofins
    FIELD val-aliq-pis      LIKE item-doc-est.val-aliq-pis        
    FIELD val-aliq-cofins   LIKE item-doc-est.val-aliq-cofins
    FIELD cod-tributac      LIKE dwf-docto-item-impto.cod-tributac
    FIELD val-desp-THC      LIKE item-doc-est-cex.val-desp
    FIELD perc-II           AS   DECIMAL FORMAT ">>9.99":U
    FIELD modal-frete       AS   CHAR
    FIELD nome-transp       AS   CHAR
    FIELD cod-chave-aces-nf-eletro LIKE nota-fiscal.cod-chave-aces-nf-eletro
    FIELD num-pedido         LIKE item-doc-est.num-pedido  
    FIELD numero-ordem       LIKE item-doc-est.numero-ordem
    FIELD parcela            LIKE item-doc-est.parcela     
    FIELD cod-cond-pag       LIKE ordem-compra.cod-cond-pag
    FIELD descricao-cond-pag LIKE cond-pagto.descricao
    FIELD cod-comprado       LIKE ordem-compra.cod-comprado
    FIELD ge-codigo          LIKE ITEM.ge-codigo
    FIELD atendente          AS CHAR FORMAT "x(3)"
    FIELD d-vl-bc-uf-dest    AS DECIMAL   FORMAT "->>>>>>>>>>>9.99":U COLUMN-LABEL "Vl BC UF Dest"
    FIELD d-aliq-uf-dest     AS DECIMAL   FORMAT "->>9.99":U          COLUMN-LABEL "Aliq UF Dest"
    FIELD d-aliq-inter       AS DECIMAL   FORMAT "->>9.99":U          COLUMN-LABEL "Aliq Inter"
    FIELD d-perc-icms-fcp    AS DECIMAL   FORMAT "->>9.99":U          COLUMN-LABEL "% ICMS FCP"
    FIELD d-vl-icms-fcp      AS DECIMAL   FORMAT "->>>>>>>>>>>9.99":U COLUMN-LABEL "Vl ICMS FCP"
    FIELD d-vl-icms-uf-dest  AS DECIMAL   FORMAT "->>>>>>>>>>>9.99":U COLUMN-LABEL "Vl ICMS UF Dest"
    FIELD d-vl-icms-uf-remet AS DECIMAL   FORMAT "->>>>>>>>>>>9.99":U COLUMN-LABEL "Vl ICMS UF Remet"
    FIELD contrib-icms       AS CHARACTER
    FIELD de-bc-pis-aces     AS DECIMAL
    FIELD de-bc-cofins-aces  AS DECIMAL
    FIELD de-pis-aces        AS DECIMAL
    FIELD de-cofins-aces     AS DECIMAL
    FIELD de-vl-icms-simples-nac AS DECIMAL   FORMAT "->>>>>>>>>>>9.99":U COLUMN-LABEL "Vl ICMS Simples Nac"
    FIELD de-aliq-icms-simples-nac AS DECIMAL   FORMAT "->>>>>>>>>>>9.99":U COLUMN-LABEL "Aliq ICMS Simples Nac"
    FIELD de-base-icms-simples-nac AS DECIMAL   FORMAT "->>>>>>>>>>>9.99":U COLUMN-LABEL "VL BC ICMS Simples Nac"
    FIELD csosn AS CHAR FORM "x(10)"
    FIELD nom-solicitante AS CHAR
    FIELD reinf              AS CHAR
    FIELD tipo-serv          AS CHAR
    FIELD vl-bc-retenc       AS DECIMAL
    FIELD vl-retenc          AS DECIMAL
    FIELD vl-base-icm-compl  AS DECIMAL
    FIELD vl-icm-compl       AS DECIMAL
    FIELD fm-materias      AS CHAR
    FIELD base-calc-icms   AS DEC
    FIELD origem-item      AS CHAR
    FIELD cst-item         AS CHAR
    FIELD fcp              AS DEC
    FIELD cd-servico       LIKE int-codigo-servico.cd-servico
    FIELD ds-servico       LIKE int-codigo-servico.ds-servico
    FIELD cd-enquadramento LIKE int-enquadramento.cd-enquadramento
    FIELD ds-enquadramento LIKE int-enquadramento.ds-enquadramento

    FIELD cd-atividade-mei AS INT
    FIELD ds-atividade-mei AS CHAR

    FIELD sequencia        LIKE item-doc-est.sequencia
    FIELD cod-repres       LIKE nota-fiscal.cod-rep
    FIELD desc-repres      LIKE nota-fiscal.no-ab-reppri
    FIELD cod-trib-am      LIKE dia-item.cod-tributac-icms
    FIELD val-impto-import LIKE item-docto-estoq-nfe-imp.val-impto-import
    FIELD num-adic         LIKE item-docto-estoq-nfe-imp.num-adic 
    FIELD num-seq-import   LIKE item-docto-estoq-nfe-imp.num-seq-import
    INDEX chave1 dt-trans r-docum-est.
         
DEF TEMP-TABLE tt-rateio NO-UNDO
    FIELD nro-docto    LIKE rat-docum.nro-docto
    FIELD serie-docto  LIKE rat-docum.serie-docto
    FIELD nat-operacao LIKE rat-docum.nat-operacao
    FIELD cod-emitente LIKE rat-docum.cod-emitente
    INDEX chave1 nro-docto 
                 serie-docto
                 nat-operacao
                 cod-emitente.

def temp-table tt-documento-aux no-undo
    field r-documento        as recid
    field conta-contabil   like item-doc-est.conta-contabil
    field it-codigo        like tt-documento.it-codigo
    field valor-mercadoria like tt-documento.valor-mercadoria
    field vl-invoice       like tt-documento.vl-invoice
    field valor-frete      like tt-documento.valor-frete  
    FIELD valor-seguro     like tt-documento.valor-frete  
    field tx-adm           like tt-documento.tx-adm
    field de-tot-icm       like tt-documento.de-tot-icm
    field de-tot-ii        like tt-documento.de-tot-ii
    field de-tot-pis       like tt-documento.de-tot-pis
    field de-tot-cof       like tt-documento.de-tot-cof
    field tot-valor        like tt-documento.tot-valor
    field nota-deb         like tt-documento.nota-deb
    field quantidade       like tt-documento.quantidade
    field icm-deb-cre      like tt-documento.icm-deb-cre
    field icm-complem      like tt-documento.icm-complem
    FIELD ct-codigo        LIKE item-doc-est.ct-codigo
    FIELD sc-codigo        LIKE item-doc-est.sc-codigo
    FIELD cod-unid-negoc   LIKE item-doc-est.cod-unid-negoc
    index codigo r-documento conta-contabil
    index codigo2 r-documento it-codigo ct-codigo sc-codigo.

DEF TEMP-TABLE tt-fornec-imposto NO-UNDO
    FIELD cod-emitente LIKE emitente.cod-emitente
    FIELD log-listar     AS LOG
    INDEX id-emitente
            cod-emitente.

def buffer b-tt-documento-aux for tt-documento-aux.
DEF BUFFER bf-docum-est FOR docum-est.


/****************************  Frames       ****************************/
DEF INPUT PARAMETER raw-param as raw no-undo.
DEF INPUT PARAMETER table for tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

DEF TEMP-TABLE tt-emit
    FIELD cod-emitente AS INT.

/*J  repassa os registros compartilhados de emitente na tt-digita, e os deleta*/
FOR EACH tt-digita
    WHERE tt-digita.tipo = 1: /*emitente*/
    CREATE tt-emit.
    ASSIGN tt-emit.cod-emitente = tt-digita.cod-emitente.
    DELETE tt-digita.
END.


DEF VAR h-acomp      as handle no-undo.
def var c-separador  as char format "x(01)".
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "NF de Entrada"
       c-empresa      = if avail empresa then empresa.razao-social else ''.

assign c-separador = ";".

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i &pagesize="9999999"}

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

    EMPTY TEMP-TABLE tt-fornec-imposto.
    
    IF tt-param.tipo = 1 THEN
       RUN piRelatSintetico.
    ELSE 
       RUN piRelatAnalitico.

    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
END.

PROCEDURE piRelatSintetico-por-faixa:
      DEFINE VARIABLE l-encontrou-contas  AS LOGICAL NO-UNDO.
      bloco-nfe1:
      FOR EACH docum-est NO-LOCK                                   WHERE
               docum-est.dt-trans     >= tt-param.ini-data         AND
               docum-est.dt-trans     <= tt-param.fim-data         AND
               docum-est.cod-estabel  >= tt-param.cod-estabel-ini  and
               docum-est.cod-estabel  <= tt-param.cod-estabel-fim  and 
               docum-est.nat-operacao >= tt-param.ini-nat-operacao AND
               docum-est.nat-operacao <= tt-param.fim-nat-operacao AND
               docum-est.cod-emitente >= tt-param.ini-cod-emitente AND
               docum-est.cod-emitente <= tt-param.fim-cod-emitente AND
               docum-est.uf           >= tt-param.ini-uf           AND
               docum-est.uf           <= tt-param.fim-uf           AND
               docum-est.usuario      >= tt-param.ini-usuario      AND
               docum-est.usuario      <= tt-param.fim-usuario: 

          IF CAN-FIND(FIRST item-doc-est OF docum-est
                    WHERE item-doc-est.it-codigo    >= tt-param.it-codigo-ini
                      AND item-doc-est.it-codigo    <= tt-param.it-codigo-fim
                      AND item-doc-est.class-fiscal >= tt-param.classific-ini 
                      AND item-doc-est.class-fiscal <= tt-param.classific-fim
                      AND item-doc-est.cod-depos    >= tt-param.cod-depos-ini
                      AND item-doc-est.cod-depos    <= tt-param.cod-depos-fim) THEN
              {esp/rep/esrep007rp-a.i "bloco-nfe1"}
       END.
END.

PROCEDURE piRelatSintetico-por-emitente:
    DEFINE VARIABLE l-encontrou-contas  AS LOGICAL NO-UNDO.
    bloco-nfe2:
    FOR EACH tt-emit
        ,EACH docum-est NO-LOCK                                   WHERE
             docum-est.dt-trans     >= tt-param.ini-data         AND
             docum-est.dt-trans     <= tt-param.fim-data         AND
             docum-est.cod-estabel  >= tt-param.cod-estabel-ini  and
             docum-est.cod-estabel  <= tt-param.cod-estabel-fim  and 
             docum-est.nat-operacao >= tt-param.ini-nat-operacao AND
             docum-est.nat-operacao <= tt-param.fim-nat-operacao AND
             docum-est.cod-emitente  = tt-emit.cod-emitente      AND
             docum-est.uf           >= tt-param.ini-uf           AND
             docum-est.uf           <= tt-param.fim-uf           AND
             docum-est.usuario      >= tt-param.ini-usuario      AND
             docum-est.usuario      <= tt-param.fim-usuario: 

            IF CAN-FIND(FIRST item-doc-est OF docum-est
                    WHERE item-doc-est.it-codigo    >= tt-param.it-codigo-ini
                      AND item-doc-est.it-codigo    <= tt-param.it-codigo-fim
                      AND item-doc-est.class-fiscal >= tt-param.classific-ini 
                      AND item-doc-est.class-fiscal <= tt-param.classific-fim
                      AND item-doc-est.cod-depos    >= tt-param.cod-depos-ini
                      AND item-doc-est.cod-depos    <= tt-param.cod-depos-fim) THEN
                {esp/rep/esrep007rp-a.i "bloco-nfe2"}
    END.
END.

PROCEDURE piRelatSintetico:
    DEFINE VARIABLE l-encontrou-contas  AS LOGICAL     NO-UNDO.
    RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").

    IF  CAN-FIND (FIRST tt-emit) THEN
        RUN piRelatSintetico-por-emitente.
    ELSE
        RUN piRelatSintetico-por-faixa.

    
    assign de-vl-mercadoria    = 0
           de-vl-invoice       = 0
           de-tot-icm          = 0
           de-nota-deb         = 0
           de-tot-ii           = 0
           de-tot-pis          = 0
           de-tot-cof          = 0
           de-impostos         = 0
           de-tot-impostos     = 0
           de-frete            = 0
           de-tot-frete        = 0
           de-tot-valor        = 0
           de-vl-bc-uf-dest    = 0
           de-aliq-uf-dest     = 0
           de-aliq-inter       = 0
           de-perc-icms-fcp    = 0
           de-vl-icms-fcp      = 0
           de-vl-icms-uf-dest  = 0
           de-vl-icms-uf-remet = 0
           de-bc-pis-aces      = 0
           de-bc-cofins-aces   = 0
           de-pis-aces         = 0
           de-cofins-aces      = 0
           de-tot-vl-icms-simples-nac = 0
           l-imp               = NO.
    
    if  not tt-param.imprime-conta then do:
        /*--- chamado 37224, lista Chave de Acesso ---*/
        IF  tt-param.l-listar-chave THEN
            PUT UNFORMATTED "N£mero ;Ser;Data      ;Est;Emitente;Nome        ;Embarque  ;Natureza  ;Val.Merc.(Real) ;Val.Merc.(D¢lar)        ; Val.Frete        ;Tx.Adm;Seguro;Val.ICMS         ;Val.IPI          ;Val.II         ;Val.PIS         ;Val.COF    ;Val.Impostos       ;Val.Total                  ;DI             ;Data DI;CNPJ  ;% ICMS ;Usu rio;Val-Unit$;Cotacao;NF Rateio;Vlr Rateio;NF Desp;Vlr Desp;Cota‡Æo Emb;Cota‡Æo Entrada;Hr Atualiza‡Æo;NF Atualizada;Depos;Modal Frete;Nome Transp;Chave Acesso NFe;UF Emitente;ConexÆoNF-e;Vl BC UF Dest;Vl ICMS UF Remet;Vl ICMS UF Dest;Vl ICMS FCP;Contrib.ICMS;BC PIS Aces;Vl PIS Aces;BC COFINS Aces;Vl COFINS Aces;VL ICMS Simples Nac;Solicitante;FM Mat.;Base Calc. ICMS;Origem;CST;FCP;C¢d. Serv.;Ds. Serv.;C¢d. Enquadr.; Ds. Enquadr;Cod.Atividade MEI;Desc.Atividade MEI;Id Nota" SKIP. 
        ELSE
            PUT UNFORMATTED "N£mero ;Ser;Data      ;Est;Emitente;Nome        ;Embarque  ;Natureza  ;Val.Merc.(Real) ;Val.Merc.(D¢lar)        ; Val.Frete        ;Tx.Adm;Seguro;Val.ICMS         ;Val.IPI          ;Val.II         ;Val.PIS         ;Val.COF    ;Val.Impostos       ;Val.Total                  ;DI             ;Data DI;CNPJ  ;% ICMS ;Usu rio;Val-Unit$;Cotacao;NF Rateio;Vlr Rateio;NF Desp;Vlr Desp;Cota‡Æo Emb;Cota‡Æo Entrada;Hr Atualiza‡Æo;NF Atualizada;Depos;Modal Frete;Nome Transp;UF Emitente;ConexÆoNF-e;Vl BC UF Dest;Vl ICMS UF Remet;Vl ICMS UF Dest;Vl ICMS FCP;Contrib.ICMS;BC PIS Aces;Vl PIS Aces;BC COFINS Aces;Vl COFINS Aces;VL ICMS Simples Nac;Solicitante;FM Mat.;Base Calc. ICMS;Origem;CST;FCP;C¢d. Serv.;Ds. Serv.;C¢d. Enquadr.; Ds. Enquadr;Cod.Atividade MEI;Desc.Atividade MEI;Id Nota" SKIP.  
        
        FOR EACH tt-documento:

            RUN pi-acompanhar IN h-acomp (INPUT "Listando Nota: " + tt-documento.nro-docto + " - Data: " + STRING(tt-documento.dt-trans,"99/99/9999")).

            if not can-find (first tt-documento-aux
                             where tt-documento-aux.r-documento = recid(tt-documento)) then next.     

            FIND FIRST gt-tt-docum-est NO-LOCK
                 WHERE gt-tt-docum-est.serie-docto  = tt-documento.serie-docto 
                   AND gt-tt-docum-est.nro-docto    = tt-documento.nro-docto   
                   AND gt-tt-docum-est.cod-emitente = tt-documento.cod-emitente
                   AND gt-tt-docum-est.nat-operacao = tt-documento.nat-operacao NO-ERROR.

        
            ASSIGN de-vl-mercadoria    = de-vl-mercadoria    + tt-documento.valor-mercadoria
                   de-vl-invoice       = de-vl-invoice       + tt-documento.vl-invoice
                   de-tot-icm          = de-tot-icm          + tt-documento.de-tot-icm
                   de-nota-deb         = de-nota-deb         + tt-documento.nota-deb
                   de-tot-ii           = de-tot-ii           + tt-documento.de-tot-ii
                   de-tot-pis          = de-tot-pis          + tt-documento.de-tot-pis
                   de-tot-cof          = de-tot-cof          + tt-documento.de-tot-cof
                   de-impostos         = (tt-documento.de-tot-icm + tt-documento.nota-deb + tt-documento.de-tot-ii + tt-documento.de-tot-pis + tt-documento.de-tot-cof)
                   de-tot-impostos     = de-tot-impostos     + de-impostos
                   de-tot-frete        = de-tot-frete        + tt-documento.valor-frete
                   de-tot-valor        = de-tot-valor        + tt-documento.tot-valor
                   de-vl-bc-uf-dest    = de-vl-bc-uf-dest    + tt-documento.d-vl-bc-uf-dest    
                   de-aliq-uf-dest     = de-aliq-uf-dest     + tt-documento.d-aliq-uf-dest     
                   de-aliq-inter       = de-aliq-inter       + tt-documento.d-aliq-inter       
                   de-perc-icms-fcp    = de-perc-icms-fcp    + tt-documento.d-perc-icms-fcp    
                   de-vl-icms-fcp      = de-vl-icms-fcp      + tt-documento.d-vl-icms-fcp      
                   de-vl-icms-uf-dest  = de-vl-icms-uf-dest  + tt-documento.d-vl-icms-uf-dest  
                   de-vl-icms-uf-remet = de-vl-icms-uf-remet + tt-documento.d-vl-icms-uf-remet
                   de-bc-pis-aces      = de-bc-pis-aces      + tt-documento.de-bc-pis-aces   
                   de-bc-cofins-aces   = de-bc-cofins-aces   + tt-documento.de-bc-cofins-aces
                   de-pis-aces         = de-pis-aces         + tt-documento.de-pis-aces      
                   de-cofins-aces      = de-cofins-aces      + tt-documento.de-cofins-aces   
                   de-tot-vl-icms-simples-nac = de-tot-vl-icms-simples-nac + tt-documento.de-vl-icms-simples-nac.
                   l-imp               = YES.            
         
            PUT tt-documento.nro-docto                              FORMAT "9999999999"
                c-separador
                tt-documento.serie-docto                            FORMAT "x(4)" 
                c-separador
                tt-documento.dt-trans                               FORMAT "99/99/9999" 
                c-separador
                tt-documento.cod-estab                              format "x(3)"
                c-separador
                tt-documento.cod-emitente                       
                c-separador
                tt-documento.nome-abrev                             FORMAT "x(12)"         
                c-separador
                tt-documento.c-emb                                  FORMAT "x(10)"
                c-separador
                tt-documento.nat-operacao                           FORMAT "999xxx"   
                c-separador                                                                                
                tt-documento.valor-mercadoria                       FORMAT ">>,>>>,>>>,>>9.99"                                                                                                     
                c-separador
                tt-documento.vl-invoice                             FORMAT ">>,>>>,>>>,>>9.99" 
                c-separador
                tt-documento.valor-frete                            FORMAT ">>,>>>,>>>,>>9.99" 
                c-separador
                tt-documento.tx-adm                                 FORMAT ">>,>>>,>>>,>>9.99" 
                c-separador
                tt-documento.valor-seguro
                c-separador
                tt-documento.de-tot-icm                             FORMAT ">,>>>,>>>,>>9.99" 
                c-separador
                tt-documento.nota-deb                               FORMAT ">,>>>,>>>,>>9.99" 
                c-separador
                tt-documento.de-tot-ii                              FORMAT ">,>>>,>>>,>>9.99" 
                c-separador
                tt-documento.de-tot-pis                             FORMAT ">,>>>,>>>,>>9.99" 
                c-separador
                tt-documento.de-tot-cof                             FORMAT ">,>>>,>>>,>>9.99" 
                c-separador
                de-impostos                                         FORMAT ">,>>>,>>>,>>9.99" 
                c-separador
                tt-documento.tot-valor                              FORMAT ">,>>>,>>>,>>9.99" 
                c-separador
                tt-documento.c-nr-di                                FORMAT "x(20)" 
                c-separador
                tt-documento.data-di
                c-separador
                tt-documento.cgc                                    FORMAT "x(17)" 
                c-separador
                tt-documento.v-aliq                                 FORMAT ">>9.99"
                c-separador
                tt-documento.usuario                                FORMAT "x(8)"
                c-separador
                tt-documento.preco-unit-dl                          
                c-separador
                tt-documento.cotacao-di                                
                c-separador
                tt-documento.nf-rateio                              FORMAT "999999999"
                c-separador
                tt-documento.vlr-rateio                             format ">>>,>>9.99"
                c-separador
                tt-documento.nf-desp-aces                           FORMAT "9999999"
                c-separador
                tt-documento.vlr-desp-aces                          format ">>>,>>>,>>9.99"
                c-separador.
            
            PUT UNFORMATTED
                tt-documento.cotacao-emb
                c-separador
                tt-documento.cotacao-entrada
                c-separador
                tt-documento.hr-atualiza FORMAT "x(8)":U
                c-separador
                tt-documento.log-atualizado FORMAT "Sim/NÆo"
                c-separador 
                tt-documento.cod-depos
                c-separador
                tt-documento.modal-frete
                c-separador
                tt-documento.nome-transp.

            /*--- chamado 37224, lista Chave de Acesso ---*/
            IF  tt-param.l-listar-chave THEN DO:
                /*IF  tt-documento.cod-chave-aces-nf-eletro <> "" 
                THEN PUT UNFORMATTED c-separador
                                     tt-documento.cod-chave-aces-nf-eletro FORMAT "X(60)":U. FORMAT "99.9999.99.999.999/9999-99-99-999-999.999.999-999.999.999-9":U.*/
                PUT UNFORMATTED c-separador
                                "'" tt-documento.cod-chave-aces-nf-eletro FORMAT "X(60)":U.
            END. /* IF  tt-param.l-listar-chave THEN DO: */

            PUT UNFORMATTED c-separador
                            tt-documento.estado FORMAT "x(2)"
                            c-separador
                            IF AVAIL gt-tt-docum-est AND gt-tt-docum-est.log-situacao THEN "Sim" ELSE "NÆo"
                            c-separador
                            tt-documento.d-vl-bc-uf-dest        c-separador
                            tt-documento.d-vl-icms-uf-remet     c-separador
                            tt-documento.d-vl-icms-uf-dest      c-separador
                            tt-documento.d-vl-icms-fcp          c-separador
                            tt-documento.contrib-icms           c-separador
                            tt-documento.de-bc-pis-aces         c-separador
                            tt-documento.de-pis-aces            c-separador
                            tt-documento.de-bc-cofins-aces      c-separador  
                            tt-documento.de-cofins-aces         c-separador 
                            tt-documento.de-vl-icms-simples-nac c-separador  
                            tt-documento.nom-solicitante        c-separador  
                            tt-documento.fm-materias            c-separador  
                            tt-documento.base-calc-icms         c-separador  
                            tt-documento.origem-item            c-separador  
                            tt-documento.cst-item               c-separador  
                            tt-documento.fcp                    c-separador  
                            tt-documento.cd-servico             c-separador                         
                            tt-documento.ds-servico             c-separador
                            tt-documento.cd-enquadramento       c-separador
                            tt-documento.ds-enquadramento       c-separador
                            tt-documento.cd-atividade-mei       c-separador
                            tt-documento.ds-atividade-mei       c-separador
                            string(tt-documento.r-docum-est)    SKIP.
            
        END.
        
        if l-imp THEN DO:
            PUT UNFORMATTED SKIP(1)
                ";;;;;;;Total:;"
                de-vl-mercadoria     FORMAT ">>,>>>,>>>,>>9.99" ";"
                de-vl-invoice        format ">>,>>>,>>>,>>9.99" ";"
                de-tot-frete         format ">>,>>>,>>>,>>9.99" ";;;"
                de-tot-icm           format ">,>>>,>>>,>>9.99"  ";"
                de-nota-deb          format ">,>>>,>>>,>>9.99"  ";"
                de-tot-ii            format ">,>>>,>>>,>>9.99"  ";"
                de-tot-pis           format ">,>>>,>>>,>>9.99"  ";"
                de-tot-cof           format ">,>>>,>>>,>>9.99"  ";"
                de-tot-impostos      format ">,>>>,>>>,>>9.99"  ";"
                de-tot-valor         format ">,>>>,>>>,>>9.99"  ";;;;;;;;;;;;;;;;;;;;;"
                de-vl-bc-uf-dest     FORMAT "->>>>>>>>>>>9.99"  ";"
                de-vl-icms-uf-remet  FORMAT "->>>>>>>>>>>9.99"  ";"
                de-vl-icms-uf-dest   FORMAT "->>>>>>>>>>>9.99"  ";"
                de-vl-icms-fcp       FORMAT "->>>>>>>>>>>9.99"  ";;" 
                de-bc-pis-aces       FORMAT "->>>>>>>>>>>9.99"  ";" 
                de-pis-aces          FORMAT "->>>>>>>>>>>9.99"  ";" 
                de-bc-cofins-aces    FORMAT "->>>>>>>>>>>9.99"  ";" 
                de-cofins-aces       FORMAT "->>>>>>>>>>>9.99"  ";" 
                de-tot-vl-icms-simples-nac       FORMAT "->>>>>>>>>>>9.99"  ";" SKIP.
        END.
    end. /* if not tt-param.imprime-conta then do: */
    else do:
        for each tt-documento:

            RUN pi-acompanhar IN h-acomp (INPUT "Listando Nota: " + tt-documento.nro-docto + " - Data: " + STRING(tt-documento.dt-trans,"99/99/9999")).

            for each tt-documento-aux use-index codigo
                where tt-documento-aux.r-documento = recid(tt-documento)
                break by tt-documento-aux.ct-codigo 
                      by tt-documento-aux.sc-codigo :
                assign de-proporcao = if tt-documento.tot-valor > 0 then tt-documento-aux.tot-valor / tt-documento.tot-valor else 0
                       tt-documento-aux.valor-mercadoria = tt-documento.valor-mercadoria * de-proporcao
                       tt-documento-aux.vl-invoice       = tt-documento.vl-invoice * de-proporcao
                       tt-documento-aux.valor-frete      = tt-documento.valor-frete * de-proporcao
                       tt-documento-aux.tx-adm           = tt-documento.tx-adm * de-proporcao
                       tt-documento-aux.de-tot-icm       = tt-documento.de-tot-icm * de-proporcao
                       tt-documento-aux.de-tot-ii        = tt-documento.de-tot-ii * de-proporcao
                       tt-documento-aux.de-tot-pis       = tt-documento.de-tot-pis * de-proporcao
                       tt-documento-aux.de-tot-cof       = tt-documento.de-tot-cof * de-proporcao
                       tt-documento-aux.nota-deb         = tt-documento.nota-deb * de-proporcao
                       tt-documento-aux.tot-valor        = tt-documento.tot-valor * de-proporcao.
                       
                accumulate tt-documento-aux.valor-mercadoria (total)
                           tt-documento-aux.vl-invoice       (total)
                           tt-documento-aux.valor-frete      (total)
                           tt-documento-aux.tx-adm           (total)
                           tt-documento-aux.de-tot-icm       (total)
                           tt-documento-aux.de-tot-ii        (total)
                           tt-documento-aux.de-tot-pis       (total)
                           tt-documento-aux.de-tot-cof       (total)
                           tt-documento-aux.nota-deb         (total)
                           tt-documento-aux.tot-valor        (total).
                           
                if  last(tt-documento-aux.ct-codigo) OR last(tt-documento-aux.sc-codigo) then do:
                    find last b-tt-documento-aux 
                        where b-tt-documento-aux.r-documento = tt-documento-aux.r-documento no-error.
                    assign b-tt-documento-aux.valor-mercadoria = b-tt-documento-aux.valor-mercadoria +
                           tt-documento.valor-mercadoria - (accum total tt-documento-aux.valor-mercadoria)
                           b-tt-documento-aux.vl-invoice       = b-tt-documento-aux.vl-invoice +
                           tt-documento.vl-invoice - (accum total tt-documento-aux.vl-invoice)
                           b-tt-documento-aux.valor-frete      = b-tt-documento-aux.valor-frete +
                           tt-documento.valor-frete - (accum total tt-documento-aux.valor-frete)
                           b-tt-documento-aux.tx-adm           = b-tt-documento-aux.tx-adm +
                           tt-documento.tx-adm - (accum total tt-documento-aux.tx-adm)
                           b-tt-documento-aux.de-tot-icm       = b-tt-documento-aux.de-tot-icm +
                           tt-documento.de-tot-icm - (accum total tt-documento-aux.de-tot-icm)
                           b-tt-documento-aux.de-tot-ii        = b-tt-documento-aux.de-tot-ii +
                           tt-documento.de-tot-ii - (accum total tt-documento-aux.de-tot-ii)
                           b-tt-documento-aux.de-tot-pis       = b-tt-documento-aux.de-tot-pis +
                           tt-documento.de-tot-pis - (accum total tt-documento-aux.de-tot-pis)
                           b-tt-documento-aux.de-tot-cof       = b-tt-documento-aux.de-tot-cof +
                           tt-documento.de-tot-cof - (accum total tt-documento-aux.de-tot-cof)
                           b-tt-documento-aux.nota-deb         = b-tt-documento-aux.nota-deb +
                           tt-documento.nota-deb - (accum total tt-documento-aux.nota-deb)
                           b-tt-documento-aux.tot-valor        = b-tt-documento-aux.tot-valor +
                           tt-documento.tot-valor - (accum total tt-documento-aux.tot-valor).
                end.                                   
                       
            end.
        end. /* for each tt-documento */   
        
        IF tt-param.imprime-financeiro THEN DO:
            /*N£mero de colunas impressa por esse programa*/
            /*ASSIGN i-colunas = 30.*/

            //ASSIGN i-colunas = 58. - Comentado Isac - 25/01/21

            ASSIGN i-colunas = 60. // Alterado Isac , Acressimo de 2 Colunas - 25/01/21

            /*--- chamado 37224, lista Chave de Acesso ---*/
            IF  tt-param.l-listar-chave THEN
                PUT UNFORMATTED "N£mero ;Ser;Data      ;Est;Emitente;Nome        ;Embarque  ;Natureza;Conta;Sub-Conta;Unid. Negoc.;Val.Merc.(Real) ;Val.Merc.(D¢lar)        ;Val.Frete       ;Tx.Adm;Seguro;Val.ICMS         ;Val.IPI          ;Val.II         ;Val.PIS         ;Val.COF    ;Val.Impostos       ;Val.Total       ;DI                  ;Data DI;CNPJ        ;% ICMS ;Usu rio; Dt.Vencto; Dt.Pagto; Esp.Dupl.;Cota‡Æo Emb;Cota‡Æo Entrada;NF Atualizada;Depos;Modal Frete;Nome Transp;Chave Acesso NFe;UF Emitente;ConexÆoNF-e;Vl BC UF Dest;Vl ICMS UF Remet;Vl ICMS UF Dest;Vl ICMS FCP;Contrib.ICMS;BC PIS Aces;Vl PIS Aces;BC COFINS Aces;Vl COFINS Aces;Vl ICMS Simpes Nac;Solicitante;FM Mat.;Base Calc. ICMS;Origem;CST;FCP;C¢d. Serv.;Ds. Serv.;C¢d. Enquadr.; Ds. Enquadr;Cod.Atividade MEI;Desc.Atividade MEI;Id Nota;Pagamento;Estab;Fornecedor;Especie;Serie;Titulo;Parcela;Nome;Conta;CCusto;Banco;Agencia;Dig Agencia;Conta Corrente;Dig Conta Corrente;Data Movimento;Modo Pagamento;Portador;Border“;Cheque;Valor Movimento;Contra AN ?;Hist¢rico" SKIP.  
            ELSE
                PUT UNFORMATTED "N£mero ;Ser;Data      ;Est;Emitente;Nome        ;Embarque  ;Natureza;Conta;Sub-Conta;Unid. Negoc.;Val.Merc.(Real) ;Val.Merc.(D¢lar)        ;Val.Frete       ;Tx.Adm;Seguro;Val.ICMS         ;Val.IPI          ;Val.II         ;Val.PIS         ;Val.COF    ;Val.Impostos       ;Val.Total       ;DI                  ;Data DI;CNPJ        ;% ICMS ;Usu rio; Dt.Vencto; Dt.Pagto; Esp.Dupl.;Cota‡Æo Emb;Cota‡Æo Entrada;NF Atualizada;Depos;Modal Frete;Nome Transp;UF Emitente;ConexÆoNF-e;Vl BC UF Dest;Vl ICMS UF Remet;Vl ICMS UF Dest;Vl ICMS FCP;Contrib.ICMS;BC PIS Aces;Vl PIS Aces;BC COFINS Aces;Vl COFINS Aces;Vl ICMS Simpes Nac;Solicitante;FM Mat.;Base Calc. ICMS;Origem;CST;FCP;C¢d. Serv.;Ds. Serv.;C¢d. Enquadr.; Ds. Enquadr;Cod.Atividade MEI;Desc.Atividade MEI;Id Nota;Pagamento;Estab;Fornecedor;Especie;Serie;Titulo;Parcela;Nome;Conta;CCusto;Banco;Agencia;Dig Agencia;Conta Corrente;Dig Conta Corrente;Data Movimento;Modo Pagamento;Portador;Border“;Cheque;Valor Movimento;Contra AN ?;Hist¢rico" SKIP.  
        END.
        ELSE DO:
            IF  tt-param.l-listar-chave 
            THEN PUT UNFORMATTED "N£mero ;Ser;Data      ;Est;Emitente;Nome        ;Embarque  ;Natureza;Conta;Sub-Conta;Unid. Negoc.;Val.Merc.(Real) ;Val.Merc.(D¢lar)        ;Val.Frete       ;Tx.Adm;Seguro;Val.ICMS         ;Val.IPI          ;Val.II         ;Val.PIS         ;Val.COF    ;Val.Impostos       ;Val.Total       ;DI                  ;Data DI;CNPJ        ;% ICMS ;Usu rio; Dt.Vencto; Dt.Pagto; Esp.Dupl.;Cota‡Æo Emb;Cota‡Æo Entrada;NF Atualizada;Depos;Modal Frete;Nome Transp;Chave Acesso NFe;UF Emitente;ConexÆoNF-e;Vl BC UF Dest;Vl ICMS UF Remet;Vl ICMS UF Dest;Vl ICMS FCP;Contrib.ICMS;BC PIS Aces;Vl PIS Aces;BC COFINS Aces;Vl COFINS Aces;Vl ICMS Simpes Nac;Solicitante;FM Mat.;Base Calc. ICMS;Origem;CST;FCP;C¢d. Serv.;Ds. Serv.;C¢d. Enquadr.; Ds. Enquadr;Cod.Atividade MEI;Desc.Atividade MEI;Id Nota" SKIP.  
            ELSE PUT UNFORMATTED "N£mero ;Ser;Data      ;Est;Emitente;Nome        ;Embarque  ;Natureza;Conta;Sub-Conta;Unid. Negoc.;Val.Merc.(Real) ;Val.Merc.(D¢lar)        ;Val.Frete       ;Tx.Adm;Seguro;Val.ICMS         ;Val.IPI          ;Val.II         ;Val.PIS         ;Val.COF    ;Val.Impostos       ;Val.Total       ;DI                  ;Data DI;CNPJ        ;% ICMS ;Usu rio; Dt.Vencto; Dt.Pagto; Esp.Dupl.;Cota‡Æo Emb;Cota‡Æo Entrada;NF Atualizada;Depos;Modal Frete;Nome Transp;UF Emitente;ConexÆoNF-e;Vl BC UF Dest;Vl ICMS UF Remet;Vl ICMS UF Dest;Vl ICMS FCP;Contrib.ICMS;BC PIS Aces;Vl PIS Aces;BC COFINS Aces;Vl COFINS Aces;Vl ICMS Simpes Nac;Solicitante;FM Mat.;Base Calc. ICMS;Origem;CST;FCP;C¢d. Serv.;Ds. Serv.;C¢d. Enquadr.; Ds. Enquadr;Cod.Atividade MEI;Desc.Atividade MEI;Id Nota" SKIP. 
        END.
            
        FOR EACH tt-documento:

            RUN pi-acompanhar IN h-acomp (INPUT "Listando Nota: " + tt-documento.nro-docto + " - Data: " + STRING(tt-documento.dt-trans,"99/99/9999")).

            for each tt-documento-aux use-index codigo
                where tt-documento-aux.r-documento = recid(tt-documento)
                break BY tt-documento-aux.r-documento
                      by tt-documento-aux.ct-codigo
                      by tt-documento-aux.sc-codigo:

                FIND FIRST gt-tt-docum-est NO-LOCK
                     WHERE gt-tt-docum-est.serie-docto  = tt-documento.serie-docto 
                       AND gt-tt-docum-est.nro-docto    = tt-documento.nro-docto   
                       AND gt-tt-docum-est.cod-emitente = tt-documento.cod-emitente
                       AND gt-tt-docum-est.nat-operacao = tt-documento.nat-operacao NO-ERROR.

                /*if first(tt-documento-aux.conta-contabil) then*/
                
                PUT UNFORMATTED 
                    tt-documento.nro-docto                              FORMAT "9999999999"
                    c-separador
                    tt-documento.serie-docto                            FORMAT "x(4)"
                    c-separador
                    tt-documento.dt-trans                               FORMAT "99/99/9999"
                    c-separador
                    tt-documento.cod-estab                              format "x(3)"
                    c-separador
                    tt-documento.cod-emitente                       
                    c-separador
                    tt-documento.nome-abrev                             FORMAT "x(30)"         
                    c-separador
                    tt-documento.c-emb                                  FORMAT "x(10)"
                    c-separador
                    tt-documento.nat-operacao                           FORMAT "999xxx"   
                    c-separador.

                assign de-vl-mercadoria = de-vl-mercadoria + tt-documento-aux.valor-mercadoria
                       de-vl-invoice    = de-vl-invoice + tt-documento-aux.vl-invoice
                       de-tot-icm       = de-tot-icm + tt-documento-aux.de-tot-icm
                       de-nota-deb      = de-nota-deb + tt-documento-aux.nota-deb
                       de-tot-ii        = de-tot-ii + tt-documento-aux.de-tot-ii
                       de-tot-pis       = de-tot-pis + tt-documento-aux.de-tot-pis
                       de-tot-cof       = de-tot-cof + tt-documento-aux.de-tot-cof                   
                       de-impostos      = (tt-documento-aux.de-tot-icm + tt-documento-aux.nota-deb + tt-documento-aux.de-tot-ii + tt-documento-aux.de-tot-pis + tt-documento-aux.de-tot-cof) 
                       de-tot-impostos  = de-tot-impostos + de-impostos
                       de-tot-frete     = de-tot-frete + tt-documento-aux.valor-frete
                       de-tot-valor     = de-tot-valor + tt-documento-aux.tot-valor
                       l-imp            = yes.            
                
                put UNFORMATTED 
                    tt-documento-aux.ct-codigo                              AT 89
                    c-separador
                    tt-documento-aux.sc-codigo
                    c-separador
                    tt-documento-aux.cod-unid-negoc
                    c-separador
                    tt-documento-aux.valor-mercadoria                       FORMAT ">>,>>>,>>>,>>9.99" 
                    c-separador
                    tt-documento-aux.vl-invoice                             FORMAT ">>,>>>,>>>,>>9.99" 
                    c-separador
                    tt-documento-aux.valor-frete                            FORMAT ">>>,>>>,>>>,>>9.99"
                    c-separador
                    tt-documento-aux.tx-adm                                 FORMAT ">>>,>>>,>>>,>>9.99"
                    c-separador
                    tt-documento.valor-seguro
                    c-separador
                    tt-documento-aux.de-tot-icm                             FORMAT ">,>>>,>>>,>>9.99" 
                    c-separador
                    tt-documento-aux.nota-deb                               FORMAT ">,>>>,>>>,>>9.99" 
                    c-separador
                    tt-documento-aux.de-tot-ii                              FORMAT ">,>>>,>>>,>>9.99" 
                    c-separador
                    tt-documento-aux.de-tot-pis                             FORMAT ">,>>>,>>>,>>9.99" 
                    c-separador
                    tt-documento-aux.de-tot-cof                             FORMAT ">,>>>,>>>,>>9.99" 
                    c-separador
                    de-impostos                                             FORMAT ">,>>>,>>>,>>9.99" 
                    c-separador
                    tt-documento-aux.tot-valor                              FORMAT ">,>>>,>>>,>>9.99" 
                    c-separador.

                if  first(tt-documento-aux.ct-codigo) OR first(tt-documento-aux.sc-codigo) THEN
                    put UNFORMATTED 
                        tt-documento.c-nr-di                                FORMAT "x(20)" 
                        c-separador                                                                
                        tt-documento.data-di
                        c-separador
                        tt-documento.cgc                                    FORMAT "x(17)" 
                        c-separador
                        tt-documento.v-aliq                                 FORMAT ">>9.99"
                        c-separador
                        tt-documento.usuario                                FORMAT "x(8)"  
                        c-separador
                        tt-documento.dt-vencto                              FORMAT "99/99/9999"
                        c-separador                                      
                        tt-documento.dt-pagto                               FORMAT "99/99/9999"
                        c-separador                                      
                        tt-documento.esp-dupli                              FORMAT "x(2)"
                        c-separador
                        tt-documento.cotacao-emb
                        c-separador
                        tt-documento.cotacao-entrada
                        c-separador
                        tt-documento.log-atualizado FORMAT "Sim/NÆo"
                        c-separador
                        tt-documento.cod-depos
                        c-separador
                        tt-documento.modal-frete
                        c-separador
                        tt-documento.nome-transp.
                ELSE PUT ";;;;;;;;;;" tt-documento.log-atualizado FORMAT "Sim/NÆo" 
                         c-separador
                         tt-documento.cod-depos
                         c-separador
                         tt-documento.modal-frete
                         c-separador
                         tt-documento.nome-transp.
                
                /*--- chamado 37224, lista Chave de Acesso ---*/
                IF  tt-param.l-listar-chave THEN DO:
                    /*IF  tt-documento.cod-chave-aces-nf-eletro <> "" 
                    THEN PUT UNFORMATTED c-separador tt-documento.cod-chave-aces-nf-eletro FORMAT "99.9999.99.999.999/9999-99-99-999.999999999-999999999-99":U.*/
                    PUT UNFORMATTED c-separador "'" tt-documento.cod-chave-aces-nf-eletro FORMAT "X(60)":U.
                END. /* IF  tt-param.l-listar-chave THEN DO: */

                PUT UNFORMATTED c-separador 
                                tt-documento.estado FORMAT "X(2)":U
                                c-separador
                                IF AVAIL gt-tt-docum-est AND gt-tt-docum-est.log-situacao THEN "Sim" ELSE "NÆo".

                /*IF FIRST-OF(tt-documento-aux.r-documento) THEN*/
                    PUT UNFORMATTED c-separador
                        tt-documento.d-vl-bc-uf-dest        c-separador
                        tt-documento.d-vl-icms-uf-remet     c-separador
                        tt-documento.d-vl-icms-uf-dest      c-separador
                        tt-documento.d-vl-icms-fcp          c-separador
                        tt-documento.contrib-icms           c-separador
                        tt-documento.de-bc-pis-aces         c-separador
                        tt-documento.de-pis-aces            c-separador
                        tt-documento.de-bc-cofins-aces      c-separador  
                        tt-documento.de-cofins-aces         c-separador
                        tt-documento.de-vl-icms-simples-nac c-separador
                        tt-documento.nom-solicitante        c-separador
                        tt-documento.fm-materias            c-separador  
                        tt-documento.base-calc-icms         c-separador  
                        tt-documento.origem-item            c-separador  
                        tt-documento.cst-item               c-separador  
                        tt-documento.fcp                    c-separador  
                        tt-documento.cd-servico             c-separador                         
                        tt-documento.ds-servico             c-separador
                        tt-documento.cd-enquadramento       c-separador
                        tt-documento.ds-enquadramento       c-separador
                        tt-documento.cd-atividade-mei       c-separador
                        tt-documento.ds-atividade-mei       c-separador
                        string(tt-documento.r-docum-est).            


                
                IF NOT LAST-OF(tt-documento-aux.r-documento) THEN PUT SKIP.
            END. /* for each tt-documento-aux */   

            IF tt-param.imprime-financeiro THEN DO:
                ASSIGN i-linha-corrente = LINE-COUNT.
                
                RUN esp/apb/esapb777.p (INPUT tt-documento.serie-docto,
                                        INPUT tt-documento.nro-docto,
                                        INPUT tt-documento.cod-emitente,
                                        INPUT tt-documento.nat-operacao,
                                        INPUT 1,
                                        INPUT tt-param.ini-data,
                                        INPUT tt-param.fim-data,
                                        INPUT tt-param.cod-estabel-ini,
                                        INPUT tt-param.cod-estabel-fim,
                                        INPUT i-colunas).

                IF i-linha-corrente = LINE-COUNT THEN
                    PUT UNFORMATTED SKIP.
            END.
            ELSE 
                PUT UNFORMATTED SKIP. 


        end. /* FOR EACH tt-documento */

        if l-imp THEN DO:
            PUT UNFORMATTED SKIP(1)
                ";;;;;;;;;;Total:;"
                de-vl-mercadoria FORMAT ">>,>>>,>>>,>>9.99" ";"
                de-vl-invoice    format ">>,>>>,>>>,>>9.99" ";"
                de-tot-frete     format ">>,>>>,>>>,>>9.99" ";;;"
                de-tot-icm       format ">,>>>,>>>,>>9.99"  ";"
                de-nota-deb      format ">,>>>,>>>,>>9.99"  ";"
                de-tot-ii        format ">,>>>,>>>,>>9.99"  ";"
                de-tot-pis       format ">,>>>,>>>,>>9.99"  ";"
                de-tot-cof       format ">,>>>,>>>,>>9.99"  ";"
                de-tot-impostos  format ">,>>>,>>>,>>9.99"  ";"
                de-tot-valor     format ">,>>>,>>>,>>9.99"  ";" SKIP.
        END.
    end. /* if tt-param.imprime-conta  */

    IF  tt-param.imprime-conta = YES AND tt-param.imprime-financeiro THEN 
         RUN esp/apb/esapb777.p (INPUT "",
                                 INPUT "",
                                 INPUT 0,
                                 INPUT "",
                                 INPUT 2,
                                 INPUT tt-param.ini-data,
                                 INPUT tt-param.fim-data,
                                 INPUT tt-param.cod-estabel-ini,
                                 INPUT tt-param.cod-estabel-fim,
                                 INPUT i-colunas).

    PUT UNFORMATTED SKIP(1) "Resumo por NCM: " SKIP.

    FOR EACH tt-class:
        DISP tt-class.ncm
             tt-class.valor (total) WITH NO-BOX STREAM-IO.
    END.
END. /* PROCEDURE piRelatSintetico */

PROCEDURE piRelatAnalitico-por-faixa:
    def var i as int no-undo.
    bloco-nfe3:
    FOR EACH docum-est NO-LOCK                                   WHERE
             docum-est.cod-emitente >= tt-param.ini-cod-emitente AND
             docum-est.cod-emitente <= tt-param.fim-cod-emitente AND
             docum-est.cod-estabel  >= tt-param.cod-estabel-ini  and
             docum-est.cod-estabel  <= tt-param.cod-estabel-fim  and 
/*              docum-est.nat-operacao >= tt-param.ini-nat-operacao AND */
/*              docum-est.nat-operacao <= tt-param.fim-nat-operacao AND */
             docum-est.dt-trans     >= tt-param.ini-data         AND
             docum-est.dt-trans     <= tt-param.fim-data         AND
             docum-est.uf           >= tt-param.ini-uf           AND
             docum-est.uf           <= tt-param.fim-uf           AND
             docum-est.usuario      >= tt-param.ini-usuario      AND
             docum-est.usuario      <= tt-param.fim-usuario: 

        IF CAN-FIND(FIRST item-doc-est OF docum-est
                    WHERE item-doc-est.it-codigo    >= tt-param.it-codigo-ini
                      AND item-doc-est.it-codigo    <= tt-param.it-codigo-fim
                      AND item-doc-est.class-fiscal >= tt-param.classific-ini 
                      AND item-doc-est.class-fiscal <= tt-param.classific-fim
                      AND item-doc-est.cod-depos    >= tt-param.cod-depos-ini
                      AND item-doc-est.cod-depos    <= tt-param.cod-depos-fim) THEN
            {esp/rep/esrep007rp-b.i "bloco-nfe3"}
    END.
END.
PROCEDURE piRelatAnalitico-por-emitente:
    def var i as int no-undo.
    
    bloco-nfe4:
    FOR EACH tt-emit
       , EACH docum-est NO-LOCK                                   WHERE
             docum-est.cod-emitente  = tt-emit.cod-emitente      AND
             docum-est.cod-estabel  >= tt-param.cod-estabel-ini  and
             docum-est.cod-estabel  <= tt-param.cod-estabel-fim  and 
/*              docum-est.nat-operacao >= tt-param.ini-nat-operacao AND */
/*              docum-est.nat-operacao <= tt-param.fim-nat-operacao AND */
             docum-est.dt-trans     >= tt-param.ini-data         AND
             docum-est.dt-trans     <= tt-param.fim-data         AND
             docum-est.uf           >= tt-param.ini-uf           AND
             docum-est.uf           <= tt-param.fim-uf           AND
             docum-est.usuario      >= tt-param.ini-usuario      AND
             docum-est.usuario      <= tt-param.fim-usuario: 

        IF CAN-FIND(FIRST item-doc-est OF docum-est
                    WHERE item-doc-est.it-codigo    >= tt-param.it-codigo-ini
                      AND item-doc-est.it-codigo    <= tt-param.it-codigo-fim
                      AND item-doc-est.class-fiscal >= tt-param.classific-ini 
                      AND item-doc-est.class-fiscal <= tt-param.classific-fim
                      AND item-doc-est.cod-depos    >= tt-param.cod-depos-ini
                      AND item-doc-est.cod-depos    <= tt-param.cod-depos-fim) THEN
            {esp/rep/esrep007rp-b.i "bloco-nfe4"}
    END.
END.

PROCEDURE piRelatAnalitico:

    def var i as int no-undo.
    RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").
    
    IF  CAN-FIND(FIRST tt-emit) THEN
        RUN piRelatAnalitico-por-Emitente.
    ELSE
        RUN piRelatAnalitico-por-faixa.

    if not tt-param.imprime-conta then do:

        IF  tt-param.log-bc-aliq
        THEN IF NOT tt-param.l-listar-THC-II 
             THEN PUT UNFORMATTED "DT.Trans  ;DT.Emiss  ;Ser;N£mero   ;Est;Emitente;Nome        ;CNPJ            ;Embarque  ;UF;Cidade               ;Pais;Nat.   ;% ICMS ;Mot;Un Neg;Descri‡Æo                            ;Item     ;Descri‡Æo                            ;Narrativa                                         ;Class. Fis. ;% IPI ; % IPI NCM ;Dep;Localizacao;         OP;       Qtde;    Preco Unit;    Vlr Mercad;   Frete;Tx.Adm;Seguro;      ICMS;  ICMS Comp;       IPI;          II;         PIS;         COF;        Total;CST;DI             ;Data DI; NF. Sa¡da; Usu rio;Vl-Uni$$;Cotacao DI;Base Subs;Vlr Subs;Ins Estadual;Tipo Item;Origem Item;NF Atualizada;BC PIS;BC COF;% PIS;% COF;Pedido;Ordem;Parcela;C¢d Cond Pagto;Cond Pagto;Comprador;GE;Atendente;Vl BC UF Dest;Vl ICMS UF Remet;Aliq Inter;Aliq UF Dest;Vl ICMS UF Dest;% ICMS FCP;Vl ICMS FCP;DCR Item;Contrib.ICMS;Vl ICMS Simples Nac;Aliq ICMS Simples Nac;Vl BC ICMS Simples Nac;CSOSN;Solicitante;Reinf;Tipo Serv;Vl BC Retenc;VL Retenc;Base ICMS Compl;Vl ICMS Compl;;FM Mat.;Base Calc. ICMS;Origem;CST;FCP;C¢d. Serv.;Ds. Serv.;C¢d. Enquadr.; Ds. Enquadr;Cod.Atividade MEI;Desc.Atividade MEI;Sequencia;Cod Representante;Desc Representante;Cod Trib AM" SKIP.
             ELSE PUT UNFORMATTED "DT.Trans  ;DT.Emiss  ;Ser;N£mero   ;Est;Emitente;Nome        ;CNPJ            ;Embarque  ;UF;Cidade               ;Pais;Nat.   ;% ICMS ;Mot;Un Neg;Descri‡Æo                            ;Item     ;Descri‡Æo                            ;Narrativa                                         ;Class. Fis. ;% IPI ; % IPI NCM ;Dep;Localizacao;         OP;       Qtde;    Preco Unit;    Vlr Mercad;   Frete;Tx.Adm;Seguro;      ICMS;  ICMS Comp;       IPI;          II;         PIS;         COF;        Total;CST;DI             ;Data DI; NF. Sa¡da; Usu rio;Vl-Uni$$;Cotacao DI;Base Subs;Vlr Subs;Ins Estadual;Tipo Item;Origem Item;NF Atualizada;THC;% II;Adi‡Æo;Seq Imp;Valor II;BC PIS;BC COF;% PIS;% COF;Pedido;Ordem;Parcela;C¢d Cond Pagto;Cond Pagto;Comprador;GE;Atendente;Vl BC UF Dest;Vl ICMS UF Remet;Aliq Inter;Aliq UF Dest;Vl ICMS UF Dest;% ICMS FCP;Vl ICMS FCP;DCR Item;Contrib.ICMS;Vl ICMS Simples Nac;Aliq ICMS Simples Nac;Vl BC ICMS Simples Nac;CSOSN;Solicitante;Reinf;Tipo Serv;Vl BC Retenc;VL Retenc;Base ICMS Compl;Vl ICMS Compl;;FM Mat.;Base Calc. ICMS;Origem;CST;FCP;C¢d. Serv.;Ds. Serv.;C¢d. Enquadr.; Ds. Enquadr;Cod.Atividade MEI;Desc.Atividade MEI;Sequencia;Cod Representante;Desc Representante;Cod Trib AM" SKIP.
        ELSE IF NOT tt-param.l-listar-THC-II 
             THEN PUT UNFORMATTED "DT.Trans  ;DT.Emiss  ;Ser;N£mero   ;Est;Emitente;Nome        ;CNPJ            ;Embarque  ;UF;Cidade               ;Pais;Nat.   ;% ICMS ;Mot;Un Neg;Descri‡Æo                            ;Item     ;Descri‡Æo                            ;Narrativa                                         ;Class. Fis. ;% IPI ; % IPI NCM ;Dep;Localizacao;         OP;       Qtde;    Preco Unit;    Vlr Mercad;   Frete;Tx.Adm;Seguro;      ICMS;  ICMS Comp;       IPI;          II;         PIS;         COF;        Total;CST;DI             ;Data DI; NF. Sa¡da; Usu rio;Vl-Uni$$;Cotacao DI;Base Subs;Vlr Subs;Ins Estadual;Tipo Item;Origem Item;NF Atualizada;Pedido;Ordem;Parcela;C¢d Cond Pagto;Cond Pagto;Comprador;GE;Atendente;Vl BC UF Dest;Vl ICMS UF Remet;Aliq Inter;Aliq UF Dest;Vl ICMS UF Dest;% ICMS FCP;Vl ICMS FCP; DCR Item;Contrib.ICMS;Vl ICMS Simples Nac;Aliq ICMS Simples Nac;Vl BC ICMS Simples Nac;CSOSN;Solicitante;Reinf;Tipo Serv;Vl BC Retenc;VL Retenc;Base ICMS Compl;Vl ICMS Compl;FM Mat.;Base Calc. ICMS;Origem;CST;FCP;C¢d. Serv.;Ds. Serv.;C¢d. Enquadr.; Ds. Enquadr;Cod.Atividade MEI;Desc.Atividade MEI;Sequencia;Cod Representante;Desc Representante;Cod Trib AM" SKIP.
             ELSE PUT UNFORMATTED "DT.Trans  ;DT.Emiss  ;Ser;N£mero   ;Est;Emitente;Nome        ;CNPJ            ;Embarque  ;UF;Cidade               ;Pais;Nat.   ;% ICMS ;Mot;Un Neg;Descri‡Æo                            ;Item     ;Descri‡Æo                            ;Narrativa                                         ;Class. Fis. ;% IPI ; % IPI NCM ;Dep;Localizacao;         OP;       Qtde;    Preco Unit;    Vlr Mercad;   Frete;Tx.Adm;Seguro;      ICMS;  ICMS Comp;       IPI;          II;         PIS;         COF;        Total;CST;DI             ;Data DI; NF. Sa¡da; Usu rio;Vl-Uni$$;Cotacao DI;Base Subs;Vlr Subs;Ins Estadual;Tipo Item;Origem Item;NF Atualizada;THC;% II;Adi‡Æo;Seq Imp;Valor II;Pedido;Ordem;Parcela;C¢d Cond Pagto;Cond Pagto;Comprador;Atendente;GE;Vl BC UF Dest;Vl ICMS UF Remet;Aliq Inter;Aliq UF Dest;Vl ICMS UF Dest;% ICMS FCP;Vl ICMS FCP;DCR Item;Contrib.ICMS;Vl ICMS Simples Nac;Aliq ICMS Simples Nac;Vl BC ICMS Simples Nac;CSOSN;Solicitante;Reinf;Tipo Serv;Vl BC Retenc;VL Retenc;Base ICMS Compl;Vl ICMS Compl;FM Mat.;Base Calc. ICMS;Origem;CST;FCP;C¢d. Serv.;Ds. Serv.;C¢d. Enquadr.; Ds. Enquadr;Cod.Atividade MEI;Desc.Atividade MEI;Sequencia;Cod Representante;Desc Representante;Cod Trib AM" SKIP.
    
        FOR EACH tt-documento
            break by tt-documento.dt-trans:

            RUN pi-acompanhar IN h-acomp (INPUT "Listando Nota: " + tt-documento.nro-docto + " - Data: " + STRING(tt-documento.dt-trans,"99/99/9999")).

            if not can-find (first tt-documento-aux
                             where tt-documento-aux.r-documento = recid(tt-documento)) then next.
                                     
            ACCUMULATE tt-documento.valor-mercadoria   (TOTAL)
                       tt-documento.valor-frete        (TOTAL)
                       tt-documento.icm-deb-cre        (TOTAL)
                       tt-documento.icm-complem        (TOTAL)
                       tt-documento.nota-deb           (TOTAL)
                       tt-documento.de-tot-ii          (TOTAL)
                       tt-documento.de-tot-pis         (TOTAL)
                       tt-documento.de-tot-cof         (TOTAL)
                       tt-documento.tot-valor          (TOTAL)
                       tt-documento.d-vl-bc-uf-dest    (TOTAL)
                       tt-documento.d-vl-icms-fcp      (TOTAL)
                       tt-documento.d-vl-icms-uf-dest  (TOTAL)
                       tt-documento.d-vl-icms-uf-remet (TOTAL).
        
            PUT UNFORMATTED 
                 tt-documento.dt-trans                  FORMAT "99/99/9999"
                 c-separador
                 tt-documento.dt-emissao                FORMAT "99/99/9999"    
                 c-separador
                 tt-documento.serie-docto                        
                 c-separador
                 tt-documento.nro-docto                 FORMAT "9999999999"      
                 c-separador
                 tt-documento.cod-estab                 format "x(3)"
                 c-separador
                 tt-documento.cod-emitente                       
                 c-separador
                 tt-documento.nome-abrev                FORMAT "x(12)"         
                 c-separador
                 tt-documento.cgc                       FORMAT "x(17)"                          
                 c-separador
                 tt-documento.c-emb                     FORMAT "x(10)"
                 c-separador
                 tt-documento.estado                    FORMAT "x(2)"
                 c-separador
                 tt-documento.cidade                    FORMAT "x(21)"    
                 c-separador
                 tt-documento.pais                       FORMAT "x(21)"    
                 c-separador
                 tt-documento.nat-operacao              FORMAT "999xxx"   
                 c-separador
                 tt-documento.v-aliq                    FORMAT ">,>>9.99"  
                 c-separador
                 tt-documento.cod-devolucao             FORMAT "999"                  
                 c-separador
                 tt-documento.cod_unid_negoc            FORMAT "x(3)":U
                 c-separador
                 tt-documento.des_unid_negoc            FORMAT "x(40)":U
                 c-separador
                 tt-documento.it-codigo                 FORMAT "x(10)"                       
                 c-separador
                 tt-documento.descricao-1               
                 tt-documento.descricao-2
                 c-separador
                 tt-documento.narrativa                 FORMAT "x(2000)"
                 c-separador
                 tt-documento.class-fiscal              FORMAT "9999.99.99" 
                 c-separador
                 tt-documento.aliquota-ipi              FORMAT "->,>>9.99" 
                 c-separador             
                 tt-documento.aliq-ipi-ncm              FORMAT "->,>>9.99" 
                 c-separador             
                 tt-documento.cod-depos                 FORMAT "xxx"                  
                 c-separador
                 tt-documento.cod-localiz
                 c-separador
                 tt-documento.nr-ord-prod               FORMAT ">>>,>>>,>>9"
                 c-separador
                 tt-documento.quantidade                FORMAT "->,>>>,>>9.99" 
                 c-separador
                 tt-documento.preco-unit                format "->>>,>>>,>>9.99999" 
                 c-separador
                 tt-documento.valor-mercadoria          format "->>>,>>>,>>9.99" 
                 c-separador
                 tt-documento.valor-frete 
                 c-separador
                 tt-documento.tx-adm
                 c-separador
                 tt-documento.valor-seguro
                 c-separador
                 tt-documento.icm-deb-cre               FORMAT "->>>,>>9.99" 
                 c-separador
                 tt-documento.icm-complem               FORMAT "->>>,>>9.99" 
                 c-separador
                 tt-documento.nota-deb                  FORMAT "->>>,>>9.99" 
                 c-separador
                 tt-documento.de-tot-ii                 FORMAT "->>,>>>,>>9.99" 
                 c-separador
                 tt-documento.de-tot-pis                FORMAT "->>,>>>,>>9.99" 
                 c-separador
                 tt-documento.de-tot-cof                FORMAT "->>,>>>,>>9.99" 
                 c-separador
                 tt-documento.tot-valor                 FORMAT "->>>,>>>,>>9.99"
                 c-separador
                 tt-documento.cod-tributac
                 c-separador
                 tt-documento.c-nr-di                                FORMAT "x(20)" 
                 c-separador
                 tt-documento.data-di
                 c-separador
                 tt-documento.nro-comp                  FORMAT "x(10)" 
                 c-separador
                 tt-documento.usuario                   FORMAT "x(8)"
                 c-separador
                 tt-documento.preco-unit-dl                          
                 c-separador
                 tt-documento.cotacao-di                
                 c-separador 
                 tt-documento.base-subs  
                 c-separador
                 tt-documento.vl-subs    
                 c-separador
                 tt-documento.ins-estadual
                 c-separador.

            FIND item-uni-estab
                WHERE item-uni-estab.cod-estabel = tt-documento.cod-estabel
                  AND item-uni-estab.it-codigo   = tt-documento.it-codigo
                NO-LOCK NO-ERROR.
            IF AVAIL item-uni-estab THEN DO:
                CASE substring(item-uni-estab.char-1, 133, 1) :
                   when "0" THEN PUT "0 - Mercadoria para Revenda".
                   when "1" THEN PUT "1 - Materia-prima".
                   when "2" THEN PUT "2 - Embalagem".
                   when "3" THEN PUT "3 - Produto em Processo".
                   when "4" THEN PUT "4 - Produto Acabado".
                   when "5" THEN PUT "5 - Subproduto".
                   when "6" THEN PUT "6 - Produto Intermediario".
                   when "7" THEN PUT "7 - Material de Uso e Consumo".
                   when "8" THEN PUT "8 - Ativo Imobilizado".
                   when "9" THEN PUT "9 - Servicos".
                   when "a" THEN PUT "10 - Outros Insumos".
                   when "b" THEN PUT "99 - Outras".
                   OTHERWISE PUT "NÆo Informado".
                END.
            END.

            PUT UNFORMATTED c-separador
                            tt-documento.cod-origem-item
                            c-separador
                            tt-documento.log-atualizado FORMAT "Sim/NÆo".

            IF  tt-param.l-listar-THC-II THEN DO:
                PUT UNFORMATTED c-separador
                                tt-documento.val-desp-THC FORMAT "->>>,>>>,>>9.99":U
                                c-separador
                                tt-documento.perc-II FORMAT ">>9.99":U
                                c-separador 
                                tt-documento.num-adic
                                c-separador 
                                tt-documento.num-seq-import
                                c-separador
                                tt-documento.val-impto-import FORMAT "->>>,>>>,>>9.99":U.
            END. /* IF  tt-param.l-listar-THC-II THEN DO: */
            
            IF  tt-param.log-bc-aliq THEN DO:
                PUT UNFORMATTED c-separador
                                tt-documento.val-base-pis   
                                c-separador
                                tt-documento.val-base-cofins
                                c-separador
                                tt-documento.val-aliq-pis   
                                c-separador
                                tt-documento.val-aliq-cofins.
            END.

            PUT UNFORMATTED c-separador
                            tt-documento.num-pedido
                            c-separador
                            tt-documento.numero-ordem
                            c-separador
                            tt-documento.parcela
                            c-separador
                            tt-documento.cod-cond-pag
                            c-separador
                            tt-documento.descricao-cond-pag
                            c-separador
                            tt-documento.cod-comprado
                            c-separador
                            tt-documento.ge-codigo
                            c-separador
                            tt-documento.atendente
                            c-separador
                            tt-documento.d-vl-bc-uf-dest    c-separador
                            tt-documento.d-vl-icms-uf-remet c-separador
                            tt-documento.d-aliq-inter       c-separador
                            tt-documento.d-aliq-uf-dest     c-separador
                            tt-documento.d-vl-icms-uf-dest  c-separador
                            tt-documento.d-perc-icms-fcp    c-separador
                            tt-documento.d-vl-icms-fcp      c-separador
                            tt-documento.cod-dcr-item       c-separador
                            tt-documento.contrib-icms              c-separador 
                            tt-documento.de-vl-icms-simples-nac    c-separador
                            tt-documento.de-aliq-icms-simples-nac  c-separador 
                            tt-documento.de-base-icms-simples-nac  c-separador 
                            tt-documento.csosn c-separador 
                            tt-documento.nom-solicitante
                            c-separador
                            tt-documento.reinf 
                            c-separador
                            tt-documento.tipo-serv
                            c-separador
                            tt-documento.vl-bc-retenc
                            c-separador
                            tt-documento.vl-retenc
                            c-separador
                            tt-documento.vl-base-icm-compl
                            c-separador
                            tt-documento.vl-icm-compl     
                            c-separador
                            tt-documento.fm-materias   
                            c-separador
                            tt-documento.base-calc-icms
                            c-separador
                            tt-documento.origem-item   
                            c-separador
                            tt-documento.cst-item   
                            c-separador
                            tt-documento.fcp      
                            c-separador
                            tt-documento.cd-servico             
                            c-separador                         
                            tt-documento.ds-servico            
                            c-separador
                            tt-documento.cd-enquadramento       
                            c-separador
                            tt-documento.ds-enquadramento
                            c-separador

                            tt-documento.cd-atividade-mei       
                            c-separador
                            tt-documento.ds-atividade-mei
                            c-separador                  

                            tt-documento.sequencia
                            c-separador
                
                            tt-documento.cod-repres
                            c-separador
                            tt-documento.desc-repres
                            c-separador
                            tt-documento.cod-trib-am
                            c-separador.

            PUT SKIP.

            IF LAST (tt-documento.dt-trans) THEN DO:
                PUT UNFORMATTED SKIP(1)
                    ";;;;;;;;;;;;;;;;;;;;;;;;;;;Total: ;"
                    accum total tt-documento.valor-mercadoria   FORMAT ">>>,>>>,>>9.99"     ";"
                    accum total tt-documento.valor-frete        FORMAT ">>>,>>>,>>9.99"     ";;;"
                    accum total tt-documento.icm-deb-cre        FORMAT ">>>,>>>,>>9.99"     ";"
                    accum total tt-documento.icm-complem        FORMAT ">>>,>>>,>>9.99"     ";"
                    accum total tt-documento.nota-deb           FORMAT ">>>,>>>,>>9.99"     ";"
                    accum total tt-documento.de-tot-ii          FORMAT ">>>,>>>,>>9.99"     ";"
                    accum total tt-documento.de-tot-pis         FORMAT ">>>,>>>,>>9.99"     ";"
                    accum total tt-documento.de-tot-cof         FORMAT ">>>,>>>,>>9.99"     ";"
                    accum total tt-documento.tot-valor          FORMAT ">>>,>>>,>>>,>>9.99" ";;;;;" 
                    ACCUM TOTAL tt-documento.d-vl-bc-uf-dest    FORMAT "->>>>>>>>>>>9.99"   ";;;;"
                    ACCUM TOTAL tt-documento.d-vl-icms-uf-remet FORMAT "->>>>>>>>>>>9.99"   ";"
                    ACCUM TOTAL tt-documento.d-vl-icms-uf-dest  FORMAT "->>>>>>>>>>>9.99"   ";"
                    ACCUM TOTAL tt-documento.d-vl-icms-fcp      FORMAT "->>>>>>>>>>>9.99"   ";" SKIP.
            end.
        END.
    end.    
    else do:
        for each tt-documento:

                RUN pi-acompanhar IN h-acomp (INPUT "Listando Nota: " + tt-documento.nro-docto + " - Data: " + STRING(tt-documento.dt-trans,"99/99/9999")).

                for each tt-documento-aux use-index codigo2
                    where tt-documento-aux.r-documento = recid(tt-documento)
                    and   tt-documento-aux.it-codigo   = tt-documento.it-codigo
                    break by tt-documento-aux.ct-codigo
                          by tt-documento-aux.sc-codigo:
                      
                assign de-proporcao = if tt-documento.tot-valor > 0 then tt-documento-aux.tot-valor / tt-documento.tot-valor else 0
                       tt-documento-aux.valor-mercadoria = tt-documento.valor-mercadoria * de-proporcao
                       tt-documento-aux.vl-invoice       = tt-documento.vl-invoice * de-proporcao
                       tt-documento-aux.valor-frete      = tt-documento.valor-frete * de-proporcao
                       tt-documento-aux.tx-adm           = tt-documento.tx-adm * de-proporcao
                       tt-documento-aux.de-tot-icm       = tt-documento.de-tot-icm * de-proporcao
                       tt-documento-aux.de-tot-ii        = tt-documento.de-tot-ii * de-proporcao
                       tt-documento-aux.de-tot-pis       = tt-documento.de-tot-pis * de-proporcao
                       tt-documento-aux.de-tot-cof       = tt-documento.de-tot-cof * de-proporcao
                       tt-documento-aux.nota-deb         = tt-documento.nota-deb * de-proporcao
                       tt-documento-aux.tot-valor        = tt-documento.tot-valor * de-proporcao
                       tt-documento-aux.quantidade       = tt-documento.quantidade * de-proporcao
                       tt-documento-aux.icm-deb-cre      = tt-documento.icm-deb-cre * de-proporcao
                       tt-documento-aux.icm-complem      = tt-documento.icm-complem * de-proporcao
                       tt-documento-aux.valor-frete      = tt-documento.valor-frete * de-proporcao
                       tt-documento-aux.valor-seguro     = tt-documento.valor-seguro * de-proporcao.
                       
                accumulate tt-documento-aux.valor-mercadoria (TOTAL)
                           tt-documento-aux.vl-invoice       (TOTAL)
                           tt-documento-aux.valor-frete      (TOTAL)
                           tt-documento-aux.tx-adm           (TOTAL)
                           tt-documento-aux.de-tot-icm       (TOTAL)
                           tt-documento-aux.de-tot-ii        (TOTAL)
                           tt-documento-aux.de-tot-pis       (TOTAL)
                           tt-documento-aux.de-tot-cof       (TOTAL)
                           tt-documento-aux.nota-deb         (TOTAL)
                           tt-documento-aux.tot-valor        (TOTAL)
                           tt-documento-aux.quantidade       (TOTAL)
                           tt-documento-aux.icm-deb-cre      (TOTAL)
                           tt-documento-aux.icm-complem      (TOTAL).
                           
                if  last(tt-documento-aux.ct-codigo) OR last(tt-documento-aux.sc-codigo) then do:
                    find last b-tt-documento-aux 
                        where b-tt-documento-aux.r-documento = tt-documento-aux.r-documento no-error.
                    assign b-tt-documento-aux.valor-mercadoria = b-tt-documento-aux.valor-mercadoria +
                           tt-documento.valor-mercadoria - (accum total tt-documento-aux.valor-mercadoria)
                           b-tt-documento-aux.vl-invoice       = b-tt-documento-aux.vl-invoice +
                           tt-documento.vl-invoice - (accum total tt-documento-aux.vl-invoice)
                           b-tt-documento-aux.valor-frete      = b-tt-documento-aux.valor-frete +
                           tt-documento.valor-frete - (accum total tt-documento-aux.valor-frete)
                           b-tt-documento-aux.tx-adm           = b-tt-documento-aux.tx-adm +
                           tt-documento.tx-adm - (accum total tt-documento-aux.tx-adm)
                           b-tt-documento-aux.de-tot-icm       = b-tt-documento-aux.de-tot-icm +
                           tt-documento.de-tot-icm - (accum total tt-documento-aux.de-tot-icm)
                           b-tt-documento-aux.de-tot-ii        = b-tt-documento-aux.de-tot-ii +
                           tt-documento.de-tot-ii - (accum total tt-documento-aux.de-tot-ii)
                           b-tt-documento-aux.de-tot-pis       = b-tt-documento-aux.de-tot-pis +
                           tt-documento.de-tot-pis - (accum total tt-documento-aux.de-tot-pis)
                           b-tt-documento-aux.de-tot-cof       = b-tt-documento-aux.de-tot-cof +
                           tt-documento.de-tot-cof - (accum total tt-documento-aux.de-tot-cof)
                           b-tt-documento-aux.nota-deb         = b-tt-documento-aux.nota-deb +
                           tt-documento.nota-deb - (accum total tt-documento-aux.nota-deb)
                           b-tt-documento-aux.quantidade       = b-tt-documento-aux.quantidade +
                           tt-documento.quantidade - (accum total tt-documento-aux.quantidade)
                           b-tt-documento-aux.icm-deb-cre      = b-tt-documento-aux.icm-deb-cre +
                           tt-documento.icm-deb-cre - (accum total tt-documento-aux.icm-deb-cre)
                           b-tt-documento-aux.icm-complem      = b-tt-documento-aux.icm-complem +
                           tt-documento.icm-complem - (accum total tt-documento-aux.icm-complem)
                           b-tt-documento-aux.tot-valor        = b-tt-documento-aux.tot-valor +
                           tt-documento.tot-valor - (accum total tt-documento-aux.tot-valor).
                end.                       
            end.
        end.    

        IF tt-param.imprime-financeiro THEN DO:
           //ASSIGN i-colunas = 69.  COMENTADO ISAC - 25/01/21
           ASSIGN i-colunas = 71.

           IF  tt-param.log-bc-aliq
           THEN IF NOT tt-param.l-listar-THC-II 
                THEN PUT UNFORMATTED "DT.Trans  ;DT.Emiss  ;Ser;N£mero   ;Est;Emitente;Nome        ;CNPJ            ;Embarque  ;UF;Cidade               ;Pais;Nat.    ;% ICMS;Mot;Un Neg;Descri‡Æo                            ;Item     ;Descri‡Æo                            ;Narrativa                                         ;Class. Fis.; % IPI ; % IPI NCM ;Dep;Localizacao;   Conta;Centro Custo;Unid. Negoc;         OP;       Qtde;    Preco Unit;    Vlr Mercad;  Frete;Tx.Adm;Seguro;       ICMS;  ICMS Comp;       IPI;          II;         PIS;         COF;        Total;DI             ;Data DI; NF. Sa¡da;  Usu rio; Dt.Vencto; Dt.Pagto; Esp.Dupl.;Origem Item;NF Atualizada;Pedido;Ordem;Parcela;C¢d Cond Pagto;Cond Pagto;Comprador;GE;BC PIS;BC COF;% PIS;% COF;DCR Item;Contrib.ICMS;FM Mat.;Base Calc. ICMS;Origem;CST;FCP;C¢d. Serv.;Ds. Serv.;C¢d. Enquadr.; Ds. Enquadr;Cod.Atividade MEI;Desc.Atividade MEI;Sequencia;Pagamento;Estab;Fornecedor;Especie;Serie;Titulo;Parcela;Nome;Conta;CCusto;Banco;Agencia;Dig Agencia;Conta Corrente;Dig Conta Corrente;Data Movimento;Modo Pagamento;Portador;Border“;Cheque;Valor Movimento;Contra AN ?;Hist¢rico" SKIP.
                ELSE PUT UNFORMATTED "DT.Trans  ;DT.Emiss  ;Ser;N£mero   ;Est;Emitente;Nome        ;CNPJ            ;Embarque  ;UF;Cidade               ;Pais;Nat.    ;% ICMS;Mot;Un Neg;Descri‡Æo                            ;Item     ;Descri‡Æo                            ;Narrativa                                         ;Class. Fis.; % IPI ; % IPI NCM ;Dep;Localizacao;   Conta;Centro Custo;Unid. Negoc;         OP;       Qtde;    Preco Unit;    Vlr Mercad;  Frete;Tx.Adm;Seguro;       ICMS;  ICMS Comp;       IPI;          II;         PIS;         COF;        Total;DI             ;Data DI; NF. Sa¡da;  Usu rio; Dt.Vencto; Dt.Pagto; Esp.Dupl.;Origem Item;NF Atualizada;Pedido;Ordem;Parcela;C¢d Cond Pagto;Cond Pagto;Comprador;GE;THC;% II;BC PIS;BC COF;% PIS;% COF;DCR Item;Contrib.ICMS;FM Mat.;Base Calc. ICMS;Origem;CST;FCP;C¢d. Serv.;Ds. Serv.;C¢d. Enquadr.; Ds. Enquadr;Cod.Atividade MEI;Desc.Atividade MEI;Sequencia;Pagamento;Estab;Fornecedor;Especie;Serie;Titulo;Parcela;Nome;Conta;CCusto;Banco;Agencia;Dig Agencia;Conta Corrente;Dig Conta Corrente;Data Movimento;Modo Pagamento;Portador;Border“;Cheque;Valor Movimento;Contra AN ?;Hist¢rico" SKIP.
           ELSE IF NOT tt-param.l-listar-THC-II 
                THEN PUT UNFORMATTED "DT.Trans  ;DT.Emiss  ;Ser;N£mero   ;Est;Emitente;Nome        ;CNPJ            ;Embarque  ;UF;Cidade               ;Pais;Nat.    ;% ICMS;Mot;Un Neg;Descri‡Æo                            ;Item     ;Descri‡Æo                            ;Narrativa                                         ;Class. Fis.; % IPI ; % IPI NCM ;Dep;Localizacao;   Conta;Centro Custo;Unid. Negoc;         OP;       Qtde;    Preco Unit;    Vlr Mercad;  Frete;Tx.Adm;Seguro;       ICMS;  ICMS Comp;       IPI;          II;         PIS;         COF;        Total;DI             ;Data DI; NF. Sa¡da;  Usu rio; Dt.Vencto; Dt.Pagto; Esp.Dupl.;Origem Item;NF Atualizada;Pedido;Ordem;Parcela;C¢d Cond Pagto;Cond Pagto;Comprador;GE;DCR Item;Contrib.ICMS;FM Mat.;Base Calc. ICMS;Origem;CST;FCP;C¢d. Serv.;Ds. Serv.;C¢d. Enquadr.; Ds. Enquadr;Cod.Atividade MEI;Desc.Atividade MEI;Sequencia;Pagamento;Estab;Fornecedor;Especie;Serie;Titulo;Parcela;Nome;Conta;CCusto;Banco;    Agencia;Dig Agencia;Conta Corrente;Dig Conta Corrente;Data Movimento;Modo Pagamento;Portador;Border“;Cheque;Valor Movimento;Contra AN ?;Hist¢rico" SKIP.
                ELSE PUT UNFORMATTED "DT.Trans  ;DT.Emiss  ;Ser;N£mero   ;Est;Emitente;Nome        ;CNPJ            ;Embarque  ;UF;Cidade               ;Pais;Nat.    ;% ICMS;Mot;Un Neg;Descri‡Æo                            ;Item     ;Descri‡Æo                            ;Narrativa                                         ;Class. Fis.; % IPI ; % IPI NCM ;Dep;Localizacao;   Conta;Centro Custo;Unid. Negoc;         OP;       Qtde;    Preco Unit;    Vlr Mercad;  Frete;Tx.Adm;Seguro;       ICMS;  ICMS Comp;       IPI;          II;         PIS;         COF;        Total;DI             ;Data DI; NF. Sa¡da;  Usu rio; Dt.Vencto; Dt.Pagto; Esp.Dupl.;Origem Item;NF Atualizada;Pedido;Ordem;Parcela;C¢d Cond Pagto;Cond Pagto;Comprador;GE;THC;% II;DCR Item;Contrib.ICMS;FM Mat.;Base Calc. ICMS;Origem;CST;FCP;C¢d. Serv.;Ds. Serv.;C¢d. Enquadr.; Ds. Enquadr;Cod.Atividade MEI;Desc.Atividade MEI;Sequencia;Pagamento;Estab;Fornecedor;Especie;Serie;Titulo;Parcela;Nome;Conta;CCusto;Banco;Agencia;Dig Agencia;Conta Corrente;Dig Conta Corrente;Data Movimento;Modo Pagamento;Portador;Border“;Cheque;Valor Movimento;Contra AN ?;Hist¢rico" SKIP.
        END.
        ELSE
            IF  tt-param.log-bc-aliq
            THEN IF NOT tt-param.l-listar-THC-II 
                 THEN PUT UNFORMATTED "DT.Trans  ;DT.Emiss  ;Ser;N£mero   ;Est;Emitente;Nome        ;CNPJ            ;Embarque  ;UF;Cidade               ;Pais;Nat.    ;% ICMS;Mot;Un Neg;Descri‡Æo                            ;Item     ;Descri‡Æo                            ;Narrativa                                         ;Class. Fis.; % IPI ; % IPI NCM ;Dep;Localizacao;   Conta;Centro Custo;Unid. Negoc;         OP;       Qtde;    Preco Unit;    Vlr Mercad;  Frete;Tx.Adm;Seguro;       ICMS;  ICMS Comp;       IPI;          II;         PIS;         COF;        Total;DI             ;Data DI; NF. Sa¡da;  Usu rio; Dt.Vencto; Dt.Pagto; Esp.Dupl;Origem Item;NF Atualizada;Pedido;Ordem;Parcela;C¢d Cond Pagto;Cond Pagto;Comprador;GE;BC PIS;BC COF;% PIS;% COF;DCR Item;Contrib.ICMS;Vl Icms Simp Nac;Ali Icms Simp Nac;Base Icms Simp Nac;CSOSN;Solicitante;Reinf;Tipo Serv;Vl BC Retenc;VL Retenc;Base ICMS Compl;Vl ICMS Compl;FM Mat.;Base Calc. ICMS;Origem;CST;FCP;C¢d. Serv.;Ds. Serv.;C¢d. Enquadr.; Ds. Enquadr;Cod.Atividade MEI;Desc.Atividade MEI;Sequencia" SKIP.
                 ELSE PUT UNFORMATTED "DT.Trans  ;DT.Emiss  ;Ser;N£mero   ;Est;Emitente;Nome        ;CNPJ            ;Embarque  ;UF;Cidade               ;Pais;Nat.    ;% ICMS;Mot;Un Neg;Descri‡Æo                            ;Item     ;Descri‡Æo                            ;Narrativa                                         ;Class. Fis.; % IPI ; % IPI NCM ;Dep;Localizacao;   Conta;Centro Custo;Unid. Negoc;         OP;       Qtde;    Preco Unit;    Vlr Mercad;  Frete;Tx.Adm;Seguro;       ICMS;  ICMS Comp;       IPI;          II;         PIS;         COF;        Total;DI             ;Data DI; NF. Sa¡da;  Usu rio; Dt.Vencto; Dt.Pagto; Esp.Dupl;Origem Item;NF Atualizada;Pedido;Ordem;Parcela;C¢d Cond Pagto;Cond Pagto;Comprador;GE;THC;% II;BC PIS;BC COF;% PIS;% COF;DCR Item;Contrib.ICMS;Vl Icms Simp Nac;Ali Icms Simp Nac;Base Icms Simp Nac;CSOSN;Solicitante;Reinf;Tipo Serv;Vl BC Retenc;VL Retenc;Base ICMS Compl;Vl ICMS Compl;FM Mat.;Base Calc. ICMS;Origem;CST;FCP;C¢d. Serv.;Ds. Serv.;C¢d. Enquadr.; Ds. Enquadr;Cod.Atividade MEI;Desc.Atividade MEI;Sequencia" SKIP.
            ELSE IF NOT tt-param.l-listar-THC-II 
                 THEN PUT UNFORMATTED "DT.Trans  ;DT.Emiss  ;Ser;N£mero   ;Est;Emitente;Nome        ;CNPJ            ;Embarque  ;UF;Cidade               ;Pais;Nat.    ;% ICMS;Mot;Un Neg;Descri‡Æo                            ;Item     ;Descri‡Æo                            ;Narrativa                                         ;Class. Fis.; % IPI ; % IPI NCM ;Dep;Localizacao;   Conta;Centro Custo;Unid. Negoc;         OP;       Qtde;    Preco Unit;    Vlr Mercad;  Frete;Tx.Adm;Seguro;       ICMS;  ICMS Comp;       IPI;          II;         PIS;         COF;        Total;DI             ;Data DI; NF. Sa¡da;  Usu rio; Dt.Vencto; Dt.Pagto; Esp.Dupl;Origem Item;NF Atualizada;Pedido;Ordem;Parcela;C¢d Cond Pagto;Cond Pagto;Comprador;GE;DCR Item;Contrib.ICMS;Vl Icms Simp Nac;Ali Icms Simp Nac;Base Icms Simp Nac;CSOSN;Solicitante;Reinf;Tipo Serv;Vl BC Retenc;VL Retenc;Base ICMS Compl;Vl ICMS Compl;FM Mat.;Base Calc. ICMS;Origem;CST;FCP;C¢d. Serv.;Ds. Serv.;C¢d. Enquadr.; Ds. Enquadr;Cod.Atividade MEI;Desc.Atividade MEI;Sequencia" SKIP.
                 ELSE PUT UNFORMATTED "DT.Trans  ;DT.Emiss  ;Ser;N£mero   ;Est;Emitente;Nome        ;CNPJ            ;Embarque  ;UF;Cidade               ;Pais;Nat.    ;% ICMS;Mot;Un Neg;Descri‡Æo                            ;Item     ;Descri‡Æo                            ;Narrativa                                         ;Class. Fis.; % IPI ; % IPI NCM ;Dep;Localizacao;   Conta;Centro Custo;Unid. Negoc;         OP;       Qtde;    Preco Unit;    Vlr Mercad;  Frete;Tx.Adm;Seguro;       ICMS;  ICMS Comp;       IPI;          II;         PIS;         COF;        Total;DI             ;Data DI; NF. Sa¡da;  Usu rio; Dt.Vencto; Dt.Pagto; Esp.Dupl;Origem Item;NF Atualizada;Pedido;Ordem;Parcela;C¢d Cond Pagto;Cond Pagto;Comprador;GE;THC;% II;DCR Item;Contrib.ICMS;Vl Icms Simp Nac;Ali Icms Simp Nac;Base Icms Simp Nac;CSOSN;Solicitante;Reinf;Tipo Serv;Vl BC Retenc;VL Retenc;Base ICMS Compl;Vl ICMS Compl;FM Mat.;Base Calc. ICMS;Origem;CST;FCP;C¢d. Serv.;Ds. Serv.;C¢d. Enquadr.; Ds. Enquadr;Cod.Atividade MEI;Desc.Atividade MEI;Sequencia" SKIP.
                                                                                                                                                                                                                                                                            

                 
        for each tt-documento break by tt-documento.dt-trans BY tt-documento.r-docum-est:
            RUN pi-acompanhar IN h-acomp (INPUT "Listando Nota: " + tt-documento.nro-docto + " - Data: " + STRING(tt-documento.dt-trans,"99/99/9999")).
            if not can-find (first tt-documento-aux
                             where tt-documento-aux.r-documento = recid(tt-documento)) then next.        
        
            accumulate tt-documento.valor-mercadoria   (TOTAL)
                       tt-documento.valor-frete        (TOTAL)
                       tt-documento.icm-deb-cre        (TOTAL)
                       tt-documento.icm-complem        (TOTAL)
                       tt-documento.nota-deb           (TOTAL)
                       tt-documento.de-tot-ii          (TOTAL)
                       tt-documento.de-tot-pis         (TOTAL)
                       tt-documento.de-tot-cof         (total)
                       tt-documento.tot-valor          (TOTAL)
                       tt-documento.d-vl-bc-uf-dest    (TOTAL)
                       tt-documento.d-aliq-uf-dest     (TOTAL)
                       tt-documento.d-aliq-inter       (TOTAL)
                       tt-documento.d-perc-icms-fcp    (TOTAL)
                       tt-documento.d-vl-icms-fcp      (TOTAL)
                       tt-documento.d-vl-icms-uf-dest  (TOTAL)
                       tt-documento.d-vl-icms-uf-remet (TOTAL).        

            for each tt-documento-aux use-index codigo2
                where tt-documento-aux.r-documento = recid(tt-documento)
                and   tt-documento-aux.it-codigo   = tt-documento.it-codigo
                break by tt-documento-aux.r-documento 
                      by tt-documento-aux.ct-codigo
                      by tt-documento-aux.sc-codigo:
                
                if  first(tt-documento-aux.ct-codigo) OR first(tt-documento-aux.sc-codigo) then
                    PUT UNFORMATTED 
                         tt-documento.dt-trans                  FORMAT "99/99/9999"
                         c-separador
                         tt-documento.dt-emissao                FORMAT "99/99/9999"    
                         c-separador
                         tt-documento.serie-docto                        
                         c-separador
                         tt-documento.nro-docto                 FORMAT "9999999999"      
                         c-separador
                         tt-documento.cod-estab                 format "x(3)"
                         c-separador
                         tt-documento.cod-emitente                       
                         c-separador                         
                         tt-documento.nome-abrev                FORMAT "x(30)"         
                         c-separador
                         tt-documento.cgc                       FORMAT "x(17)"                          
                         c-separador
                         tt-documento.c-emb                     FORMAT "x(10)"
                         c-separador
                         tt-documento.estado                    FORMAT "x(2)"
                         c-separador
                         tt-documento.cidade                    FORMAT "x(21)"    
                         c-separador
                         tt-documento.Pais                      FORMAT "x(21)"    
                         c-separador
                         tt-documento.nat-operacao              FORMAT "999xxx"   
                         c-separador
                         tt-documento.v-aliq                    FORMAT ">,>>9.99"  
                         c-separador
                         tt-documento.cod-devolucao             FORMAT "999"                  
                         c-separador
                         tt-documento.cod_unid_negoc            FORMAT "x(3)":U
                         c-separador
                         tt-documento.des_unid_negoc            FORMAT "x(40)":U
                         c-separador
                         tt-documento.it-codigo                 FORMAT "x(8)"                       
                         c-separador
                         tt-documento.descricao-1                                      
                         " "
                         tt-documento.descricao-2 
                         c-separador
                         tt-documento.narrativa                 FORMAT "x(2000)"   
                         c-separador
                         tt-documento.class-fiscal              FORMAT "9999.99.99"              
                         c-separador
                         tt-documento.aliquota-ipi              FORMAT ">,>>9.99" 
                         c-separador             
                         tt-documento.aliq-ipi-ncm              FORMAT ">,>>9.99" 
                         c-separador             
                         tt-documento.cod-depos                 FORMAT "xxx"
                         c-separador
                         tt-documento.cod-localiz
                         c-separador.
                ELSE PUT UNFORMATTED 
                         c-separador c-separador c-separador c-separador c-separador c-separador c-separador c-separador c-separador
                         c-separador c-separador c-separador c-separador c-separador c-separador c-separador c-separador c-separador
                         c-separador c-separador c-separador c-separador c-separador.

                put UNFORMATTED 
                    tt-documento-aux.ct-codigo
                    c-separador
                    tt-documento-aux.sc-codigo
                    c-separador
                    tt-documento-aux.cod-unid-negoc
                    c-separador
                    tt-documento.nr-ord-prod                   FORMAT ">>>,>>>,>>9"
                    c-separador
                    tt-documento-aux.quantidade                FORMAT "->>>,>>9.99" 
                    c-separador.
                    
                if first(tt-documento-aux.ct-codigo) OR first(tt-documento-aux.sc-codigo) then
                    put UNFORMATTED  
                        tt-documento.preco-unit                format "->>>,>>>,>>9.99999" 
                        c-separador.
                ELSE PUT UNFORMATTED c-separador.
                    
                put UNFORMATTED 
                    tt-documento-aux.valor-mercadoria          format "->>>,>>>,>>9.99" 
                    c-separador
                    tt-documento-aux.valor-frete
                    c-separador
                    tt-documento-aux.tx-adm
                    c-separador
                    tt-documento-aux.valor-seguro
                    c-separador
                    tt-documento-aux.icm-deb-cre               FORMAT "->>>,>>9.99" 
                    c-separador
                    tt-documento-aux.icm-complem               FORMAT "->>>,>>9.99" 
                    c-separador
                    tt-documento-aux.nota-deb                  FORMAT "->>>,>>9.99" 
                    c-separador                    
                    tt-documento-aux.de-tot-ii                 FORMAT "->>,>>>,>>9.99" 
                    c-separador                    
                    tt-documento-aux.de-tot-pis                FORMAT "->>,>>>,>>9.99" 
                    c-separador
                    tt-documento-aux.de-tot-cof                FORMAT "->>,>>>,>>9.99" 
                    c-separador
                    tt-documento-aux.tot-valor                 FORMAT "->>>,>>>,>>9.99" 
                    c-separador.
                         
                if  first(tt-documento-aux.ct-codigo) OR first(tt-documento-aux.sc-codigo) THEN DO:
                    put UNFORMATTED 
                        tt-documento.c-nr-di                                FORMAT "x(20)" 
                        c-separador
                        tt-documento.data-di
                        c-separador
                        tt-documento.nro-comp                  FORMAT "x(10)"
                        c-separador
                        tt-documento.usuario                   FORMAT "x(8)"
                        c-separador
                        tt-documento.dt-vencto                 FORMAT "99/99/9999"
                        c-separador
                        tt-documento.dt-pagto                  FORMAT "99/99/9999"
                        c-separador
                        tt-documento.esp-dupli                 FORMAT "x(2)"
                        c-separador
                        tt-documento.cod-origem-item
                        c-separador
                        tt-documento.log-atualizado FORMAT "Sim/NÆo"
                        c-separador
                        tt-documento.num-pedido
                        c-separador
                        tt-documento.numero-ordem
                        c-separador
                        tt-documento.parcela
                        c-separador
                        tt-documento.cod-cond-pag
                        c-separador
                        tt-documento.descricao-cond-pag
                        c-separador
                        tt-documento.cod-comprado
                        c-separador
                        tt-documento.ge-codigo
                        c-separador.

                    IF  tt-param.l-listar-THC-II THEN DO:
                        PUT UNFORMATTED tt-documento.val-desp-THC FORMAT "->>>,>>>,>>9.99":U
                                        c-separador
                                        tt-documento.perc-II FORMAT ">>9.99":U
                                        c-separador.
                    END. /* IF  tt-param.l-listar-THC-II THEN DO: */
                    
                    IF  tt-param.log-bc-aliq THEN
                        PUT UNFORMATTED tt-documento.val-base-pis   
                                        c-separador
                                        tt-documento.val-base-cofins
                                        c-separador
                                        tt-documento.val-aliq-pis   
                                        c-separador
                                        tt-documento.val-aliq-cofins
                                        c-separador.

                    

                    /*1.6*/
                    IF NOT tt-param.imprime-financeiro THEN
                    PUT UNFORMATTED tt-documento.cod-dcr-item c-separador
                                    tt-documento.contrib-icms c-separador
                                    tt-documento.de-vl-icms-simples-nac    c-separador 
                                    tt-documento.de-aliq-icms-simples-nac  c-separador 
                                    tt-documento.de-base-icms-simples-nac  c-separador
                                    tt-documento.csosn c-separador 
                                    tt-documento.nom-solicitante c-separador
                                    tt-documento.reinf
                                    c-separador
                                    tt-documento.tipo-serv
                                    c-separador
                                    tt-documento.vl-bc-retenc
                                    c-separador
                                    tt-documento.vl-retenc
                                    c-separador
                                    tt-documento.vl-base-icm-compl
                                    c-separador
                                    tt-documento.vl-icm-compl
                                    c-separador
                                    tt-documento.fm-materias
                                    c-separador
                                    tt-documento.base-calc-icms
                                    c-separador
                                    tt-documento.origem-item
                                    c-separador
                                    tt-documento.cst-item
                                    c-separador
                                    tt-documento.fcp
                                    c-separador
                                    tt-documento.cd-servico
                                    c-separador                         
                                    tt-documento.ds-servico
                                    c-separador
                                    tt-documento.cd-enquadramento
                                    c-separador
                                    tt-documento.ds-enquadramento
                                    c-separador

                                    tt-documento.cd-atividade-mei
                                    c-separador
                                    tt-documento.ds-atividade-mei
                                    c-separador

                                    tt-documento.sequencia
                                    c-separador
                                    tt-documento.cod-repres
                                    c-separador
                                    tt-documento.desc-repres
                                    c-separador.
                     ELSE DO:
                         PUT UNFORMATTED tt-documento.cod-dcr-item c-separador
                                         tt-documento.contrib-icms c-separador
                                         tt-documento.fm-materias  c-separador
                                         tt-documento.de-base-icms-simples-nac  c-separador 
                                         /*"tt-documento.de-vl-icms-simples-nac"    c-separador 
                                         "tt-documento.de-aliq-icms-simples-nac"  c-separador 
                                         "tt-documento.csosn" c-separador 
                                         "tt-documento.nom-solicitante" c-separador
                                         "tt-documento.reinf "
                                         c-separador
                                         "tt-documento.tipo-serv "
                                         c-separador
                                         "tt-documento.vl-bc-retenc "
                                         c-separador
                                         "tt-documento.vl-retenc "
                                         c-separador
                                         "tt-documento.vl-base-icm-compl "
                                         c-separador
                                         "tt-documento.vl-icm-compl     "
                                         c-separador
                                         "tt-documento.base-calc-icms "
                                         c-separador*/
                                         tt-documento.origem-item
                                         c-separador
                                         tt-documento.cst-item
                                         c-separador
                                         tt-documento.fcp
                                         c-separador
                                         tt-documento.cd-servico
                                         c-separador                         
                                         tt-documento.ds-servico
                                         c-separador
                                         tt-documento.cd-enquadramento
                                         c-separador
                                         tt-documento.ds-enquadramento
                                         c-separador

                                         tt-documento.cd-atividade-mei
                                         c-separador
                                         tt-documento.ds-atividade-mei
                                         c-separador
                                         
                                         tt-documento.sequencia
                                         tt-documento.cod-repres 
                                         c-separador             
                                         tt-documento.desc-repres
                                         c-separador.
                     END.

                END. /* if  first(tt-documento-aux.ct-codigo) OR first(tt-documento-aux.sc-codigo) */
                ELSE DO:
                    PUT UNFORMATTED ";;;;;;;" 
                                    tt-documento.cod-origem-item                
                                    c-separador                                 
                                    tt-documento.log-atualizado FORMAT "Sim/NÆo"
                                    c-separador
                                    tt-documento.num-pedido
                                    c-separador
                                    tt-documento.numero-ordem
                                    c-separador
                                    tt-documento.parcela
                                    c-separador
                                    tt-documento.cod-cond-pag
                                    c-separador
                                    tt-documento.descricao-cond-pag
                                    c-separador
                                    tt-documento.cod-comprado
                                    c-separador
                                    tt-documento.ge-codigo
                                    c-separador.

                    IF  tt-param.log-bc-aliq THEN
                        PUT UNFORMATTED tt-documento.val-base-pis   
                                        c-separador
                                        tt-documento.val-base-cofins
                                        c-separador
                                        tt-documento.val-aliq-pis   
                                        c-separador
                                        tt-documento.val-aliq-cofins
                                        c-separador.

                    PUT UNFORMATTED tt-documento.cod-dcr-item c-separador
                                    tt-documento.contrib-icms c-separador
                                    tt-documento.fm-materias  c-separador
                                    tt-documento.de-vl-icms-simples-nac   c-separador 
                                    tt-documento.de-aliq-icms-simples-nac c-separador 
                                    tt-documento.de-base-icms-simples-nac c-separador 
                                    tt-documento.csosn c-separador
                                    tt-documento.nom-solicitante c-separador
                                    tt-documento.reinf 
                                    c-separador
                                    tt-documento.tipo-serv
                                    c-separador
                                    tt-documento.vl-bc-retenc
                                    c-separador
                                    tt-documento.vl-retenc
                                    c-separador
                                    tt-documento.vl-base-icm-compl
                                    c-separador
                                    tt-documento.vl-icm-compl
                                    c-separador
                                    tt-documento.base-calc-icms
                                    c-separador
                                    tt-documento.origem-item
                                    c-separador
                                    tt-documento.cst-item
                                    c-separador
                                    tt-documento.fcp
                                    c-separador
                                    tt-documento.cd-servico
                                    c-separador                         
                                    tt-documento.ds-servico
                                    c-separador
                                    tt-documento.cd-enquadramento
                                    c-separador
                                    tt-documento.ds-enquadramento
                                    c-separador

                                    tt-documento.cd-atividade-mei
                                    c-separador
                                    tt-documento.ds-atividade-mei
                                    c-separador

                                    tt-documento.sequencia
                                    tt-documento.cod-repres 
                                    c-separador             
                                    tt-documento.desc-repres
                                    c-separador.
                        
                END. /* ELSE DO: */
            end.    

            IF tt-param.imprime-financeiro AND  LAST-OF(tt-documento.r-docum-est) THEN DO:
                ASSIGN i-linha-corrente = LINE-COUNT.

                RUN esp/apb/esapb777.p (INPUT tt-documento.serie-docto,
                                        INPUT tt-documento.nro-docto,
                                        INPUT tt-documento.cod-emitente,
                                        INPUT tt-documento.nat-operacao,
                                        INPUT 1,
                                        INPUT tt-param.ini-data,
                                        INPUT tt-param.fim-data,
                                        INPUT tt-param.cod-estabel-ini,
                                        INPUT tt-param.cod-estabel-fim,
                                        INPUT i-colunas).

                IF i-linha-corrente = LINE-COUNT THEN DO:
                    PUT UNFORMATTED SKIP.
                END.
            END.
            ELSE PUT UNFORMATTED SKIP.

            if last (tt-documento.dt-trans) then do:
                PUT UNFORMATTED SKIP(1)
                    ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Total: ;"
                    accum total tt-documento.valor-mercadoria format ">>>,>>>,>>9.99"  ";"
                    accum total tt-documento.valor-frete format ">>>,>>>,>>9.99"  ";;;"
                    accum total tt-documento.icm-deb-cre FORMAT ">>>,>>>,>>9.99"            ";"
                    accum total tt-documento.icm-complem FORMAT ">>>,>>>,>>9.99"            ";"
                    accum total tt-documento.nota-deb    FORMAT ">>>,>>9.99"           ";"
                    accum total tt-documento.de-tot-ii   FORMAT ">>>,>>9.99"           ";"
                    accum total tt-documento.de-tot-pis  FORMAT ">>>,>>9.99"           ";"
                    accum total tt-documento.de-tot-cof  FORMAT ">>>,>>9.99"           ";"
                    accum total tt-documento.tot-valor   FORMAT ">>>,>>>,>>9.99"       ";" SKIP.
            end.                         
        end.
    end.

    IF tt-param.imprime-conta = YES AND tt-param.imprime-financeiro THEN 
        RUN esp/apb/esapb777.p (INPUT "",
                                INPUT "",
                                INPUT 0,
                                INPUT "",
                                INPUT 2,
                                INPUT tt-param.ini-data,
                                INPUT tt-param.fim-data,
                                INPUT tt-param.cod-estabel-ini,
                                INPUT tt-param.cod-estabel-fim,
                                INPUT i-colunas).
END PROCEDURE. /* PROCEDURE piRelatAnalitico */

PROCEDURE pi-busca-cotacao.
    DEF INPUT PARAMETER p-da-data as DATE NO-UNDO.
    DEF OUTPUT PARAMETER p-de-cotacao AS DEC NO-UNDO.
    
    FIND cotacao NO-LOCK         WHERE
         cotacao.mo-codigo   = 1 AND
         cotacao.ano-periodo = STRING(year(p-da-data),"9999") + STRING(month(p-da-data),"99") NO-ERROR.
            
    IF AVAIL cotacao AND 
             cotacao.cotacao[day(p-da-data)] <> 0 THEN  
       ASSIGN p-de-cotacao = cotacao.cotacao[day(p-da-data)].
    ELSE
       ASSIGN p-de-cotacao = 1.
END.

/*
PROCEDURE pi-busca-cotacao-di.
    DEF INPUT PARAMETER p-da-data as DATE NO-UNDO. 

/*    ASSIGN da-data = embarque-imp.data-di - 1.*/
    
    FIND cotacao NO-LOCK         WHERE
         cotacao.mo-codigo   = 1 AND
         cotacao.ano-periodo = STRING(year(p-da-data),"9999") + STRING(month(p-da-data),"99") NO-ERROR.
    IF AVAIL cotacao AND 
             cotacao.cotacao[day(p-da-data)] <> 0 THEN  
       ASSIGN p-de-cotacao-di = cotacao.cotacao[day(p-da-data)].
    ELSE
       ASSIGN p-de-cotacao-di = 1.
END.
*/
