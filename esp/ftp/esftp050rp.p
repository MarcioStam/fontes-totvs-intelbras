/***********************************************************************
**  Programa..: ESP\FTP\esftp050RP.P
**  Autor.....: Anderson Cenci
**  Data......: Julho/2008
**  Descricao.: Acordo Comercial
**  VersÆo....: 001 15/07/2008
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i esftp050 2.04.00.002}

/****************************  Definitions  ****************************/
{esp/ftp/esftp050tt.i}
{include/i-rpvar.i}

DEF TEMP-TABLE tt-nota
      FIELD cod-estabel      LIKE estabelec.cod-estabel
      FIELD serie            LIKE nota-fiscal.serie
      FIELD nr-nota-fis      LIKE nota-fiscal.nr-nota-fis
      FIELD nr-nota-dev      LIKE devol-cli.nro-docto
      FIELD dt-emis-nota     LIKE nota-fiscal.dt-emis-nota
      FIELD dt-devol         LIKE devol-cli.dt-devol
      FIELD dt-entrega       LIKE nota-fiscal.dt-emis-nota
      FIELD unid-neg         AS CHARACTER
      FIELD cod-emitente     LIKE emitente.cod-emitente
      FIELD cgc              LIKE emitente.cgc
      FIELD nome-matriz      LIKE emitente.nome-matriz
      FIELD nome-emit        LIKE emitente.nome-emit
      FIELD nr-pedcli        LIKE nota-fiscal.nr-pedcli
      FIELD total-valor      AS DECIMAL FORMAT "->>>,>>>,>>9.99"
      FIELD total-valor-ipi  AS DECIMAL FORMAT "->>>,>>>,>>9.99"
      FIELD total-valor-st   AS DECIMAL FORMAT "->>>,>>>,>>9.99"
      FIELD perc-acordo      AS DECIMAL FORMAT ">>9.99"
      FIELD valor-acordo     AS DECIMAL FORMAT "->>>,>>>,>>9.99"
      FIELD valor-acordo-ipi AS DECIMAL FORMAT "->>>,>>>,>>9.99"
      FIELD valor-acordo-st  AS DECIMAL FORMAT "->>>,>>>,>>9.99"
      FIELD total-liquido    AS DECIMAL FORMAT "->>>,>>>,>>9.99"
      FIELD total-ipi        AS DECIMAL FORMAT "->>>,>>>,>>9.99"
      FIELD total-icmsub     AS DECIMAL FORMAT "->>>,>>>,>>9.99"
      FIELD id-devolucoes    AS INT /* VIEW-AS RADIO-SET VERTICAL RADIO-BUTTONS "Considera", 0, "Nao Considera", 9, "Nao Localizado", 2 */
      FIELD id-faturamento   AS INT /* VIEW-AS RADIO-SET VERTICAL RADIO-BUTTONS   "Sem IPI", 0,       "Com IPI", 1, "Nao Localizado", 2 */
      FIELD id-base-calculo  AS INT /* VIEW-AS RADIO-SET VERTICAL RADIO-BUTTONS    "Sem ST", 0,        "Com ST", 1, "Nao Localizado", 2 */
      FIELD l-tem-acordo     AS LOG 


    INDEX ch-principal cod-estabel serie nr-nota-fis nr-nota-dev unid-neg perc-acordo.

DEFINE TEMP-TABLE tt-acordo-matriz NO-UNDO
    FIELD matriz           AS INTEGER
    FIELD valor-acordo     AS DECIMAL FORMAT "->>>,>>>,>>9.99"
    FIELD id-faturamento   AS INT
    FIELD id-base-calculo  AS INT
    INDEX ch-chave matriz.

/****************************  Variaveis    ****************************/
/* DEFINE BUFFER bfam-comerc FOR fam-comerc. */
def var h-boes464             as handle  no-undo.
def var da-data          as date.
def var da-data-ini      like nota-fiscal.dt-emis-nota.
def var da-data-fim      like nota-fiscal.dt-emis-nota.

DEFINE VARIABLE de-perc-acordo          AS DECIMAL NO-UNDO.
DEFINE VARIABLE i-id-faturamento-acordo AS INTEGER NO-UNDO. 
DEFINE VARIABLE i-id-base-calc-acordo   AS INTEGER NO-UNDO.
DEFINE VARIABLE i-id-devolucoes         AS INTEGER NO-UNDO.

DEFINE VARIABLE v-id-devolucoes   AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-id-faturamento  AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-id-base-calculo AS INTEGER     NO-UNDO.

DEFINE VARIABLE v_dev    AS CHARACTER FORMAT "X(15)" NO-UNDO.
DEFINE VARIABLE v_ipi    AS CHARACTER FORMAT "X(15)" NO-UNDO.
DEFINE VARIABLE v_st     AS CHARACTER FORMAT "X(15)" NO-UNDO.
DEFINE VARIABLE v_base   AS DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE v_acordo AS DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.

DEFINE VARIABLE l-tem-acordo AS LOG NO-UNDO.

DEFINE STREAM s-detalhado.
DEFINE STREAM s-resumo.

DEFINE VARIABLE de-valor-acordo     AS DECIMAL  FORMAT "->>>,>>>,>>9.99"   NO-UNDO.
DEFINE VARIABLE de-total-liquido    AS DECIMAL  FORMAT "->>>,>>>,>>9.99"   NO-UNDO.
DEFINE VARIABLE de-total-valor      AS DECIMAL  FORMAT "->>>,>>>,>>9.99"   NO-UNDO.

def var c-unid-neg       as char format "X(10)".

def buffer b-emitente for emitente.
/****************************  Frames       ****************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. 

def var h-acomp      as handle no-undo.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Acordo Comercial"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "esftp050"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
RUN esbo/boes464.p PERSISTENT SET h-boes464.
do on stop undo, leave:
   {include/i-rpcab.i}
   {include/i-rpout.i &pagesize="0"}
    
   VIEW FRAME f-cabec.
   VIEW FRAME f-rodape.
   PUT "Selecao " SKIP
       "Estabelecimento : " tt-param.cod-estabel-ini " <> " AT 30
       tt-param.cod-estabel-fim                           SKIP
       "    Dt. Emissao : " tt-param.dt-emissao-ini  " <> " AT 30
       tt-param.dt-emissao-fim                            SKIP
       "      Diretorio : " tt-param.diretorio FORMAT "x(200)"           SKIP
       " Op‡Æo Listagem : " .
   IF tt-param.opcao-listagem = 1  THEN PUT "Matriz"      SKIP.
   IF tt-param.opcao-listagem = 2  THEN PUT "CNPJ"        SKIP.
   IF tt-param.opcao-listagem = 3  THEN PUT "Cod.Cliente" SKIP.
   
   FOR EACH tt-nota:
       DELETE tt-nota.
   END.

   FOR EACH tt-acordo-matriz:
       DELETE tt-acordo-matriz.
   END.

   IF tt-param.tipo <> 1 AND tt-param.dt-emissao-ini < 11/01/2009 THEN DO:
       PUT UNFORMATTED
           "Periodo invalido - deve ser no minimo inicio em 01/11/2009" SKIP.
   END.
   ELSE DO:
       IF tt-param.tipo <> 3 THEN DO:
           run utp/ut-acomp.p persistent set h-acomp.  
           run pi-inicializar in h-acomp (input "Imprimindo...").
           RUN piImprimeRelat.
           run pi-finalizar in h-acomp.
       END.
       ELSE DO:
           RUN esp/ftp/esftp050rp1.p(INPUT tt-param.cod-estabel-ini,
                                     INPUT tt-param.dt-emissao-fim).
       END.
   END.


   {include/i-rpclo.i} 

   IF VALID-HANDLE(h-boes464) THEN
       DELETE PROCEDURE h-boes464.    
   ASSIGN h-boes464 = ?.

   RETURN "OK".
end.


/* **********************  Internal Procedures  *********************** */


PROCEDURE piImprimeRelat:
    OUTPUT STREAM s-detalhado TO VALUE(tt-param.diretorio + "detalhado" + string(MONTH(tt-param.dt-emissao-fim)) + string(YEAR(tt-param.dt-emissao-fim)) + ".csv").
    
    do da-data = tt-param.dt-emissao-ini to tt-param.dt-emissao-fim:
       RUN pi-acompanhar IN h-acomp (INPUT "Selecionando Faturamento data:" + string(da-data,"99/99/9999")).
       FOR EACH nota-fiscal USE-INDEX ch-distancia
           WHERE nota-fiscal.dt-emis-nota = da-data
           AND   nota-fiscal.cod-estabel  >= tt-param.cod-estabel-ini
           AND   nota-fiscal.cod-estabel  <= tt-param.cod-estabel-fim
           AND   nota-fiscal.cod-emitente >= tt-param.cod-cli-ini
           AND   nota-fiscal.cod-emitente <= tt-param.cod-cli-fim
           AND   nota-fiscal.dt-cancel    = ? NO-LOCK,
           FIRST natur-oper NO-LOCK
           WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
           AND   natur-oper.tipo = 2
           AND   natur-oper.emite-duplic = YES,
           first emitente no-lock 
                 WHERE emitente.cod-emitente = nota-fiscal.cod-emitente,
           FIRST b-emitente  NO-LOCK
              WHERE b-emitente.nome-abrev = emitente.nome-matriz,
           each it-nota-fisc of nota-fiscal no-lock,
           FIRST ITEM  NO-LOCK 
                 WHERE item.it-codigo  = it-nota-fisc.it-codigo
           BREAK BY nota-fiscal.cod-estabel
                 BY nota-fiscal.nr-nota-fis:

           IF natur-oper.consum-final = YES THEN 
               NEXT.

           IF natur-oper.tipo = 3 THEN 
               NEXT.

           IF  nota-fiscal.cod-des-merc = 2 THEN /* nÆo considerar notas de consumo pr¢prio - chamado: 143709 */
               NEXT.
           
/*            ASSIGN c-unid-neg = "".                                   */
/*            FIND FIRST unid-neg-fat OF it-nota-fisc NO-LOCK NO-ERROR. */
/*            IF AVAIL unid-neg-fat THEN                                */
/*                ASSIGN c-unid-neg = unid-neg-fat.cod_unid_negoc.      */

           ASSIGN c-unid-neg = it-nota-fisc.cod-unid-neg.

           RUN piTrataRelat. 

           IF tt-param.unid-negocio <> "" AND
              LOOKUP(c-unid-neg,tt-param.unid-negocio) = 0 THEN NEXT.

           IF  de-perc-acordo > 0 THEN DO:
               FIND tt-nota
                    WHERE tt-nota.cod-estabel = nota-fiscal.cod-estabel
                      AND tt-nota.serie       = nota-fiscal.serie
                      AND tt-nota.nr-nota-fis = nota-fiscal.nr-nota-fis
                      AND tt-nota.nr-nota-dev = ""
                      AND tt-nota.unid-neg    = c-unid-neg
                      AND tt-nota.perc-acordo = de-perc-acordo
                    NO-ERROR.
               IF NOT AVAIL tt-nota THEN DO:
                  CREATE tt-nota.
                  ASSIGN tt-nota.cod-estabel = nota-fiscal.cod-estabel    
                         tt-nota.serie       = nota-fiscal.serie          
                         tt-nota.nr-nota-fis = nota-fiscal.nr-nota-fis    
                         tt-nota.nr-nota-dev = ""
                         tt-nota.unid-neg    = c-unid-neg                 
                         tt-nota.perc-acordo = de-perc-acordo.
               END.

               RUN get-acordo-contrato(INPUT emitente.cgc,             /*raiz-cnpj ou cnpj completo (ser  tratado na bo)*/  
                                       INPUT nota-fiscal.cod-estabel,  /*estabelecimento*/                                  
                                       INPUT c-unid-neg,               /*unidade negocio*/                                  
                                       INPUT ITEM.fm-cod-com,          /*familia comercial*/                                
                                       INPUT nota-fiscal.dt-emis-nota, /*data emissao*/                                     
                                       OUTPUT v-id-devolucoes,         /*Devolucoes*/                                          
                                       OUTPUT v-id-faturamento,        /*IPI*/                                              
                                       OUTPUT v-id-base-calculo).      /*ST ICMS*/

               ASSIGN tt-nota.cod-emitente     = emitente.cod-emitente
                      tt-nota.cgc              = substring(emitente.cgc,1,8)
                      tt-nota.nome-matriz      = string(b-emitente.cod-emitente)
                      tt-nota.nome-emit        = emitente.nome-emit
                      tt-nota.nr-pedcli        = nota-fiscal.nr-pedcli
                      tt-nota.dt-emis-nota     = nota-fiscal.dt-emis-nota
                      tt-nota.dt-devol         = ?
                      tt-nota.total-valor      = tt-nota.total-valor      + it-nota-fisc.vl-merc-liq
                      tt-nota.total-valor-ipi  = tt-nota.total-valor-ipi  + it-nota-fisc.vl-ipi-it
                      tt-nota.total-valor-st   = tt-nota.total-valor-st   + it-nota-fisc.vl-icmsub-it
                      tt-nota.total-liquido    = tt-nota.total-liquido    + it-nota-fisc.vl-merc-liq
                      tt-nota.valor-acordo     = tt-nota.valor-acordo     + ((it-nota-fisc.vl-merc-liq)  * de-perc-acordo / 100)
                      tt-nota.valor-acordo-ipi = tt-nota.valor-acordo-ipi + ((it-nota-fisc.vl-ipi-it)    * de-perc-acordo / 100)
                      tt-nota.valor-acordo-st  = tt-nota.valor-acordo-st  + ((it-nota-fisc.vl-icmsub-it) * de-perc-acordo / 100)
                      tt-nota.total-ipi        = tt-nota.total-ipi        + it-nota-fisc.vl-ipi-it
                      tt-nota.total-icmsub     = tt-nota.total-icmsub     + it-nota-fisc.vl-icmsub-it
                      tt-nota.id-devolucoes    = v-id-devolucoes
                      tt-nota.id-faturamento   = v-id-faturamento
                      tt-nota.id-base-calculo  = v-id-base-calculo.
               FIND ped-venda
                    WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli
                      AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                    NO-LOCK NO-ERROR.
               IF AVAIL ped-venda  THEN
                   ASSIGN tt-nota.dt-entrega = ped-venda.dt-entrega.

               
               IF tt-param.tipo = 2 THEN DO:
                   FIND FIRST tt-acordo-matriz NO-LOCK
                        WHERE tt-acordo-matriz.matriz = b-emitente.cod-emitente NO-ERROR.
                   IF NOT AVAIL tt-acordo-matriz THEN DO:
                       CREATE tt-acordo-matriz.
                       ASSIGN tt-acordo-matriz.matriz          = b-emitente.cod-emitente
                              tt-acordo-matriz.id-faturamento  = v-id-faturamento
                              tt-acordo-matriz.id-base-calculo = v-id-base-calculo.
                   END.

                   ASSIGN tt-acordo-matriz.valor-acordo = tt-acordo-matriz.valor-acordo + ((it-nota-fisc.vl-merc-liq)  * de-perc-acordo / 100).
                   IF v-id-faturamento = 1 
                      THEN ASSIGN tt-acordo-matriz.valor-acordo = tt-acordo-matriz.valor-acordo + ((it-nota-fisc.vl-ipi-it)    * de-perc-acordo / 100).
                   IF v-id-base-calculo = 1 
                      THEN ASSIGN tt-acordo-matriz.valor-acordo = tt-acordo-matriz.valor-acordo + ((it-nota-fisc.vl-icmsub-it) * de-perc-acordo / 100).
                   
                   RUN geraAcordoNotasFiscais IN h-boes464(INPUT emitente.cgc,                /*raiz-cnpj ou cnpj completo (ser  tratado na bo)*/
                                                           INPUT nota-fiscal.cod-estabel,     /*estabelecimento*/
                                                           INPUT nota-fiscal.serie,           /*serie*/
                                                           INPUT nota-fiscal.nr-nota-fis,     /*nota fiscal*/
                                                           INPUT nota-fiscal.dt-emis-nota,    /*emissao nota*/
                                                           INPUT "",                          /*nota devolucao*/ 
                                                           INPUT c-unid-neg,                  /*unidade negocio*/
                                                           INPUT ITEM.fm-cod-com,             /*familia comercial*/
                                                           INPUT nota-fiscal.dt-emis-nota,    /*data emissao*/
                                                           INPUT emitente.cod-emitente,       /*codigo cliente*/
                                                           INPUT b-emitente.cod-emitente,     /*matriz cliente*/
                                                           INPUT it-nota-fisc.vl-merc-liq,    /*Liquido*/
                                                           INPUT it-nota-fisc.vl-ipi-it,      /*ACT*/
                                                           INPUT it-nota-fisc.vl-icmsub-it).  /*IPI*/ 
               END.
           END.    
       end.

        /** DEVOLUCAO **/
 
       for each devol-cli  USE-INDEX ch-dt-emit NO-LOCK
           where devol-cli.dt-devol      = da-data 
             and devol-cli.cod-estabel  >= tt-param.cod-estabel-ini
             and devol-cli.cod-estabel  <= tt-param.cod-estabel-fim ,
           FIRST nota-fiscal  NO-LOCK
                 WHERE nota-fiscal.cod-estabel   = devol-cli.cod-estabel
                 AND   nota-fiscal.serie         = devol-cli.serie
                 AND   nota-fiscal.nr-nota-fis   = devol-cli.nr-nota-fis
                 AND   nota-fiscal.cod-emitente >= tt-param.cod-cli-ini
                 AND   nota-fiscal.cod-emitente <= tt-param.cod-cli-fim
                 AND   nota-fiscal.emite-duplic, 
           FIRST natur-oper NO-LOCK
           WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
           AND   natur-oper.tipo = 2
           AND   natur-oper.emite-duplic = YES,
           first emitente  no-lock 
                 WHERE emitente.cod-emitente = devol-cli.cod-emitente ,
           FIRST b-emitente  NO-LOCK
              WHERE b-emitente.nome-abrev = emitente.nome-matriz,
           each item-doc-est  of devol-cli no-lock,
           first it-nota-fisc no-lock
           where it-nota-fisc.cod-estabel = devol-cli.cod-estabel
             and it-nota-fisc.serie       = devol-cli.serie
             and it-nota-fisc.nr-nota-fis = devol-cli.nr-nota-fis
             and it-nota-fisc.it-codigo   = devol-cli.it-codigo
             and it-nota-fisc.nr-seq-fat  = devol-cli.nr-sequencia,

           FIRST ITEM  NO-LOCK 
                 WHERE item.it-codigo  = item-doc-est.it-codigo:
           
           find first ped-venda no-lock 
                WHERE ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli 
                AND   ped-venda.nome-abrev = nota-fiscal.nome-ab-cli no-error.
           
/*            ASSIGN c-unid-neg = "".                                    */
/*            FIND FIRST unid-neg-nota of item-doc-est NO-LOCK NO-ERROR. */
/*            IF AVAIL unid-neg-nota THEN                                */
/*                ASSIGN c-unid-neg = unid-neg-nota.cod_unid_negoc.      */

           ASSIGN c-unid-neg = it-nota-fisc.cod-unid-neg.


           RUN piTrataRelat. 

           IF tt-param.unid-negocio <> "" AND
              LOOKUP(c-unid-neg,tt-param.unid-negocio) = 0 THEN NEXT.

            ASSIGN l-tem-acordo = YES.
            FIND FIRST int-docum-est OF docum-est NO-LOCK NO-ERROR.
            IF AVAIL int-docum-est THEN
               IF int-docum-est.cod-msg-devolucao = 500 OR 
                  int-docum-est.cod-msg-devolucao = 513 or
                  int-docum-est.cod-msg-devolucao = 517 THEN
                  ASSIGN l-tem-acordo = NO.

           IF  de-perc-acordo > 0 THEN DO:
               FIND tt-nota
                    WHERE tt-nota.cod-estabel = nota-fiscal.cod-estabel
                      AND tt-nota.serie       = nota-fiscal.serie
                      AND tt-nota.nr-nota-fis = nota-fiscal.nr-nota-fis
                      AND tt-nota.nr-nota-dev = devol-cli.nro-docto
                      AND tt-nota.unid-neg    = c-unid-neg
                      AND tt-nota.perc-acordo = de-perc-acordo
                    NO-ERROR.
               IF NOT AVAIL tt-nota THEN DO:
                  CREATE tt-nota.
                  ASSIGN tt-nota.cod-estabel = nota-fiscal.cod-estabel    
                         tt-nota.serie       = nota-fiscal.serie          
                         tt-nota.nr-nota-fis = nota-fiscal.nr-nota-fis    
                         tt-nota.nr-nota-dev = devol-cli.nro-docto
                         tt-nota.unid-neg    = c-unid-neg                 
                         tt-nota.perc-acordo = de-perc-acordo.
               END.

               RUN get-acordo-contrato(INPUT emitente.cgc,             /*raiz-cnpj ou cnpj completo (ser  tratado na bo)*/  
                                       INPUT nota-fiscal.cod-estabel,  /*estabelecimento*/                                  
                                       INPUT c-unid-neg,               /*unidade negocio*/                                  
                                       INPUT ITEM.fm-cod-com,          /*familia comercial*/                                
                                       INPUT nota-fiscal.dt-emis-nota, /*data emissao*/                                     
                                       OUTPUT v-id-devolucoes,         /*Devolucoes*/                                          
                                       OUTPUT v-id-faturamento,        /*IPI*/                                              
                                       OUTPUT v-id-base-calculo).      /*ST ICMS*/

               ASSIGN tt-nota.cod-emitente     = emitente.cod-emitente
                      tt-nota.cgc              = substring(emitente.cgc,1,8)
                      tt-nota.nome-matriz      = string(b-emitente.cod-emitente)
                      tt-nota.nome-emit        = emitente.nome-emit
                      tt-nota.nr-pedcli        = nota-fiscal.nr-pedcli
                      tt-nota.dt-emis-nota     = nota-fiscal.dt-emis-nota
                      tt-nota.dt-devol         = devol-cli.dt-devol
                      tt-nota.total-valor      = tt-nota.total-valor     - item-doc-est.preco-total[1]
                      tt-nota.total-valor-ipi  = tt-nota.total-valor-ipi - (item-doc-est.valor-ipi[1])
                      tt-nota.total-valor-st   = tt-nota.total-valor-st  - (item-doc-est.vl-subs[1])
                      tt-nota.total-liquido    = tt-nota.total-liquido   - item-doc-est.preco-total[1]          
                      tt-nota.valor-acordo     = tt-nota.valor-acordo  - ((item-doc-est.preco-total[1]) * de-perc-acordo / 100) 
                      tt-nota.valor-acordo-ipi = tt-nota.valor-acordo-ipi  - ((item-doc-est.valor-ipi[1])   * de-perc-acordo / 100)
                      tt-nota.valor-acordo-st  = tt-nota.valor-acordo-st   - ((item-doc-est.vl-subs[1])     * de-perc-acordo / 100)
                      tt-nota.total-ipi        = tt-nota.total-ipi     + item-doc-est.valor-ipi[1]
                      tt-nota.total-icmsub     = tt-nota.total-icmsub  + item-doc-est.vl-subs[1]
                      tt-nota.id-devolucoes    = v-id-devolucoes
                      tt-nota.id-faturamento   = v-id-faturamento
                      tt-nota.id-base-calculo  = v-id-base-calculo.

               IF NOT l-tem-acordo THEN
                  ASSIGN tt-nota.valor-acordo = tt-nota.valor-acordo * -1.


               FIND ped-venda
                    WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli
                      AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                    NO-LOCK NO-ERROR.
               IF AVAIL ped-venda  THEN
                   ASSIGN tt-nota.dt-entrega = ped-venda.dt-entrega.

               IF tt-param.tipo = 2 THEN DO:
                   FIND FIRST tt-acordo-matriz NO-LOCK
                        WHERE tt-acordo-matriz.matriz = b-emitente.cod-emitente NO-ERROR.
                   IF NOT AVAIL tt-acordo-matriz THEN DO:
                       CREATE tt-acordo-matriz.
                       ASSIGN tt-acordo-matriz.matriz          = b-emitente.cod-emitente
                              tt-acordo-matriz.id-faturamento  = v-id-faturamento
                              tt-acordo-matriz.id-base-calculo = v-id-base-calculo.
                   END.

                   IF v-id-devolucoes = 0  /* considera devolucoes */
                   THEN DO:
                        ASSIGN tt-acordo-matriz.valor-acordo = tt-acordo-matriz.valor-acordo - ((item-doc-est.preco-total[1]) * de-perc-acordo / 100).
                        IF v-id-faturamento = 1 
                           THEN ASSIGN tt-acordo-matriz.valor-acordo = tt-acordo-matriz.valor-acordo - ((item-doc-est.valor-ipi[1]) * de-perc-acordo / 100).
                        IF v-id-base-calculo = 1 
                           THEN ASSIGN tt-acordo-matriz.valor-acordo = tt-acordo-matriz.valor-acordo - ((item-doc-est.vl-subs[1])   * de-perc-acordo / 100).
                   END.

                   RUN geraAcordoNotasFiscais IN h-boes464(INPUT emitente.cgc,                /*raiz-cnpj ou cnpj completo (ser  tratado na bo)*/
                                                           INPUT nota-fiscal.cod-estabel,     /*estabelecimento*/
                                                           INPUT nota-fiscal.serie,           /*serie*/
                                                           INPUT nota-fiscal.nr-nota-fis,     /*nota fiscal*/
                                                           INPUT devol-cli.dt-devol,          /*emissao nota*/
                                                           INPUT devol-cli.nro-docto,         /*nota devolucao*/ 
                                                           INPUT c-unid-neg,                  /*unidade negocio*/
                                                           INPUT ITEM.fm-cod-com,             /*familia comercial*/
                                                           INPUT nota-fiscal.dt-emis-nota,    /*data emissao*/
                                                           INPUT emitente.cod-emitente,       /*codigo cliente*/
                                                           INPUT b-emitente.cod-emitente,     /*matriz cliente*/
                                                           INPUT item-doc-est.preco-total[1], /*Liquido*/
                                                           INPUT item-doc-est.valor-ipi[1],   /*IPI*/
                                                           INPUT item-doc-est.vl-subs[1]).    /*ACT*/ 
               END.
           END.    
       END.
    end.
    PUT STREAM s-detalhado 
        "Est;Ser;Nota;Dt.Emissao;Dt.Entrega;Nota Dev;Dt.Devol;UNID;Cod.Cli.;CGC;Matriz;Cliente;Pedido;Vlr Liquido;IPI;ICMS SUBST;Valor Base;Perc.;Valor Acordo;Considera Devolucoes;Considera IPI;Considera ST;" SKIP.
    FOR EACH tt-nota:
        RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo Nota:" + tt-nota.nr-nota-fis).
        
        ASSIGN v_dev    = IF tt-nota.id-devolucoes   = 0 THEN STRING("Considera", "X(15)") ELSE IF tt-nota.id-devolucoes   = 9 THEN STRING("Nao Considera", "X(15)") ELSE STRING("Nao Localizado", "X(15)")
               v_ipi    = IF tt-nota.id-faturamento  = 0 THEN STRING("Sem IPI"  , "X(15)") ELSE IF tt-nota.id-faturamento  = 1 THEN STRING("Com IPI"      , "X(15)") ELSE STRING("Nao Localizado", "X(15)")
               v_st     = IF tt-nota.id-base-calculo = 0 THEN STRING("Sem ST"   , "X(15)") ELSE IF tt-nota.id-base-calculo = 1 THEN STRING("Com ST"       , "X(15)") ELSE STRING("Nao Localizado", "X(15)")
               v_base   = tt-nota.total-valor
               v_acordo = tt-nota.valor-acordo.

        IF tt-nota.id-faturamento  = 1 
           THEN ASSIGN v_base = v_base + tt-nota.total-valor-ipi.
        IF tt-nota.id-base-calculo = 1 
           THEN ASSIGN v_base = v_base + tt-nota.total-valor-st.

        IF tt-nota.id-faturamento  = 1 
           THEN ASSIGN v_acordo = v_acordo + tt-nota.valor-acordo-ipi.
        IF tt-nota.id-base-calculo = 1 
           THEN ASSIGN v_acordo = v_acordo + tt-nota.valor-acordo-st.

        PUT STREAM s-detalhado 
            tt-nota.cod-estabel      ";"
            tt-nota.serie            ";"
            tt-nota.nr-nota-fis      ";"
            tt-nota.dt-emis-nota     ";"
            tt-nota.dt-entrega       ";"
            tt-nota.nr-nota-dev      ";"
            tt-nota.dt-devol         ";"
            tt-nota.unid-neg         ";"
            tt-nota.cod-emitente     ";" 
            tt-nota.cgc              ";" 
            tt-nota.nome-matriz      ";" 
            tt-nota.nome-emit        ";" 
            tt-nota.nr-pedcli        ";" 
            tt-nota.total-liquido    ";"
            tt-nota.total-ipi        ";"
            tt-nota.total-icmsub     ";"
            v_base                   ";"
            tt-nota.perc-acordo      ";"
            v_acordo ";" 
            v_dev ";"
            v_ipi ";" 
            v_st  ";" SKIP.
    END.
    OUTPUT STREAM s-detalhado CLOSE.

    OUTPUT STREAM s-resumo TO VALUE(tt-param.diretorio + "resumo" + string(MONTH(tt-param.dt-emissao-fim)) + string(YEAR(tt-param.dt-emissao-fim)) + ".csv").
    IF tt-param.opcao-listagem = 1 THEN DO:
        ASSIGN de-valor-acordo     = 0
               de-total-liquido    = 0
               de-total-valor      = 0.
        PUT STREAM s-resumo
            "Matriz;Cliente;CNPJ;Vlr.Acordo;Vlr Tot.Liquido;Vlr Total" SKIP.
        FOR EACH tt-nota
            BREAK BY tt-nota.nome-matriz:

            IF  tt-nota.id-devolucoes <> 0
            AND tt-nota.nr-nota-dev   <> ""
                THEN. /* nao considera devolucoes */
                ELSE DO:

                     ASSIGN de-valor-acordo     = de-valor-acordo     + tt-nota.valor-acordo
                            de-total-liquido    = de-total-liquido    + tt-nota.total-liquido
                            de-total-valor      = de-total-valor      + tt-nota.total-valor.

                     /* Com IPI */
                     IF tt-nota.id-faturamento = 1
                        THEN ASSIGN de-valor-acordo = de-valor-acordo + tt-nota.valor-acordo-ipi
                                    de-total-valor  = de-total-valor  + tt-nota.total-valor-ipi.

                     /* Com ST */
                     IF tt-nota.id-base-calculo = 1
                        THEN ASSIGN de-valor-acordo = de-valor-acordo + tt-nota.valor-acordo-st
                                    de-total-valor  = de-total-valor  + tt-nota.total-valor-st.

                END.

            IF LAST-OF(tt-nota.nome-matriz) THEN DO:
                PUT STREAM s-resumo 
                    tt-nota.nome-matriz   ";"
                    tt-nota.nome-emit     ";"
                    tt-nota.cgc           ";"
                    de-valor-acordo       ";" 
                    de-total-liquido      ";" 
                    de-total-valor        SKIP.
                ASSIGN de-valor-acordo     = 0
                       de-total-liquido    = 0
                       de-total-valor      = 0.

            END.
        END.
    END.
    ELSE DO:
        IF tt-param.opcao-listagem = 2 THEN DO:
            ASSIGN de-valor-acordo = 0.
            PUT STREAM s-resumo
                "CNPJ;Cliente;Matriz;Vlr.Acordo;Vlr Tot.Liquido;Vlr Total" SKIP.
            FOR EACH tt-nota
                BREAK BY tt-nota.cgc:

                IF  tt-nota.id-devolucoes <> 0
                AND tt-nota.nr-nota-dev   <> ""
                    THEN. /* nao considera devolucoes */
                    ELSE DO:
    
                         ASSIGN de-valor-acordo     = de-valor-acordo     + tt-nota.valor-acordo
                                de-total-liquido    = de-total-liquido    + tt-nota.total-liquido
                                de-total-valor      = de-total-valor      + tt-nota.total-valor.
    
                         /* Com IPI */
                         IF tt-nota.id-faturamento = 1
                            THEN ASSIGN de-valor-acordo = de-valor-acordo + tt-nota.valor-acordo-ipi
                                        de-total-valor  = de-total-valor  + tt-nota.total-valor-ipi.
    
                         /* Com ST */
                         IF tt-nota.id-base-calculo = 1
                            THEN ASSIGN de-valor-acordo = de-valor-acordo + tt-nota.valor-acordo-st
                                        de-total-valor  = de-total-valor  + tt-nota.total-valor-st.
    
                    END.


                IF LAST-OF(tt-nota.cgc) THEN DO:
                    PUT STREAM s-resumo
                        tt-nota.cgc           ";"
                        tt-nota.nome-emit     ";"
                        tt-nota.nome-matriz   ";"
                        de-valor-acordo       ";" 
                        de-total-liquido      ";" 
                        de-total-valor        SKIP.
                    ASSIGN de-valor-acordo     = 0
                           de-total-liquido    = 0
                           de-total-valor      = 0.

                END.
            END.
        END.
        ELSE DO:
            IF tt-param.opcao-listagem = 3 THEN DO:
                ASSIGN de-valor-acordo = 0.
                PUT STREAM s-resumo
                    "Cod.Cli;Cliente;Matriz;CNPJ;Vlr.Acordo;Vlr Tot.Liquido;Vlr Total" SKIP.
                FOR EACH tt-nota
                    BREAK BY tt-nota.cod-emitente:

                    IF  tt-nota.id-devolucoes <> 0
                    AND tt-nota.nr-nota-dev   <> ""
                        THEN. /* nao considera devolucoes */
                        ELSE DO:
    
                             ASSIGN de-valor-acordo     = de-valor-acordo     + tt-nota.valor-acordo
                                    de-total-liquido    = de-total-liquido    + tt-nota.total-liquido
                                    de-total-valor      = de-total-valor      + tt-nota.total-valor.
    
                             /* Com IPI */
                             IF tt-nota.id-faturamento = 1
                                THEN ASSIGN de-valor-acordo = de-valor-acordo + tt-nota.valor-acordo-ipi
                                            de-total-valor  = de-total-valor  + tt-nota.total-valor-ipi.
    
                             /* Com ST */
                             IF tt-nota.id-base-calculo = 1
                                THEN ASSIGN de-valor-acordo = de-valor-acordo + tt-nota.valor-acordo-st
                                            de-total-valor  = de-total-valor  + tt-nota.total-valor-st.
    
                        END.

                    IF LAST-OF(tt-nota.cod-emitente) THEN DO:
                        PUT STREAM s-resumo
                            tt-nota.cod-emitente  ";"
                            tt-nota.nome-emit     ";"
                            tt-nota.nome-matriz   ";"
                            tt-nota.cgc           ";"
                            de-valor-acordo       ";" 
                            de-total-liquido      ";" 
                            de-total-valor        SKIP.
                        ASSIGN de-valor-acordo     = 0
                               de-total-liquido    = 0
                               de-total-valor      = 0.

                    END.
                END.
            END.
        END.
    END.
    OUTPUT STREAM s-resumo CLOSE.

    /*faz ajustes de valores por causa dos arredondamentos*/

    IF tt-param.tipo = 2 THEN DO:
        RUN pi-ajustes.
    END.

END PROCEDURE.

PROCEDURE piTrataRelat:

/*     IF c-unid-neg = "" THEN DO:                                               */
/*         find first unid-neg-item no-lock                                      */
/*              where unid-neg-item.it-codigo = item.it-codigo no-error.         */
/*         if avail unid-neg-item then                                           */
/*             assign c-unid-neg = unid-neg-item.cod_unid_negoc.                 */
/*         ELSE DO:                                                              */
/*             FIND FIRST unid-neg-fam-com NO-LOCK                               */
/*                  WHERE unid-neg-fam-com.fm-codigo = item.fm-cod-com NO-ERROR. */
/*             if avail unid-neg-fam-com then                                    */
/*                 assign c-unid-neg = unid-neg-fam-com.cod_unid_negoc.          */
/*             else assign c-unid-neg = "INVALIDA".                              */
/*         END.                                                                  */
/*     END.                                                                      */
    
    RUN getAcordoComercial IN h-boes464 (INPUT emitente.cgc,                 /*raiz-cnpj ou cnpj completo (ser  tratado na bo)*/
                                         INPUT nota-fiscal.cod-estabel,      /*estabelecimento*/
                                         INPUT c-unid-neg,                   /*unidade negocio*/
                                         INPUT ITEM.fm-cod-com,              /*familia comercial*/
                                         INPUT nota-fiscal.dt-emis-nota,
                                         OUTPUT i-id-faturamento-acordo,
                                         OUTPUT i-id-base-calc-acordo,
                                         OUTPUT i-id-devolucoes,
                                         OUTPUT de-perc-acordo) NO-ERROR.
END PROCEDURE.

PROCEDURE pi-ajustes:
    DEFINE VARIABLE c-periodo    AS CHARACTER                          NO-UNDO.
    DEFINE VARIABLE de-valor     AS DECIMAL   FORMAT "->>>,>>>,>>9.99" NO-UNDO.
    DEFINE VARIABLE de-diferenca AS DECIMAL   FORMAT "->>>,>>>,>>9.99" NO-UNDO.

    ASSIGN c-periodo = STRING(YEAR(tt-param.dt-emissao-ini),"9999") + STRING(MONTH(tt-param.dt-emissao-ini),"99").

    FOR EACH tt-acordo-matriz NO-LOCK:

        ASSIGN de-valor = 0.
        FOR EACH acordo-fatur NO-LOCK
           WHERE acordo-fatur.cod-estabel   = tt-param.cod-estabel-ini
             AND acordo-fatur.periodo       = c-periodo
             AND acordo-fatur.matriz        = tt-acordo-matriz.matriz
             AND acordo-fatur.num-id-titulo = 0:

            ASSIGN de-valor = de-valor + acordo-fatur.valor-acordo.
        END.

        ASSIGN de-diferenca = de-valor - ROUND(tt-acordo-matriz.valor-acordo,2).

        IF de-diferenca <> 0 THEN DO:
            FOR EACH acordo-fatur EXCLUSIVE-LOCK
               WHERE acordo-fatur.cod-estabel   = tt-param.cod-estabel-ini
                 AND acordo-fatur.periodo       = c-periodo
                 AND acordo-fatur.matriz        = tt-acordo-matriz.matriz
                 AND acordo-fatur.num-id-titulo = 0
                BY acordo-fatur.valor-acordo DESCENDING:

                ASSIGN acordo-fatur.valor-ajustes = de-diferenca
                       acordo-fatur.valor-acordo  = IF de-diferenca > 0 
                                                    THEN acordo-fatur.valor-acordo - de-diferenca 
                                                    ELSE acordo-fatur.valor-acordo + (de-diferenca * -1)
                       acordo-fatur.saldo         = acordo-fatur.valor-acordo.
                LEAVE.
            END.
        END.
    END.
    
END PROCEDURE.

PROCEDURE get-acordo-contrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT   PARAMETER p-raiz-cnpj         LIKE acordo-contrato.raiz-cnpj     NO-UNDO.
    DEFINE INPUT   PARAMETER p-cod-estabel       LIKE acordo-contrato.cod-estabel   NO-UNDO.
    DEFINE INPUT   PARAMETER p-cod-unid-neg      LIKE acordo-contrato.cod-unid-neg  NO-UNDO.
    DEFINE INPUT   PARAMETER p-fm-cod-com        LIKE acordo-contrato.fm-cod-com    NO-UNDO.
    DEFINE INPUT   PARAMETER p-data              AS DATE                            NO-UNDO.
    DEFINE OUTPUT  PARAMETER p-devolucoes        AS INT                             NO-UNDO. /* "Considera", 0, "NÆo Considera", 9, "Nao localizou" 2 */
    DEFINE OUTPUT  PARAMETER p-faturamento       AS INT                             NO-UNDO. /*   "Sem IPI", 0,       "Com IPI", 1, "Nao localizou" 2 */
    DEFINE OUTPUT  PARAMETER p-base-calculo      AS INT                             NO-UNDO. /*    "Sem ST", 0,        "Com ST", 1, "Nao localizou" 2 */

    FIND LAST acordo-contrato NO-LOCK
         WHERE acordo-contrato.raiz-cnpj      = p-raiz-cnpj
           AND (acordo-contrato.cod-estabel   = p-cod-estabel OR acordo-contrato.cod-estabel = ?)
           AND (acordo-contrato.cod-unid-neg  = p-cod-unid-neg OR acordo-contrato.cod-unid-neg = '1') /*1 ‚  TODAS*/
           AND acordo-contrato.fm-cod-com     = p-fm-cod-com
           AND acordo-contrato.data-vigencia <= p-data
           AND acordo-contrato.ativo          = YES  NO-ERROR.
    IF NOT AVAILABLE (acordo-contrato) THEN
        FIND LAST acordo-contrato NO-LOCK
             WHERE acordo-contrato.raiz-cnpj      = p-raiz-cnpj
               AND (acordo-contrato.cod-estabel   = p-cod-estabel OR acordo-contrato.cod-estabel = ?)
               AND (acordo-contrato.cod-unid-neg  = p-cod-unid-neg OR acordo-contrato.cod-unid-neg = '1') /*1 ‚  TODAS*/
               AND acordo-contrato.fm-cod-com     = ?
               AND acordo-contrato.data-vigencia <= p-data
               AND acordo-contrato.ativo          = YES NO-ERROR.
    IF NOT AVAILABLE (acordo-contrato) THEN
        FIND LAST acordo-contrato NO-LOCK
             WHERE acordo-contrato.raiz-cnpj      = SUBSTRING(p-raiz-cnpj,1,8)
               AND (acordo-contrato.cod-estabel   = p-cod-estabel OR acordo-contrato.cod-estabel = ?)
               AND (acordo-contrato.cod-unid-neg  = p-cod-unid-neg OR acordo-contrato.cod-unid-neg = '1') /*1 ‚ TODAS*/
               AND acordo-contrato.fm-cod-com     = p-fm-cod-com
               AND acordo-contrato.data-vigencia <= p-data
               AND acordo-contrato.ativo          = YES  NO-ERROR.
    IF NOT AVAILABLE (acordo-contrato) THEN
        FIND LAST acordo-contrato NO-LOCK
             WHERE acordo-contrato.raiz-cnpj      = SUBSTRING(p-raiz-cnpj,1,8)
               AND (acordo-contrato.cod-estabel   = p-cod-estabel OR acordo-contrato.cod-estabel = ?)
               AND (acordo-contrato.cod-unid-neg  = p-cod-unid-neg OR acordo-contrato.cod-unid-neg = '1') /*1 ‚ TODAS*/
               AND acordo-contrato.fm-cod-com     = ?
               AND acordo-contrato.data-vigencia <= p-data
               AND acordo-contrato.ativo          = YES NO-ERROR.
    IF AVAILABLE (acordo-contrato) 
    THEN DO:
         ASSIGN p-devolucoes   = acordo-contrato.id-devolucoes
                p-faturamento  = acordo-contrato.id-faturamento
                p-base-calculo = acordo-contrato.id-base-calculo.
    END.
    ELSE DO:
         ASSIGN p-devolucoes   = 2
                p-faturamento  = 2
                p-base-calculo = 2.
    END.


END PROCEDURE.
