{esp/es0018.i}
{esp/esb/out/msg0285.i}

DEFINE VARIABLE h-acomp  AS HANDLE           NO-UNDO.
DEFINE VARIABLE chExcel  AS COMPONENT-HANDLE NO-UNDO.
DEFINE VARIABLE chWBook  AS COMPONENT-HANDLE NO-UNDO.
DEFINE VARIABLE chWSheet AS COMPONENT-HANDLE NO-UNDO.
DEFINE VARIABLE chChart  AS COMPONENT-HANDLE NO-UNDO.
DEFINE VARIABLE i-linha  AS INTEGER          NO-UNDO.

DEFINE VARIABLE v-tot-perc-un        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-variavel-un    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-vl-faturado    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-vl-sellout     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-vl-fat-total   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-vl-meta        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-perc-ating     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i-num-perc-ating     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-vl-carteira    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-perc-ating-ca  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i-num-perc-ating-ca  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-vl-var-apagar  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-vl-bonus-mix   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-vl-rollout-tri AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-perc-ating-tri AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i-num-perc-ating-tri AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-log-meta-tri   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v-tot-vl-rnm-variav  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-vl-rnm-bonus   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-vl-rnm-tot     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-vl-bonus-sup   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-vl-var-tot     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-vl-salario     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-salario-base      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-variavel       AS DECIMAL     NO-UNDO.


DEF VAR l-devolucao          AS LOGICAL NO-UNDO.
DEF VAR l-prim               AS LOGICAL NO-UNDO.
DEF VAR l-inadimp            AS LOGICAL NO-UNDO.
DEF VAR l-bonus-mix-tri      AS LOGICAL NO-UNDO.
DEF VAR l-bonusmix           AS LOGICAL NO-UNDO.

DEF VAR dt-aux               AS DATE    NO-UNDO.
DEF VAR c-unid               AS CHAR    NO-UNDO.

DEF VAR de-rollout           AS DECIMAL NO-UNDO.
DEF VAR de-fat-tri           AS DECIMAL NO-UNDO.
DEF VAR de-meta-tri          AS DECIMAL NO-UNDO.
DEF VAR de-rnm               AS DECIMAL NO-UNDO.
DEF VAR de-tot-variavel      AS DECIMAL NO-UNDO. 
DEF VAR de-vlr-mes           AS DECIMAL NO-UNDO. 
DEF VAR de-rnm-bonus-tri     AS DECIMAL NO-UNDO.

DEF VAR i-mes-ini            AS INTEGER NO-UNDO.
DEF VAR i-aux                AS INTEGER NO-UNDO.
DEF VAR i-qtd-un             AS INTEGER NO-UNDO.

DEFINE TEMP-TABLE tt-matricula NO-UNDO
    FIELD idi-tipo  AS INT
    FIELD codigo    AS INT
    FIELD mes-periodo AS INT
    FIELD ano-periodo AS INT.

DEFINE TEMP-TABLE tt-valores-integracao NO-UNDO
    FIELD cod-sup-excec AS INT
    FIELD id-tipo       AS INT
    FIELD vl-fixo       AS DEC
    FIELD vl-variavel   AS DEC.

define temp-table tt-param no-undo
    field destino           as integer
    field arquivo           as char format "x(35)"
    field usuario           as char format "x(12)"
    field data-exec         as date
    field hora-exec         as integer
    field classifica        as integer
    field desc-classifica   as char format "x(40)"
    field modelo-rtf        as char format "x(35)"
    field l-habilitaRtf     as LOG
    FIELD periodo-mes       AS INT
    FIELD periodo-ano       AS INT
    FIELD cod-rep-ini       AS INT
    FIELD cod-rep-fim       AS INT
    FIELD id-opcao          AS INT.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

DEF TEMP-TABLE tt-comissao
    FIELD cod-repres        LIKE nota-fiscal.cod-rep
    FIELD cod-unid-negoc    LIKE comissao-fat.unid-neg
    FIELD cod-segmento      LIKE int-meta-repres.cod-segmento
    FIELD id-tipo           AS INT
    FIELD it-codigo         LIKE int-meta-repres.it-codigo
    FIELD cod-superv        LIKE int-supervisor.cod-supervisor
    FIELD vl-fixo           AS DECIMAL FORMAT '>>>,>>>,>>9.99'
    FIELD vl-variavel       AS DECIMAL FORMAT '>>>,>>>,>>9.99'
    FIELD perc-un           AS DECIMAL FORMAT '>>>,>>>,>>9.99'
    FIELD variavel-un       AS DECIMAL FORMAT '>>>,>>>,>>9.99'
    FIELD vl-meta           AS DECIMAL FORMAT '>>>,>>>,>>9.99' 
    FIELD vl-faturado       AS DECIMAL FORMAT '>>>,>>>,>>9.99' 
    FIELD vl-sellout        AS DECIMAL FORMAT '>>>,>>>,>>9.99' 
    FIELD vl-fat-total      AS DECIMAL FORMAT '>>>,>>>,>>9.99' 
    FIELD perc-ating        AS DECIMAL FORMAT '>>>,>>>,>>9.99' 
    FIELD vl-carteira       AS DECIMAL FORMAT '>>>,>>>,>>9.99' 
    FIELD perc-ating-ca     AS DECIMAL FORMAT '>>>,>>>,>>9.99' 
    FIELD vl-var-apagar     AS DECIMAL FORMAT '>>>,>>>,>>9.99' 
    FIELD vl-bonus-mix      AS DECIMAL FORMAT '>>>,>>>,>>9.99' 
    FIELD vl-rollout-tri    AS DECIMAL FORMAT '>>>,>>>,>>9.99' 
    FIELD perc-ating-tri    AS DECIMAL FORMAT '>>>,>>>,>>9.99' 
    FIELD log-meta-tri      AS LOGICAL FORMAT "Sim/NÆo" 
    FIELD vl-rnm-variav     AS DECIMAL FORMAT '>>>,>>>,>>9.99' 
    FIELD vl-rnm-bonus      AS DECIMAL FORMAT '>>>,>>>,>>9.99' 
    FIELD vl-rnm-tot        AS DECIMAL FORMAT '>>>,>>>,>>9.99' 
    FIELD vl-bonus-sup      AS DECIMAL FORMAT '>>>,>>>,>>9.99' 
    FIELD vl-var-tot        AS DECIMAL FORMAT '>>>,>>>,>>9.99'
    FIELD vl-salario        AS DECIMAL FORMAT '>>>,>>>,>>9.99'.

DEF TEMP-TABLE tt-unidade   LIKE tt-comissao.

DEF BUFFER b-comis-un            FOR tt-unidade.   
DEF BUFFER b-comissao            FOR tt-comissao.
DEF BUFFER b-aux-com             FOR tt-unidade.
DEF BUFFER b-int-execsuperv-calc FOR int-execsuperv-calc.

/* CREATE tt-param.                    */
/* ASSIGN tt-param.periodo-ano = 2017  */
/*        tt-param.periodo-mes = 12    */
/*        tt-param.cod-rep-ini = 1381  */
/*        tt-param.cod-rep-fim = 1381. */

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
  
   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Iniciando calculo de comiss„es...").
     
   /** verifica parametro comiss’o **/
   FIND FIRST int-param-comis 
        WHERE int-param-comis.periodo-ano = tt-param.periodo-ano
          AND int-param-comis.periodo-mes = tt-param.periodo-mes NO-LOCK NO-ERROR.
   IF AVAIL int-param-comis THEN
      ASSIGN l-devolucao = int-param-comis.log-considera-devol
             l-inadimp   = int-param-comis.log-considera-inadimp.
    
    IF tt-param.id-opcao = 1 THEN DO: /* calcular */

       run pi-inicializar in h-acomp (input "Buscando metas dos Executivos...").
       RUN pi-apura-metas.            /* Somatoria das metas por executivo / UN / Segmento / Item     */
       
       RUN pi-cria-Un.                /* Cria tabela auxiliar acumulando UN de cada executivo         */
       
       run pi-inicializar in h-acomp (input "Buscando vendas SellOut dos Executivos...").
       RUN pi-sell-out.               /* Somatoria dos valores de sell-out dos executivos             */
       
       run pi-inicializar in h-acomp (input "Buscando valores em carteira dos Executivos...").
       RUN pi-carteira.               /* Verifica os pedidos em carteira para cada item/segm/un       */ 
       
       run pi-inicializar in h-acomp (input "Buscando valores faturados dos Executivos...").
       RUN pi-faturado.               /* Verifica faturamento do executivo para cada UN/Seg/Item      */
       
       run pi-inicializar in h-acomp (input "Buscando devolu‡äes...").
       RUN pi-devolucao.              /* Verifica devolu»„es do periodo e desconta do Vl Faturado     */
       
       run pi-inicializar in h-acomp (input "Buscando debitos e cr‚ditos...").
       RUN pi-debito-credito.         /* Adicona/Debita valores da base de faturamento do executivo   */
    
       RUN pi-acumula-un.             /* Realiza o calculo dos percentuais acumulados por UN          */
       RUN pi-cria-supervisores.      /* Soma valores dos executivos para o Supervisor direto         */
    
       RUN pi-bonus-mix.              /* Calcula o bonus mix do mes para os executivos e supervisores */
       RUN pi-calcula-trimestre.      /* Gera os excedentes do mes atual para compor o trimestre      */   
    
       /*
       IF int-param-comis.periodo-mes = 3  OR
          int-param-comis.periodo-mes = 6  OR
          int-param-comis.periodo-mes = 9  OR
          int-param-comis.periodo-mes = 12 
          THEN RUN pi-fecha-trimestre.
       */
    
       run pi-inicializar in h-acomp (input "Imprimindo...").
       
       RUN pi-grava-comissao.         /* Grava os registros na tabela */

       /*RUN pi-imprime-comis.*/
       RUN pi-excel.
       
       run pi-finalizar in h-acomp.
       RETURN "OK".
   END.
   ELSE DO : /* excluir */
       IF int-param-comis.idi-status = 3 THEN DO:
           /* mensagem que comiss’o ja foi integrada com o senior */
           RUN utp/msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Per¡odo j  integrado com o Senior, exclusÆo nÆo permitida.").
       END.
       ELSE                                                             
         RUN pi-exclui-comissao.

   END.
   RUN pi-finalizar in h-acomp.
   RETURN "OK".
end.


PROCEDURE pi-apura-metas:

    FOR EACH int-execsuperv-calc NO-LOCK
       WHERE int-execsuperv-calc.periodo-ano    = tt-param.periodo-ano
         AND int-execsuperv-calc.periodo-mes    = tt-param.periodo-mes
         AND int-execsuperv-calc.cod-sup-exec  >= tt-param.cod-rep-ini
         AND int-execsuperv-calc.cod-sup-exec  <= tt-param.cod-rep-fim
         AND int-execsuperv-calc.idi-tipo   = 1
         AND int-execsuperv-calc.dt-calculo = ?:

       /*** busca as metas dos representantes ***/
       FOR EACH INT-meta-repres NO-LOCK
          WHERE int-meta-repres.periodo-ano = int-execsuperv-calc.periodo-ano
            AND int-meta-repres.periodo-mes = int-execsuperv-calc.periodo-mes
            AND int-meta-repres.codigo      = int-execsuperv-calc.cod-sup-exec:

           RUN pi-acompanhar IN h-acomp (INPUT "Repres:" + string(int-meta-repres.codigo) ).

           FIND FIRST tt-comissao
                WHERE tt-comissao.cod-repres    = int-meta-repres.codigo
                 AND tt-comissao.id-tipo        = int-execsuperv-calc.idi-tipo /* executivo */
                 AND tt-comissao.cod-unid-negoc = int-meta-repres.cod-unid-negoc 
                 AND tt-comissao.cod-segmento   = int-meta-repres.cod-segmento 
                 AND tt-comissao.it-codigo      = int-meta-repres.it-codigo NO-ERROR.
           IF NOT AVAIL tt-comissao THEN DO:
              CREATE tt-comissao.
              ASSIGN tt-comissao.cod-repres     = int-meta-repres.codigo
                     tt-comissao.cod-unid-negoc = int-meta-repres.cod-unid-negoc
                     tt-comissao.cod-segmento   = int-meta-repres.cod-segmento
                     tt-comissao.it-codigo      = int-meta-repres.it-codigo
                     tt-comissao.id-tipo        = 1.
              FIND FIRST int-exec-superv
                   where int-exec-superv.cod-executivo = int-meta-repres.codigo 
                     AND int-exec-superv.dt-termino    = ? NO-LOCK NO-ERROR.
              IF AVAIL int-exec-superv THEN DO:
                 ASSIGN tt-comissao.cod-superv = int-exec-superv.cod-superv.
              END.
           END.
           ASSIGN tt-comissao.vl-meta = tt-comissao.vl-meta + int-meta-repres.vl-meta.
       END.
    END.

END PROCEDURE.

PROCEDURE pi-cria-un:

   /*** cria tabela auxiliar para acumular por unidade de negocio **/
   FOR EACH tt-comissao 
       BREAK BY tt-comissao.cod-rep
             BY tt-comissao.id-tipo
             BY tt-comissao.cod-unid-negoc.
     
       IF FIRST-OF(tt-comissao.cod-rep) THEN DO:
          ASSIGN i-qtd-un = 0.
            
          RUN pi-acompanhar IN h-acomp (INPUT "Integrando Senior Repres:" + string(tt-comissao.cod-repres) ).
          RUN pi-busca-valores-senior (INPUT tt-comissao.cod-repres,
                                       INPUT tt-comissao.id-tipo,
                                       INPUT tt-param.periodo-mes,
                                       INPUT tt-param.periodo-ano,
                                       OUTPUT de-salario-base,
                                       OUTPUT de-vl-variavel).   /* Busca os valores de salario do Senior, atraves do barramento */ 
       END.  

       IF FIRST-OF(tt-comissao.cod-unid-negoc) THEN DO:
          CREATE tt-unidade.
          ASSIGN tt-unidade.cod-repres     = tt-comissao.cod-repres
                 tt-unidade.id-tipo        = tt-comissao.id-tipo
                 tt-unidade.cod-unid-negoc = tt-comissao.cod-unid-negoc
                 tt-unidade.vl-fixo        = de-salario-base
                 tt-unidade.vl-variavel    = de-vl-variavel.

          ASSIGN i-qtd-un = i-qtd-un + 1.
       
        END.

       IF LAST-OF(tt-comissao.cod-unid-neg) THEN DO:
          FOR EACH tt-unidade
             WHERE tt-unidade.cod-rep = tt-comissao.cod-rep
               AND tt-unidade.id-tipo = tt-comissao.id-tipo:
            ASSIGN tt-unidade.perc-un     = 100 / i-qtd-un
                   tt-unidade.variavel-un = tt-unidade.vl-variavel / i-qtd-un.
          END.
       END.
   END.
END.


PROCEDURE pi-cria-supervisores:
   
    /*** cria os valores acumulados para os supervisores, de acordo com os representantes associados a ele ***/
    FOR EACH int-supervisor NO-LOCK,
       FIRST int-execsuperv-calc NO-LOCK
       WHERE int-execsuperv-calc.periodo-mes  = tt-param.periodo-mes
         AND int-execsuperv-calc.periodo-ano  = tt-param.periodo-ano
         AND int-execsuperv-calc.cod-sup-exec = int-supervisor.cod-supervisor
         AND int-execsuperv-calc.idi-tipo = 2,  /* supervisor */
       FIRST int-exec-superv NO-LOCK
       WHERE int-exec-superv.cod-supervisor =  int-supervisor.cod-supervisor
         AND int-exec-superv.dt-inicio     <= int-param-comis.dt-periodo-ini
         AND int-exec-superv.dt-termino     = ? 
       BREAK BY int-exec-superv.cod-supervisor :

        IF FIRST-OF (int-exec-superv.cod-supervisor) THEN DO:
            IF NOT CAN-FIND (FIRST tt-valores-integracao
                             WHERE tt-valores-integracao.cod-sup-excec = int-exec-superv.cod-supervisor
                               AND tt-valores-integracao.id-tipo       = 2) THEN DO:
            
                RUN pi-acompanhar IN h-acomp (INPUT "Integrando Senior Supervisor:" + string(int-exec-superv.cod-supervisor)).
                RUN pi-busca-valores-senior (INPUT int-exec-superv.cod-supervisor,
                                             INPUT 2,
                                             INPUT tt-param.periodo-mes,
                                             INPUT tt-param.periodo-ano,
                                             OUTPUT de-salario-base,
                                             OUTPUT de-vl-variavel).   /* Busca os valores de salario do Senior, atraves do barramento */
    
                CREATE tt-valores-integracao.
                ASSIGN tt-valores-integracao.cod-sup-excec = int-exec-superv.cod-supervisor
                       tt-valores-integracao.id-tipo       = 2
                       tt-valores-integracao.vl-fixo       = de-salario-base
                       tt-valores-integracao.vl-variavel   = de-vl-variavel.
            END.
        END.
     
       FOR EACH tt-comissao 
           WHERE tt-comissao.cod-superv = int-exec-superv.cod-superv
             AND tt-comissao.id-tipo = 1
           BREAK BY tt-comissao.cod-superv
                 BY tt-comissao.id-tipo
                 BY tt-comissao.cod-unid-negoc.

          IF FIRST-OF(tt-comissao.cod-superv) THEN
             ASSIGN i-qtd-un = 0.

          IF FIRST-OF(tt-comissao.cod-unid-negoc) THEN DO:
             FIND FIRST tt-unidade
                  WHERE tt-unidade.cod-repres     = int-exec-superv.cod-supervisor
                    AND tt-unidade.id-tipo        = 2
                    AND tt-unidade.cod-unid-negoc = tt-comissao.cod-unid-negoc  NO-ERROR.
             IF NOT AVAIL tt-unidade THEN  DO:

                FIND FIRST tt-valores-integracao
                     WHERE tt-valores-integracao.cod-sup-excec = int-exec-superv.cod-supervisor
                       AND tt-valores-integracao.id-tipo       = 2 NO-ERROR.
                  
                CREATE tt-unidade.
                ASSIGN tt-unidade.cod-repres     = int-exec-superv.cod-supervisor
                       tt-unidade.id-tipo        = 2
                       tt-unidade.cod-unid-negoc = tt-comissao.cod-unid-negoc
                       tt-unidade.vl-fixo        = tt-valores-integracao.vl-fixo
                       tt-unidade.vl-variavel    = tt-valores-integracao.vl-variavel.
             END.
             ASSIGN i-qtd-un = i-qtd-un + 1.
          END.

          ASSIGN tt-unidade.vl-faturado      = tt-unidade.vl-faturado     + tt-comissao.vl-faturado         
                 tt-unidade.vl-sellout       = tt-unidade.vl-sellout      + tt-comissao.vl-sellout          
                 tt-unidade.vl-fat-total     = tt-unidade.vl-fat-total    + tt-comissao.vl-fat-total        
                 tt-unidade.vl-meta          = tt-unidade.vl-meta         + tt-comissao.vl-meta             
                 tt-unidade.vl-carteira      = tt-unidade.vl-carteira     + tt-comissao.vl-carteira.         

          IF LAST-OF(tt-comissao.cod-unid-neg) THEN DO:
             FOR EACH tt-unidade
                WHERE tt-unidade.cod-rep = int-exec-superv.cod-supervisor
                  AND tt-unidade.id-tipo = 2:
                 
                ASSIGN tt-unidade.perc-un     = 100 / i-qtd-un
                       tt-unidade.variavel-un = tt-unidade.vl-variavel / i-qtd-un.

                ASSIGN tt-unidade.perc-ating       = (tt-unidade.vl-faturado / tt-unidade.vl-meta) * 100.      
                        
                IF int-param-comis.log-considera-carteira = YES AND 
                   tt-unidade.perc-ating                 >= int-param-comis.Perc-ating-meta-bonusmix AND
                   tt-unidade.perc-ating                  < 100 THEN
                   ASSIGN tt-unidade.perc-ating-ca        = ((tt-unidade.vl-fat-total + tt-unidade.vl-carteira) / tt-unidade.vl-meta) * 100.
                
                     
                ASSIGN tt-unidade.vl-var-apagar  = IF tt-unidade.perc-ating >= 100  
                                                   THEN tt-unidade.variavel-un  
                                                   ELSE tt-unidade.variavel-un * tt-unidade.perc-ating / 100
                       tt-unidade.perc-ating-tri   = 0      
                       tt-unidade.log-meta-tri     = NO.       
             END.
          END.
       END.
    END.
END PROCEDURE.


PROCEDURE pi-sell-out:

   FOR EACH tt-comissao :
        FOR EACH int-sell-out
           WHERE int-sell-out.codigo         = tt-comissao.cod-repres  
             AND int-sell-out.cod-unid-negoc = tt-comissao.cod-unid-negoc  
             AND int-sell-out.cod-segmento   = tt-comissao.cod-segmento    
             AND int-sell-out.idi-tipo        = 1:
         ASSIGN tt-comissao.vl-sellout = tt-comissao.vl-sellout + int-sell-out.vl-vendida.
       
      END.
   END.

END PROCEDURE.


PROCEDURE pi-carteira:

    IF int-param-comis.log-considera-carteira = YES THEN DO:
       ASSIGN dt-aux = int-param-comis.dt-periodo-fim.
       IF int-param-comis.dia-carteira > 0 THEN DO:
          IF MONTH(int-param-comis.dt-periodo-fim) = 12 
             THEN ASSIGN dt-aux = DATE(01,int-param-comis.dia-carteira,YEAR(int-param-comis.dt-periodo-fim) + 1).
             ELSE ASSIGN dt-aux = DATE(MONTH(int-param-comis.dt-periodo-fim) + 1,int-param-comis.dia-carteira,YEAR(int-param-comis.dt-periodo-fim)).
       END.
       OUTPUT TO c:\temp\pedido.csv.

       /*** acumula valores em carteira para o executivo ***/
       FOR EACH ped-venda NO-LOCK
          WHERE ped-venda.cod-sit-ped <= 2 
            AND ped-venda.dt-implant  >= 01/01/2017
            AND ped-venda.dt-implant  <= dt-aux ,
          FIRST repres NO-LOCK 
          WHERE repres.nome-abrev      = ped-venda.no-ab-reppri 
            AND repres.cod-rep        >= tt-param.cod-rep-ini
            AND repres.cod-rep        <= tt-param.cod-rep-fim,
           EACH ped-item OF ped-venda
          WHERE ped-item.cod-sit-item <= 2 NO-LOCK:
    
          /* valida se pedido gera duplicata */
          FIND FIRST natur-oper 
               WHERE natur-oper.nat-operacao = ped-venda.nat-operacao.
          IF NOT AVAIL natur-oper OR
             natur-oper.emite-duplic = NO THEN NEXT.

          IF ped-venda.cod-priori = 44 THEN NEXT.

          FIND FIRST ITEM
               WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.
    
          RUN pi-acompanhar IN h-acomp (INPUT "Data:" + string(ped-venda.dt-implant,"99/99/9999") ).
    
          FIND FIRST tt-comissao
               WHERE tt-comissao.cod-repres     = repres.cod-rep
                 AND tt-comissao.id-tipo        = 1
                 AND tt-comissao.cod-unid-negoc = ped-ITEM.cod-unid-neg
                 AND tt-comissao.cod-segmento   = int(substr(ITEM.fm-cod-com,1,4))
                 AND tt-comissao.it-codigo      = ped-item.it-codigo NO-ERROR.
          IF NOT AVAIL tt-comissao THEN
              FIND FIRST tt-comissao
                   WHERE tt-comissao.cod-repres     = repres.cod-rep    
                     AND tt-comissao.id-tipo        = 1
                     AND tt-comissao.cod-unid-negoc = ped-ITEM.cod-unid-neg            
                     AND tt-comissao.cod-segmento   = int(substr(ITEM.fm-cod-com,1,4)) 
                     AND tt-comissao.it-codigo      = '*' NO-ERROR.
          IF AVAIL tt-comissao THEN DO:
             ASSIGN tt-comissao.vl-carteira = tt-comissao.vl-carteira + ped-item.vl-liq-abe.

             PUT  ped-venda.no-ab-rep                 ';'
                  ped-item.cod-unid-neg ';'
                  int(substr(ITEM.fm-cod-com,1,4)) ';'
                  ped-item.nr-pedcli ';'
                  ped-item.nome-abrev ';'
                  ped-venda.dt-implant ';'
                  ped-item.it-codigo ';'
                  ped-item.vl-liq-abe ';' SKIP.

          END.
       END.
    END.
    OUTPUT CLOSE.

END PROCEDURE.


PROCEDURE pi-faturado:

    /*** acumula valor faturado por executivo ***/
    OUTPUT TO c:\temp\notas.csv.
    PUT 'Estab;Serie;Nr Nota;Dt Emissao;Executivo;Unid Neg;Segmento;Produto;Valor' SKIP.
    for each nota-fiscal NO-LOCK
       WHERE nota-fiscal.dt-emis       >= int-param-comis.dt-periodo-ini
         AND nota-fiscal.dt-emis       <= int-param-comis.dt-periodo-fim 
         AND nota-fiscal.dt-cancela     = ?
         AND nota-fiscal.emite-duplic   = YES
         AND nota-fiscal.cod-rep       >= tt-param.cod-rep-ini
         AND nota-fiscal.cod-rep       <= tt-param.cod-rep-fim,
        EACH it-nota-fisc OF nota-fiscal NO-LOCK:
    
       RUN pi-acompanhar IN h-acomp (INPUT "Selecionando data:" + string(nota-fiscal.dt-emis,"99/99/9999") + " - "+ nota-fiscal.nr-nota-fis).
    
      /*
       IF NOT l-inadimp AND 
          comissao-fat.id-tipo-inform = 4 /* inadimplencia */ THEN NEXT.
          */
       
       FIND FIRST ITEM
            WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.
    
       FIND FIRST tt-comissao
            WHERE tt-comissao.cod-repres     = nota-fiscal.cod-rep
              AND tt-comissao.id-tipo        = 1
              AND tt-comissao.cod-unid-negoc = it-nota-fisc.cod-unid-neg
              AND tt-comissao.cod-segmento   = int(substr(ITEM.fm-cod-com,1,4))
              AND tt-comissao.it-codigo      = it-nota-fisc.it-codigo NO-ERROR.
       IF NOT AVAIL tt-comissao THEN
          FIND FIRST tt-comissao
               WHERE tt-comissao.cod-repres     = nota-fiscal.cod-rep
                 AND tt-comissao.id-tipo        = 1
                 AND tt-comissao.cod-unid-negoc = it-nota-fisc.cod-unid-neg
                 AND tt-comissao.cod-segmento   = int(substr(ITEM.fm-cod-com,1,4))
                 AND tt-comissao.it-codigo      = '*' NO-ERROR.
       
       IF AVAIL tt-comissao  THEN DO:
          ASSIGN tt-comissao.vl-faturado = tt-comissao.vl-faturado + it-nota-fisc.vl-merc-liq.
          PUT nota-fiscal.cod-estabel ';'
              nota-fiscal.serie ';'
              nota-fiscal.nr-nota-fis ';'
              nota-fiscal.dt-emis-nota ';'
              tt-comissao.cod-rep ';'
              it-nota-fisc.cod-unid-neg ';'
              tt-comissao.cod-segmento    ';' 
              tt-comissao.it-codigo  ';'
              it-nota-fisc.vl-merc-liq   SKIP .
       END.
    END.
    OUTPUT CLOSE.
    
    OUTPUT TO c:\temp\segmento.csv.
    PUT 'Executivo;Segmento;Faturamento;SellOut;Meta;Carteira' SKIP.
    FOR EACH tt-comissao :
        PUT tt-comissao.cod-rep ';'
            tt-comissao.cod-segmento    ';' 
             tt-comissao.vl-faturado       ';' 
            tt-comissao.vl-sellout        ';' 
            tt-comissao.vl-meta           ';' 
            tt-comissao.vl-carteira       ';'    SKIP .
    END.
    OUTPUT CLOSE.
END PROCEDURE.


PROCEDURE pi-devolucao:
    
    /*** verifica devolu»„es ocorridas no periodo ***/
    OUTPUT TO c:\temp\devolucoes.csv.
    PUT 'Estab;Serie;Nota;Executivo;Unid Neg;Segmento;Produto;Valor' SKIP.

    IF l-devolucao = YES THEN DO:
       FOR EACH devol-cli NO-LOCK
          WHERE devol-cli.dt-devol     >= int-param-comis.dt-periodo-ini
            AND devol-cli.dt-devol     <= int-param-comis.dt-periodo-fim,
          FIRST nota-fiscal  NO-LOCK
          WHERE nota-fiscal.cod-rep    >= tt-param.cod-rep-ini
            AND nota-fiscal.cod-rep    <= tt-param.cod-rep-fim
            AND nota-fiscal.cod-estabel = devol-cli.cod-estabel
            AND nota-fiscal.serie       = devol-cli.serie
            AND nota-fiscal.nr-nota-fis = devol-cli.nr-nota-fis
            AND nota-fiscal.emite-duplic,
          FIRST item-doc-est OF devol-cli NO-LOCK,
          FIRST ITEM 
          WHERE ITEM.it-codigo = devol-cli.it-codigo NO-LOCK:
         
          RUN pi-acompanhar IN h-acomp (INPUT "Selecionando data:" + string(nota-fiscal.dt-emis,"99/99/9999") + " - "+ nota-fiscal.nr-nota-fis).
    
          IF item-doc-est.cod-unid-neg = '' THEN DO:
             FIND FIRST item-uni-estab 
                  WHERE item-uni-estab.cod-estabel = devol-cli.cod-estabel
                    AND item-uni-estab.it-codigo = devol-cli.it-codigo NO-LOCK NO-ERROR.
             IF AVAIL item-uni-estab 
                THEN c-unid = item-uni-estab.cod-unid-neg.
                ELSE c-unid =  item-doc-est.cod-unid-neg.
          END.
    
          FIND FIRST tt-comissao
               WHERE tt-comissao.cod-repres     = nota-fiscal.cod-rep
                 AND tt-comissao.id-tipo        = 1
                 AND tt-comissao.cod-unid-negoc = c-unid
                 AND tt-comissao.cod-segmento   = int(substr(ITEM.fm-cod-com,1,4))
                 AND tt-comissao.it-codigo      = item-doc-est.it-codigo NO-ERROR.
          IF NOT AVAIL tt-comissao THEN
             FIND FIRST tt-comissao
                  WHERE tt-comissao.cod-repres     = nota-fiscal.cod-rep
                    AND tt-comissao.id-tipo        = 1
                    AND tt-comissao.cod-unid-negoc = c-unid
                    AND tt-comissao.cod-segmento   = int(substr(ITEM.fm-cod-com,1,4))
                    AND tt-comissao.it-codigo      = '*' NO-ERROR.
           
          IF AVAIL tt-comissao  THEN DO:
             ASSIGN tt-comissao.vl-faturado = tt-comissao.vl-faturado - item-doc-est.preco-total[1].

             IF tt-comissao.vl-faturado < 0 THEN 
                 ASSIGN tt-comissao.vl-faturado = 0. 
    
             PUT nota-fiscal.cod-estabel     ';'
                 nota-fiscal.serie           ';'
                 nota-fiscal.nr-nota-fis     ';'
                 nota-fiscal.nome-abrev      ';'
                 tt-comissao.cod-rep         ';'
                 c-unid                      ';'
                 tt-comissao.cod-segmento    ';' 
                 tt-comissao.it-codigo       ';'
                 item-doc-est.preco-total[1]  SKIP .
    
          END.
       END.
    END.
    OUTPUT CLOSE.
END PROCEDURE.


PROCEDURE pi-debito-credito:

    /*** Adiciona valores na base de calculo ***/
    FOR EACH tt-comissao:
       
       ASSIGN tt-comissao.vl-fat-total = tt-comissao.vl-sellout + tt-comissao.vl-faturado.
        
       RUN pi-acompanhar IN h-acomp (INPUT "Representante: " + STRING(tt-comissao.cod-repres)).
    
       FOR EACH int-comissao-adc
          WHERE int-comissao-adc.periodo-ano    = tt-param.periodo-ano                      
            AND int-comissao-adc.periodo-mes    = tt-param.periodo-mes  
            AND int-comissao-adc.codigo         = tt-comissao.cod-repres
            AND int-comissao-adc.idi-tipo       = tt-comissao.id-tipo  /* executivo , supervisor */
            AND int-comissao-adc.cod-unid-negoc = tt-comissao.cod-unid-negoc
            AND int-comissao-adc.cod-segmento   = tt-comissao.cod-segmento NO-LOCK :
          
          IF int-comissao-adc.idi-lancto = 1
             THEN ASSIGN tt-comissao.vl-faturado    = tt-comissao.vl-faturado    - int-comissao-adc.vl-base    
                         tt-comissao.vl-fat-total   = tt-comissao.vl-fat-total   - int-comissao-adc.vl-base.  /* DB */
             ELSE ASSIGN tt-comissao.vl-faturado    = tt-comissao.vl-faturado    + int-comissao-adc.vl-base    
                         tt-comissao.vl-fat-total   = tt-comissao.vl-fat-total   + int-comissao-adc.vl-base.  /* CR */
       END.
       ASSIGN tt-comissao.perc-ating    = (tt-comissao.vl-fat-total / tt-comissao.vl-meta) * 100.
    END.

END PROCEDURE. 


PROCEDURE pi-acumula-un:

    FOR EACH tt-unidade 
    BREAK BY tt-unidade.cod-rep
          BY tt-unidade.cod-unid-negoc.

       FOR EACH tt-comissao
          WHERE tt-comissao.cod-rep = tt-unidade.cod-rep
            AND tt-comissao.cod-unid-neg = tt-unidade.cod-unid-neg:

          ASSIGN tt-unidade.vl-faturado      = tt-unidade.vl-faturado     + tt-comissao.vl-faturado         
                 tt-unidade.vl-sellout       = tt-unidade.vl-sellout      + tt-comissao.vl-sellout          
                 tt-unidade.vl-fat-total     = tt-unidade.vl-fat-total    + tt-comissao.vl-fat-total        
                 tt-unidade.vl-meta          = tt-unidade.vl-meta         + tt-comissao.vl-meta             
                 tt-unidade.vl-carteira      = tt-unidade.vl-carteira     + tt-comissao.vl-carteira .        
       END.
      
       ASSIGN tt-unidade.perc-ating       = (tt-unidade.vl-faturado     / tt-unidade.vl-meta) * 100.    

      /*** neste momento verifica se o faturamento estÿ entre 100% e o percentual mimino para atingimento de meta. Caso esteja, 
           soma os valores que o executivo possui em carteira. Caso contrÿrio, zera a carteria do executivo.  ***/
       IF int-param-comis.log-considera-carteira = YES AND 
          tt-unidade.perc-ating >= int-param-comis.Perc-ating-meta-bonusmix /*AND
          tt-unidade.perc-ating < 100*/ THEN
          ASSIGN tt-unidade.perc-ating-ca    = ((tt-unidade.vl-fat-total + tt-unidade.vl-carteira) / tt-unidade.vl-meta) * 100.
      

       ASSIGN tt-unidade.vl-var-apagar    = IF tt-unidade.perc-ating >= 100  
                                            THEN tt-unidade.variavel-un  
                                            ELSE tt-unidade.variavel-un * tt-unidade.perc-ating / 100
              tt-unidade.perc-ating-tri   = 0      
              tt-unidade.log-meta-tri     = NO.       
    END.
END PROCEDURE.


PROCEDURE pi-bonus-mix:
    
   /* Bonus Mix - verifica se todos os percentuais est’o acima de 100%. Caso sim, paga o valor adicional de uma unidade. */
   FOR EACH tt-unidade
       BREAK BY tt-unidade.cod-rep
             BY tt-unidade.cod-unid-negoc.
      
      IF FIRST-OF(tt-unidade.cod-rep) THEN
         ASSIGN l-bonusmix = YES.

      IF tt-unidade.perc-ating < 100 THEN
         IF tt-unidade.perc-ating-ca < 100 THEN
            ASSIGN l-bonusmix = NO.

      IF LAST-OF(tt-unidade.cod-rep) THEN DO:
         IF l-bonusmix = YES THEN
            ASSIGN tt-unidade.vl-bonus-mix = tt-unidade.variavel-un.
          ELSE 
            ASSIGN tt-unidade.vl-rnm-bonus = tt-unidade.variavel-un.
      END.
   END.

END PROCEDURE. 

PROCEDURE pi-calcula-trimestre:
    
    CASE tt-param.periodo-mes:
        WHEN 3  THEN i-mes-ini = 1.
        WHEN 6  THEN i-mes-ini = 4.
        WHEN 9  THEN i-mes-ini = 7.
        WHEN 12 THEN i-mes-ini = 10.
    END CASE.

    FOR EACH tt-unidade 
        BREAK BY tt-unidade.cod-rep
              BY tt-unidade.cod-unid-neg:

        IF FIRST-OF(tt-unidade.cod-rep) THEN DO:
           ASSIGN l-bonus-mix-tri  = YES
                  de-tot-variavel  = 0
                  de-vlr-mes       = 0
                  i-qtd-un         = 0.
           FOR EACH b-aux-com  
              WHERE b-aux-com.cod-rep = tt-unidade.cod-rep
                 BREAK BY b-aux-com.cod-unid-neg:
               IF FIRST-OF (b-aux-com.cod-unid-neg) THEN
                  ASSIGN i-qtd-un = i-qtd-un + 1.
           END.
        END.

        ASSIGN de-rollout       = 0
               de-fat-tri       = 0
               de-meta-tri      = 0
               de-rnm           = 0
               de-rnm-bonus-tri = 0.

        /** rollout dos 2 meses anterioes */
        DO i-aux = i-mes-ini TO i-mes-ini + 1:
           FIND FIRST int-calc-comis 
                WHERE int-calc-comis.periodo-ano    = tt-param.periodo-ano
                  AND int-calc-comis.periodo-mes    = i-aux
                  AND int-calc-comis.codigo         = tt-unidade.cod-rep
                  AND int-calc-comis.idi-tipo       = tt-unidade.id-tipo
                  AND int-calc-comis.cod-unid-negoc = tt-unidade.cod-unid-negoc NO-ERROR.
           IF AVAIL int-calc-comis THEN DO:
               ASSIGN de-rollout       = de-rollout  + int-calc-comis.vl-rollout-tri
                      de-fat-tri       = de-fat-tri  + int-calc-comis.vl-fatura
                      de-meta-tri      = de-meta-tri + int-calc-comis.vl-meta
                      de-rnm           = de-rnm      + ( int-calc-comis.vl-variavel-un - int-calc-comis.vl-var-apagar)
                      de-rnm-bonus-tri = de-rnm-bonus-tri + int-calc-comis.vl-rnm-bonus.
           END.
        END.

        /* rollout apurado no mes */
        IF tt-unidade.perc-ating > int-param-comis.Perc-excede-rollout-tri THEN DO:
           ASSIGN tt-unidade.vl-rollout = de-rollout + ((tt-unidade.vl-fat-total - (tt-unidade.vl-meta * int-param-comis.Perc-excede-rollout-tri) / 100)).
        END.
        ELSE tt-unidade.vl-rollout = de-rollout.

         /* atingimento de meta no trimestre */
        ASSIGN tt-unidade.perc-ating-tri = (((de-fat-tri + tt-unidade.vl-fatura) + tt-unidade.vl-rollout) / (de-meta-tri + tt-unidade.vl-meta) * 100).
        IF tt-unidade.perc-ating-tri >= 100 THEN
           ASSIGN tt-unidade.log-meta-tri = YES.
        ELSE ASSIGN l-bonus-mix-tri = NO.

        /* RNM Variÿvel acumulado para o trimestre */ 
        ASSIGN tt-unidade.vl-rnm-variav  = de-rnm + (tt-unidade.variavel-un - tt-unidade.vl-var-apagar)
               tt-unidade.vl-rnm-tot     = tt-unidade.vl-rnm-variav .

        IF tt-param.periodo-mes = 03 OR tt-param.periodo-mes = 06 OR 
           tt-param.periodo-mes = 09 OR tt-param.periodo-mes = 12 THEN DO:
           IF tt-unidade.log-meta-tri = YES THEN
              ASSIGN tt-unidade.vl-bonus-sup = (int-param-comis.vl-bonus-tri[tt-unidade.id-tipo] / i-qtd-un).
          
           ASSIGN tt-unidade.vl-var-tot = tt-unidade.vl-var-apagar + tt-unidade.vl-rnm-tot  .
        END.
        ELSE 
          ASSIGN tt-unidade.vl-var-tot = tt-unidade.vl-var-apagar.

        ASSIGN de-tot-variavel = de-tot-variavel + tt-unidade.vl-var-tot.

        IF LAST-OF(tt-unidade.cod-rep) THEN DO:
           
           ASSIGN tt-unidade.vl-salario  =  tt-unidade.vl-fixo + de-tot-variavel.

           IF tt-param.periodo-mes = 03 OR tt-param.periodo-mes = 06 OR 
              tt-param.periodo-mes = 09 OR tt-param.periodo-mes = 12 THEN DO:
              
              ASSIGN tt-unidade.vl-rnm-bonus = tt-unidade.variavel-un + de-rnm-bonus-tri. 
               de-tot-variavel = 0.
              IF l-bonus-mix-tri = NO THEN DO:
                 FOR EACH b-aux-com  
                    WHERE b-aux-com.cod-rep = tt-unidade.cod-rep
                     BREAK BY b-aux-com.cod-unid-neg:
                    
                    ASSIGN b-aux-com.vl-var-tot = b-aux-com.vl-var-apagar
                            de-tot-variavel = de-tot-variavel + b-aux-com.vl-var-apagar + b-aux-com.vl-bonus-mix.  
                 END.
                 ASSIGN tt-unidade.vl-salario  =  tt-unidade.vl-fixo + de-tot-variavel.
              END.
              ELSE
                 ASSIGN tt-unidade.vl-salario  =  tt-unidade.vl-salario + tt-unidade.vl-rnm-bonus + tt-unidade.vl-bonus-sup.
           END.
           ELSE 
              ASSIGN tt-unidade.vl-salario = tt-unidade.vl-salario + tt-unidade.vl-bonus-mix.
        END.
    END.
END PROCEDURE.


PROCEDURE pi-grava-comissao:
     FOR EACH tt-unidade:
        CREATE int-calc-comis.
        ASSIGN int-calc-comis.periodo-mes       = tt-param.periodo-mes
               int-calc-comis.periodo-ano       = tt-param.periodo-ano
               int-calc-comis.codigo            = tt-unidade.cod-repres    
               int-calc-comis.cod-unid-negoc    = tt-unidade.cod-unid-negoc
               int-calc-comis.cod-segmento      = tt-unidade.cod-segmento  
               int-calc-comis.idi-tipo          = tt-unidade.id-tipo       
               int-calc-comis.it-codigo         = tt-unidade.it-codigo     
               int-calc-comis.vl-fixo           = tt-unidade.vl-fixo       
               int-calc-comis.vl-variavel       = tt-unidade.vl-variavel   
               int-calc-comis.perc-un           = tt-unidade.perc-un       
               int-calc-comis.vl-variavel-un    = tt-unidade.variavel-un   
               int-calc-comis.vl-meta           = tt-unidade.vl-meta       
               int-calc-comis.vl-faturado       = tt-unidade.vl-faturado   
               int-calc-comis.vl-sellout        = tt-unidade.vl-sellout    
               int-calc-comis.vl-fat-total      = tt-unidade.vl-fat-total  
               int-calc-comis.perc-ating-meta   = tt-unidade.perc-ating    
               int-calc-comis.vl-carteira       = tt-unidade.vl-carteira   
               int-calc-comis.perc-ating-meta-c = tt-unidade.perc-ating-ca 
               int-calc-comis.vl-var-apagar     = tt-unidade.vl-var-apagar 
               int-calc-comis.vl-bonus-mix      = tt-unidade.vl-bonus-mix .
        
    
        ASSIGN int-calc-comis.vl-rollout-tri    = tt-unidade.vl-rollout-tri
               int-calc-comis.perc-ating-tri    = tt-unidade.perc-ating-tri
               int-calc-comis.vl-rnm-variav     = tt-unidade.vl-rnm-variav 
               int-calc-comis.vl-rnm-bonus      = tt-unidade.vl-rnm-bonus  
               int-calc-comis.vl-rnm-tot        = tt-unidade.vl-rnm-tot    
               int-calc-comis.vl-bonus-sup      = tt-unidade.vl-bonus-sup  
               int-calc-comis.vl-var-tot        = tt-unidade.vl-var-tot    
               int-calc-comis.vl-salario        = tt-unidade.vl-salario.

        /*Grava data e usu rio do c lculo*/
        FIND FIRST int-execsuperv-calc EXCLUSIVE-LOCK
             WHERE int-execsuperv-calc.periodo-mes  = int-calc-comis.periodo-mes
               AND int-execsuperv-calc.periodo-ano  = int-calc-comis.periodo-ano
               AND int-execsuperv-calc.cod-sup-exec = int-calc-comis.codigo
               AND int-execsuperv-calc.idi-tipo     = int-calc-comis.idi-tipo NO-ERROR.

        IF AVAIL int-execsuperv-calc THEN DO:
            ASSIGN int-execsuperv-calc.dt-calculo      = TODAY
                   int-execsuperv-calc.usuario-calculo = c-seg-usuario.

            FIND CURRENT int-execsuperv-calc NO-LOCK NO-ERROR.
        END.

        IF NOT CAN-FIND (FIRST int-execsuperv-calc 
                         WHERE int-execsuperv-calc.periodo-mes = tt-param.periodo-mes
                           AND int-execsuperv-calc.periodo-ano = tt-param.periodo-ano
                           AND int-execsuperv-calc.dt-calculo  = ?) THEN DO:
        
            FIND FIRST int-param-comis EXCLUSIVE-LOCK
                 WHERE int-param-comis.periodo-ano = tt-param.periodo-ano
                   AND int-param-comis.periodo-mes = tt-param.periodo-mes NO-ERROR.
        
            IF AVAIL int-param-comis THEN
                ASSIGN int-param-comis.idi-status = 2. /*Calculada*/
        
            FIND CURRENT int-param-comis NO-LOCK NO-ERROR.
        END.
    END.
END PROCEDURE.


PROCEDURE pi-imprime-comis:
DEF VAR c-arq    AS CHAR.

    c-arq = 'c:\temp\calc' + STRING(tt-param.periodo-mes) + '.txt'.

    OUTPUT TO VALUE(c-arq).

    PUT "Matricula;Executivo;Salario Fixo;Salario Variavel;Unidades de Negocio;%  Unid. Negoc.;Variavel por UN(100%);R$ Faturamento;R$ SellOut;Fatur + SellOut;R$ Meta;% Atingimento Meta;"
        "R$ Carteira;Atingimento Meta  (Fat. + Carteira);Variavel a Receber (Mes);B“nus Mix Mes;Roll Out Trimestre;Atingimento Meta Trimestre (Fat. + Rollout);"
        "Atingiu Meta Trimestre Atual (Fat. + Rollout);RNM Variavel;RNM B“nus Mix;RNM Total;Bonus Supera‡Æo;Salario Variavel Total;Salario Total " SKIP.

    FOR EACH tt-unidade 
        BREAK BY tt-unidade.cod-rep
              BY tt-unidade.id-tipo
              BY tt-unidade.cod-unid-negoc.
       FIND FIRST repres
            WHERE repres.cod-rep = tt-unidade.cod-rep NO-LOCK NO-ERROR.

       IF FIRST-OF(tt-unidade.cod-rep) THEN DO:
          PUT tt-unidade.cod-repres        ';'.
          IF AVAIL repres THEN
             PUT repres.nome-abrev                ';'.
          ELSE DO:    
             FIND INT-supervisor 
                  WHERE int-supervisor.cod-supervisor = tt-unidade.cod-rep NO-LOCK NO-ERROR.
             IF AVAIL INT-supervisor THEN PUT int-supervisor.nome ';'.
             ELSE PUT ';'.
          END.

          PUT tt-unidade.vl-fixo           ';' 
              tt-unidade.vl-variavel       ';'. 

           ASSIGN l-prim = YES.
       END.

       IF l-prim = NO THEN
          PUT ';;;;'.

       PUT tt-unidade.cod-unid-negoc         ';' 
           tt-unidade.perc-un                ';' 
           tt-unidade.variavel-un            ';' 
           int(tt-unidade.vl-faturado)       ';' 
           int(tt-unidade.vl-sellout)        ';' 
           int(tt-unidade.vl-fat-total)      ';' 
           int(tt-unidade.vl-meta)           ';' 
           tt-unidade.perc-ating             ';' 
           int(tt-unidade.vl-carteira)       ';' 
           tt-unidade.perc-ating-ca          ';' 
           tt-unidade.vl-var-apagar          ';' 
           tt-unidade.vl-bonus-mix           ';' 
           tt-unidade.vl-rollout-tri         ';' 
           tt-unidade.perc-ating-tri         ';' 
           tt-unidade.log-meta-tri           ';' 
           tt-unidade.vl-rnm-variav          ';' 
           tt-unidade.vl-rnm-bonus           ';' 
           tt-unidade.vl-rnm-tot             ';' 
           tt-unidade.vl-bonus-sup           ';' 
           tt-unidade.vl-var-tot             ';' 
           tt-unidade.vl-salario             ';' SKIP.

       ASSIGN  l-prim = NO.

       IF LAST-OF(tt-unidade.cod-rep) THEN 
          PUT SKIP(1).
    END.
    OUTPUT CLOSE.
    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-exclui-comissao:

    /* efetuar valida‡äes para exclusao */
    FOR EACH int-execsuperv-calc EXCLUSIVE-LOCK
       WHERE int-execsuperv-calc.periodo-mes  = tt-param.periodo-mes
         AND int-execsuperv-calc.periodo-ano  = tt-param.periodo-ano
         AND int-execsuperv-calc.cod-sup-exec >= tt-param.cod-rep-ini
         AND int-execsuperv-calc.cod-sup-exec <= tt-param.cod-rep-fim
         AND int-execsuperv-calc.dt-calculo   <> ?:

        RUN pi-acompanhar IN h-acomp (INPUT "Excluindo C lculo Representante: " + STRING(int-execsuperv-calc.cod-sup-exec)).

        ASSIGN int-execsuperv-calc.dt-calculo      = ?
               int-execsuperv-calc.usuario-calculo = ?.

        FOR EACH int-calc-comis EXCLUSIVE-LOCK
             WHERE int-calc-comis.periodo-ano = int-execsuperv-calc.periodo-ano
               AND int-calc-comis.periodo-mes = int-execsuperv-calc.periodo-mes
               AND int-calc-comis.codigo      = int-execsuperv-calc.cod-sup-exec
               AND int-calc-comis.idi-tipo    = int-execsuperv-calc.idi-tipo:

            DELETE int-calc-comis.
        END.

        /*Exclui o C lculo do Supervisor relacionado*/
        IF int-execsuperv-calc.idi-tipo = 1 /*Executivo*/ THEN DO:

            FIND FIRST int-exec-superv NO-LOCK
                 WHERE int-exec-superv.cod-executivo  = int-execsuperv-calc.cod-sup-exec
                   AND int-exec-superv.dt-termino     = ? NO-ERROR.
        
            FOR EACH int-calc-comis EXCLUSIVE-LOCK
                  WHERE int-calc-comis.periodo-ano = int-execsuperv-calc.periodo-ano
                    AND int-calc-comis.periodo-mes = int-execsuperv-calc.periodo-mes
                    AND int-calc-comis.codigo      = int-exec-superv.cod-supervisor
                    AND int-calc-comis.idi-tipo    = 2:
                DELETE int-calc-comis.
            END.
        
            FIND FIRST b-int-execsuperv-calc EXCLUSIVE-LOCK
                 WHERE b-int-execsuperv-calc.periodo-mes  = int-execsuperv-calc.periodo-mes
                   AND b-int-execsuperv-calc.periodo-ano  = int-execsuperv-calc.periodo-ano
                   AND b-int-execsuperv-calc.cod-sup-exec = int-exec-superv.cod-supervisor
                   AND b-int-execsuperv-calc.idi-tipo     = 2 
                   AND b-int-execsuperv-calc.dt-calculo  <> ? NO-ERROR.

            IF AVAIL b-int-execsuperv-calc THEN
                ASSIGN b-int-execsuperv-calc.dt-calculo      = ?
                       b-int-execsuperv-calc.usuario-calculo = ?.
        END.
    END.

    IF NOT CAN-FIND (FIRST int-execsuperv-calc 
                     WHERE int-execsuperv-calc.periodo-mes   = tt-param.periodo-mes
                       AND int-execsuperv-calc.periodo-ano   = tt-param.periodo-ano
                       AND int-execsuperv-calc.dt-calculo <> ?) THEN DO:

        FIND FIRST int-param-comis EXCLUSIVE-LOCK
             WHERE int-param-comis.periodo-ano = tt-param.periodo-ano
               AND int-param-comis.periodo-mes = tt-param.periodo-mes NO-ERROR.

        IF AVAIL int-param-comis THEN
            ASSIGN int-param-comis.idi-status = 1. /*Iniciada*/

        FIND CURRENT int-param-comis NO-LOCK NO-ERROR.
    END.
    

    
END PROCEDURE.

PROCEDURE pi-excel:
    
    /*Cria Excel*/
    CREATE 'Excel.Application' chExcel.
    chExcel:Workbooks:ADD().
    chWBook  = chExcel:Workbooks(1).
    chWSheet = chWBook:Sheets:ITEM(1).
    
    /*Imprime Supervisores*/
    ASSIGN i-linha = 1.
    chWSheet:NAME = "Supervisores". 
    RUN pi-cabecalho.

    FOR EACH tt-unidade
       WHERE tt-unidade.id-tipo = 2
       BREAK BY tt-unidade.cod-rep
             BY tt-unidade.id-tipo
             BY tt-unidade.cod-unid-negoc:

        FIND FIRST repres NO-LOCK 
             WHERE repres.cod-rep = tt-unidade.cod-rep NO-ERROR.
      
        IF FIRST-OF(tt-unidade.cod-rep) THEN DO:

            chWSheet:Range("A" + string(i-linha)):VALUE = tt-unidade.cod-repres.

            IF AVAIL repres THEN
               chWSheet:Range("B" + string(i-linha)):VALUE = repres.nome-abrev.
            ELSE DO:    
               FIND FIRST int-supervisor NO-LOCK 
                    WHERE int-supervisor.cod-supervisor = tt-unidade.cod-rep NO-ERROR.
               IF AVAIL INT-supervisor THEN 
                   chWSheet:Range("B" + string(i-linha)):VALUE = int-supervisor.nome.
               ELSE
                   chWSheet:Range("B" + string(i-linha)):VALUE = "".
            END.
            chWSheet:Range("C" + string(i-linha)):VALUE = tt-unidade.vl-fixo.
            chWSheet:Range("D" + string(i-linha)):VALUE = tt-unidade.vl-variavel.

            RUN pi-zera-totais.
        END.

        RUN pi-imprime.

        /*Imprime totais*/
        IF LAST-OF(tt-unidade.cod-rep) THEN DO:
            RUN pi-imprime-totais.
        END.
    END.

    RUN pi-formata.

    chWSheet:Range("A2:AA" + STRING(i-linha)):FONT:NAME = "Calibri".
    chWSheet:Range("A2:AA" + STRING(i-linha)):FONT:SIZE = 8.
    chWSheet:Rows("2:"+ STRING(i-linha)):RowHeight = 11.25. 
    
    /*Imprime Executivos*/
    ASSIGN i-linha = 1.
    chWSheet = chWBook:Sheets:ADD(). 
    chWSheet:NAME = "Executivos".
    RUN pi-cabecalho.

    FOR EACH tt-unidade
       WHERE tt-unidade.id-tipo = 1
       BREAK BY tt-unidade.cod-rep
             BY tt-unidade.id-tipo
             BY tt-unidade.cod-unid-negoc:

        FIND FIRST repres NO-LOCK 
             WHERE repres.cod-rep = tt-unidade.cod-rep NO-ERROR.
      
        IF FIRST-OF(tt-unidade.cod-rep) THEN DO:

            chWSheet:Range("A" + string(i-linha)):VALUE = tt-unidade.cod-repres.

            IF AVAIL repres THEN
               chWSheet:Range("B" + string(i-linha)):VALUE = repres.nome-abrev.
            ELSE DO:    
               FIND FIRST int-supervisor NO-LOCK 
                    WHERE int-supervisor.cod-supervisor = tt-unidade.cod-rep NO-ERROR.
               IF AVAIL INT-supervisor THEN 
                   chWSheet:Range("B" + string(i-linha)):VALUE = int-supervisor.nome.
               ELSE
                   chWSheet:Range("B" + string(i-linha)):VALUE = "".
            END.
            chWSheet:Range("C" + string(i-linha)):VALUE = tt-unidade.vl-fixo.
            chWSheet:Range("D" + string(i-linha)):VALUE = tt-unidade.vl-variavel.

            RUN pi-zera-totais.
        END.

        RUN pi-imprime.

        /*Imprime totais*/
        IF LAST-OF(tt-unidade.cod-rep) THEN DO:
            RUN pi-imprime-totais.
        END.
    END.

    RUN pi-formata.

    chWSheet:Range("A2:AA" + STRING(i-linha)):FONT:NAME = "Calibri".
    chWSheet:Range("A2:AA" + STRING(i-linha)):FONT:SIZE = 8.
    chWSheet:Rows("2:"+ STRING(i-linha)):RowHeight = 11.25. 
    
    chExcel:VISIBLE = TRUE.
    
    IF VALID-HANDLE(chExcel) THEN
        RELEASE OBJECT chExcel.
    IF VALID-HANDLE(chWBook) THEN
        RELEASE OBJECT chWBook.
    IF VALID-HANDLE(chWSheet) THEN
        RELEASE OBJECT chWSheet.
END PROCEDURE.

PROCEDURE pi-imprime:

    chWSheet:Range("E"  + string(i-linha)):VALUE = tt-unidade.cod-unid-negoc.
    chWSheet:Range("F"  + string(i-linha)):VALUE = tt-unidade.perc-un.
    chWSheet:Range("G"  + string(i-linha)):VALUE = tt-unidade.variavel-un.
    chWSheet:Range("H"  + string(i-linha)):VALUE = DEC(tt-unidade.vl-faturado).
    chWSheet:Range("I"  + string(i-linha)):VALUE = DEC(tt-unidade.vl-sellout).
    chWSheet:Range("J"  + string(i-linha)):VALUE = DEC(tt-unidade.vl-fat-total).
    chWSheet:Range("K"  + string(i-linha)):VALUE = DEC(tt-unidade.vl-meta).
    chWSheet:Range("L"  + string(i-linha)):VALUE = tt-unidade.perc-ating.
    chWSheet:Range("M"  + string(i-linha)):VALUE = DEC(tt-unidade.vl-carteira).
    chWSheet:Range("N"  + string(i-linha)):VALUE = tt-unidade.perc-ating-ca.
    chWSheet:Range("O"  + string(i-linha)):VALUE = tt-unidade.vl-var-apagar.
    /*chWSheet:Range("P"  + string(i-linha)):VALUE = tt-unidade.vl-bonus-mix.*/
    chWSheet:Range("Q"  + string(i-linha)):VALUE = tt-unidade.vl-rollout-tri.
    chWSheet:Range("R"  + string(i-linha)):VALUE = tt-unidade.perc-ating-tri.
    chWSheet:Range("S"  + string(i-linha)):VALUE = IF tt-unidade.log-meta-tri THEN "Sim" ELSE "NÆo".
    chWSheet:Range("T"  + string(i-linha)):VALUE = tt-unidade.vl-rnm-variav.
    /*chWSheet:Range("U"  + string(i-linha)):VALUE = tt-unidade.vl-rnm-bonus.*/
    chWSheet:Range("V"  + string(i-linha)):VALUE = tt-unidade.vl-rnm-tot.
    chWSheet:Range("W"  + string(i-linha)):VALUE = tt-unidade.vl-bonus-sup.
    chWSheet:Range("X"  + string(i-linha)):VALUE = tt-unidade.vl-var-tot.
    /*chWSheet:Range("Y"  + string(i-linha)):VALUE = tt-unidade.vl-salario.*/

    /*Formata a celula de acordo com o valor*/
    IF tt-unidade.vl-faturado = 0 THEN
        chWSheet:Range("H" + STRING(i-linha)):Style = "Comma".
    ELSE 
        chWSheet:Range("H" + STRING(i-linha)):numberformat = "###.###.###.##0". 

    IF tt-unidade.vl-sellout = 0 THEN
        chWSheet:Range("I" + STRING(i-linha)):Style = "Comma".
    ELSE 
        chWSheet:Range("I" + STRING(i-linha)):numberformat = "###.###.###.##0". 

    IF tt-unidade.vl-meta = 0 THEN
        chWSheet:Range("K" + STRING(i-linha)):Style = "Comma".
    ELSE 
        chWSheet:Range("K" + STRING(i-linha)):numberformat = "###.###.###.##0". 

    IF tt-unidade.vl-carteira = 0 THEN
        chWSheet:Range("M" + STRING(i-linha)):Style = "Comma".
    ELSE 
        chWSheet:Range("M" + STRING(i-linha)):numberformat = "###.###.###.##0". 

    IF tt-unidade.vl-rollout-tri = 0 THEN
        chWSheet:Range("Q" + STRING(i-linha)):Style = "Comma".
    ELSE 
        chWSheet:Range("Q" + STRING(i-linha)):numberformat = "###.###.###.##0". 
    

    ASSIGN v-tot-perc-un        = v-tot-perc-un        + tt-unidade.perc-un       
           v-tot-variavel-un    = v-tot-variavel-un    + tt-unidade.variavel-un   
           v-tot-vl-faturado    = v-tot-vl-faturado    + tt-unidade.vl-faturado   
           v-tot-vl-sellout     = v-tot-vl-sellout     + tt-unidade.vl-sellout    
           v-tot-vl-fat-total   = v-tot-vl-fat-total   + tt-unidade.vl-fat-total  
           v-tot-vl-meta        = v-tot-vl-meta        + tt-unidade.vl-meta       
           v-tot-perc-ating     = v-tot-perc-ating     + tt-unidade.perc-ating    
           i-num-perc-ating     = i-num-perc-ating     + 1
           v-tot-vl-carteira    = v-tot-vl-carteira    + tt-unidade.vl-carteira   
           v-tot-perc-ating-ca  = v-tot-perc-ating-ca  + tt-unidade.perc-ating-ca 
           i-num-perc-ating-ca  = i-num-perc-ating-ca  + 1
           v-tot-vl-var-apagar  = v-tot-vl-var-apagar  + tt-unidade.vl-var-apagar 
           v-tot-vl-bonus-mix   = v-tot-vl-bonus-mix   + tt-unidade.vl-bonus-mix  
           v-tot-vl-rollout-tri = v-tot-vl-rollout-tri + tt-unidade.vl-rollout-tri
           v-tot-perc-ating-tri = v-tot-perc-ating-tri + tt-unidade.perc-ating-tri
           i-num-perc-ating-tri = i-num-perc-ating-tri + 1
           v-tot-log-meta-tri   = IF NOT tt-unidade.log-meta-tri THEN tt-unidade.log-meta-tri ELSE v-tot-log-meta-tri
           v-tot-vl-rnm-variav  = v-tot-vl-rnm-variav  + tt-unidade.vl-rnm-variav 
           v-tot-vl-rnm-bonus   = v-tot-vl-rnm-bonus   + tt-unidade.vl-rnm-bonus  
           v-tot-vl-rnm-tot     = v-tot-vl-rnm-tot     + tt-unidade.vl-rnm-tot    
           v-tot-vl-bonus-sup   = v-tot-vl-bonus-sup   + tt-unidade.vl-bonus-sup  
           v-tot-vl-var-tot     = v-tot-vl-var-tot     + tt-unidade.vl-var-tot    
           v-tot-vl-salario     = v-tot-vl-salario     + tt-unidade.vl-salario.   

    ASSIGN i-linha = i-linha + 1.

END PROCEDURE.

PROCEDURE pi-cabecalho:

    chWSheet:Range("A"  + string(i-linha)):VALUE = "Matricula".
    chWSheet:Range("B"  + string(i-linha)):VALUE = "Executivo".
    chWSheet:Range("C"  + string(i-linha)):VALUE = "Salario Fixo".
    chWSheet:Range("D"  + string(i-linha)):VALUE = "Salario Variavel".
    chWSheet:Range("E"  + string(i-linha)):VALUE = "Unidades de Negocio".
    chWSheet:Range("F"  + string(i-linha)):VALUE = "%  Unid. Negoc.".
    chWSheet:Range("G"  + string(i-linha)):VALUE = "Variavel por UN(100%)".
    chWSheet:Range("H"  + string(i-linha)):VALUE = "R$ Faturamento".
    chWSheet:Range("I"  + string(i-linha)):VALUE = "R$ SellOut".
    chWSheet:Range("J"  + string(i-linha)):VALUE = "Fatur + SellOut".
    chWSheet:Range("K"  + string(i-linha)):VALUE = "R$ Meta".
    chWSheet:Range("L"  + string(i-linha)):VALUE = "% Atingimento Meta".
    chWSheet:Range("M"  + string(i-linha)):VALUE = "R$ Carteira".
    chWSheet:Range("N"  + string(i-linha)):VALUE = "Atingimento Meta  (Fat. + Carteira)".
    chWSheet:Range("O"  + string(i-linha)):VALUE = "Variavel a Receber (Mes)".
    chWSheet:Range("P"  + string(i-linha)):VALUE = "B“nus Mix Mes".
    chWSheet:Range("Q"  + string(i-linha)):VALUE = "Roll Out Trimestre".
    chWSheet:Range("R"  + string(i-linha)):VALUE = "Atingimento Meta Trimestre (Fat. + Rollout)".
    chWSheet:Range("S"  + string(i-linha)):VALUE = "Atingiu Meta Trimestre Atual (Fat. + Rollout)".
    chWSheet:Range("T"  + string(i-linha)):VALUE = "RNM Variavel".
    chWSheet:Range("U"  + string(i-linha)):VALUE = "RNM B“nus Mix".
    chWSheet:Range("V"  + string(i-linha)):VALUE = "RNM Total".
    chWSheet:Range("W"  + string(i-linha)):VALUE = "Bonus Supera‡Æo".
    chWSheet:Range("X"  + string(i-linha)):VALUE = "Salario Variavel Total".
    chWSheet:Range("Y"  + string(i-linha)):VALUE = "Salario Total".

    chWSheet:Rows("1:1"):RowHeight = 70. 
    chWSheet:Range("A1:AA1"):FONT:NAME = "Calibri".
    chWSheet:Range("A1:AA1"):FONT:SIZE = 8.
    chWSheet:Range("A1:AA1"):FONT:bold = TRUE.
    chWSheet:Range("A1:AA1"):HorizontalAlignment = 3.
    chWSheet:Range("A1:AA1"):VerticalAlignment = 2.
    chWSheet:Range("A1:AA1"):WrapText = TRUE.
    chWSheet:Range("A1:M1"):interior:colorindex = 15.
    chWSheet:Range("N1:P1"):interior:colorindex = 43.
    chWSheet:Range("Q1:V1"):interior:colorindex = 42.
    chWSheet:Range("W1:W1"):interior:colorindex = 40.
    chWSheet:Range("X1:Y1"):interior:colorindex = 1.
    chWSheet:Range("X1:Y1"):FONT:colorindex = 2.

    ASSIGN i-linha = i-linha + 1.
    
END PROCEDURE.

PROCEDURE pi-busca-valores-senior:   
    DEFINE INPUT PARAM p-cod-repres LIKE tt-comissao.cod-repres.
    DEFINE INPUT PARAM p-id-tipo AS INT.
    DEFINE INPUT PARAM p-mes-periodo AS INT.
    DEFINE INPUT PARAM p-ano-periodo AS INT.
    DEFINE OUTPUT PARAM p-salario-base AS DEC.
    DEFINE OUTPUT PARAM p-vl-variacel AS DEC.

    EMPTY TEMP-TABLE tt-matricula.
    CREATE tt-matricula.
    ASSIGN tt-matricula.idi-tipo = p-id-tipo
           tt-matricula.codigo   = p-cod-repres
           tt-matricula.mes-periodo = p-mes-periodo
           tt-matricula.ano-periodo = p-ano-periodo.
    
    
    RAW-TRANSFER tt-matricula TO raw-param.
    RUN esp/esb/out/msg0285.p (INPUT  raw-param, /* Tupla do registro */
                               OUTPUT TABLE msg0285r,
                               OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
    
    FOR FIRST msg0285r:
        ASSIGN p-salario-base = msg0285r.SalarioBase
               p-vl-variacel  = msg0285r.ValorTetoVariavel.
    END.
END PROCEDURE.

PROCEDURE pi-zera-totais:

    ASSIGN v-tot-perc-un        = 0
           v-tot-variavel-un    = 0
           v-tot-vl-faturado    = 0
           v-tot-vl-sellout     = 0
           v-tot-vl-fat-total   = 0
           v-tot-vl-meta        = 0
           v-tot-perc-ating     = 0
           i-num-perc-ating     = 0
           v-tot-vl-carteira    = 0
           v-tot-perc-ating-ca  = 0
           i-num-perc-ating-ca  = 0
           v-tot-vl-var-apagar  = 0
           v-tot-vl-bonus-mix   = 0
           v-tot-vl-rollout-tri = 0
           v-tot-perc-ating-tri = 0
           i-num-perc-ating-tri = 0
           v-tot-log-meta-tri   = YES
           v-tot-vl-rnm-variav  = 0
           v-tot-vl-rnm-bonus   = 0
           v-tot-vl-rnm-tot     = 0
           v-tot-vl-bonus-sup   = 0
           v-tot-vl-var-tot     = 0
           v-tot-vl-salario     = 0.
END PROCEDURE.

PROCEDURE pi-imprime-totais:
    chWSheet:Range("E"  + string(i-linha)):VALUE = "TOTAIS".
    chWSheet:Range("F"  + string(i-linha)):VALUE = v-tot-perc-un.
    chWSheet:Range("G"  + string(i-linha)):VALUE = v-tot-variavel-un.
    chWSheet:Range("H"  + string(i-linha)):VALUE = v-tot-vl-faturado.
    chWSheet:Range("I"  + string(i-linha)):VALUE = v-tot-vl-sellout.
    chWSheet:Range("J"  + string(i-linha)):VALUE = v-tot-vl-fat-total.
    chWSheet:Range("K"  + string(i-linha)):VALUE = v-tot-vl-meta.
    chWSheet:Range("L"  + string(i-linha)):VALUE = v-tot-perc-ating / i-num-perc-ating.
    chWSheet:Range("M"  + string(i-linha)):VALUE = v-tot-vl-carteira.
    chWSheet:Range("N"  + string(i-linha)):VALUE = v-tot-perc-ating-ca / i-num-perc-ating-ca.
    chWSheet:Range("O"  + string(i-linha)):VALUE = v-tot-vl-var-apagar.
    chWSheet:Range("P"  + string(i-linha)):VALUE = v-tot-vl-bonus-mix.
    chWSheet:Range("Q"  + string(i-linha)):VALUE = v-tot-vl-rollout-tri.
    chWSheet:Range("R"  + string(i-linha)):VALUE = v-tot-perc-ating-tri / i-num-perc-ating-tri.
    /*chWSheet:Range("S"  + string(i-linha)):VALUE = tt-unidade.log-meta-tri.*/
    chWSheet:Range("T"  + string(i-linha)):VALUE = v-tot-vl-rnm-variav.
    chWSheet:Range("U"  + string(i-linha)):VALUE = v-tot-vl-rnm-bonus.
    chWSheet:Range("V"  + string(i-linha)):VALUE = v-tot-vl-rnm-tot.
    chWSheet:Range("W"  + string(i-linha)):VALUE = v-tot-vl-bonus-sup.
    chWSheet:Range("X"  + string(i-linha)):VALUE = v-tot-vl-var-tot.
    chWSheet:Range("Y"  + string(i-linha)):VALUE = v-tot-vl-salario.
    chWSheet:Range("E" + STRING(i-linha) + ":Y" + STRING(i-linha)):interior:colorindex = 15.
    chWSheet:Range("E" + STRING(i-linha) + ":Y" + STRING(i-linha)):FONT:bold = TRUE.

    /*Formata a celula de acordo com o valor*/
    IF v-tot-vl-faturado = 0 THEN
        chWSheet:Range("H" + STRING(i-linha)):Style = "Comma".
    ELSE 
        chWSheet:Range("H" + STRING(i-linha)):numberformat = "###.###.###.##0". 

    IF v-tot-vl-sellout = 0 THEN
        chWSheet:Range("I" + STRING(i-linha)):Style = "Comma".
    ELSE 
        chWSheet:Range("I" + STRING(i-linha)):numberformat = "###.###.###.##0". 

    IF v-tot-vl-meta = 0 THEN
        chWSheet:Range("K" + STRING(i-linha)):Style = "Comma".
    ELSE 
        chWSheet:Range("K" + STRING(i-linha)):numberformat = "###.###.###.##0". 

    IF v-tot-vl-carteira = 0 THEN
        chWSheet:Range("M" + STRING(i-linha)):Style = "Comma".
    ELSE 
        chWSheet:Range("M" + STRING(i-linha)):numberformat = "###.###.###.##0". 

    IF v-tot-vl-rollout-tri = 0 THEN
        chWSheet:Range("Q" + STRING(i-linha)):Style = "Comma".
    ELSE 
        chWSheet:Range("Q" + STRING(i-linha)):numberformat = "###.###.###.##0". 

    ASSIGN i-linha = i-linha + 2.
END PROCEDURE.

PROCEDURE pi-formata:
    chWSheet:Range("A2:AA" + STRING(i-linha)):FONT:NAME = "Calibri".
    chWSheet:Range("A2:AA" + STRING(i-linha)):FONT:SIZE = 8.
    chWSheet:Rows("2:" + STRING(i-linha)):RowHeight = 11.25. 
    chWSheet:Range("C2:C" + STRING(i-linha)):numberformat = "###.###.###.##0,00". 
    chWSheet:Range("D2:D" + STRING(i-linha)):numberformat = "###.###.###.##0,00". 
    chWSheet:Range("F2:F" + STRING(i-linha)):numberformat = "###.###.###.##0,00". 
    chWSheet:Range("G2:G" + STRING(i-linha)):numberformat = "###.###.###.##0,00". 
  /*chWSheet:Range("H2:H" + STRING(i-linha)):numberformat = "###.###.###.##0". 
    chWSheet:Range("H2:H" + STRING(i-linha)):Style = "Comma".
    chWSheet:Range("I2:I" + STRING(i-linha)):numberformat = "###.###.###.##0". 
    chWSheet:Range("I2:I" + STRING(i-linha)):Style = "Comma".*/
    chWSheet:Range("J2:J" + STRING(i-linha)):numberformat = "###.###.###.##0,00". 
    chWSheet:Range("J2:J" + STRING(i-linha)):Style = "Comma".
  /*chWSheet:Range("K2:K" + STRING(i-linha)):numberformat = "###.###.###.##0". 
    chWSheet:Range("K2:K" + STRING(i-linha)):Style = "Comma".*/
    chWSheet:Range("L2:L" + STRING(i-linha)):numberformat = "###.###.###.##0,00". 
  /*chWSheet:Range("M2:M" + STRING(i-linha)):numberformat = "###.###.###.##0". 
    chWSheet:Range("M2:M" + STRING(i-linha)):Style = "Comma".*/
    chWSheet:Range("N2:N" + STRING(i-linha)):numberformat = "###.###.###.##0,00". 
    chWSheet:Range("O2:O" + STRING(i-linha)):numberformat = "###.###.###.##0,00". 
    chWSheet:Range("O2:O" + STRING(i-linha)):Style = "Comma".
    chWSheet:Range("P2:P" + STRING(i-linha)):numberformat = "###.###.###.##0,00". 
    chWSheet:Range("P2:P" + STRING(i-linha)):Style = "Comma".
  /*chWSheet:Range("Q2:Q" + STRING(i-linha)):numberformat = "###.###.###.##0". 
    chWSheet:Range("Q2:Q" + STRING(i-linha)):Style = "Comma".*/
    chWSheet:Range("R2:R" + STRING(i-linha)):numberformat = "###.###.###.##0,00". 
    chWSheet:Range("S2:S" + STRING(i-linha)):HorizontalAlignment = 3. 
    chWSheet:Range("T2:T" + STRING(i-linha)):numberformat = "###.###.###.##0,00". 
    chWSheet:Range("T2:T" + STRING(i-linha)):Style = "Comma".
    chWSheet:Range("U2:U" + STRING(i-linha)):numberformat = "###.###.###.##0,00". 
    chWSheet:Range("U2:U" + STRING(i-linha)):Style = "Comma".
    chWSheet:Range("V2:V" + STRING(i-linha)):numberformat = "###.###.###.##0,00". 
    chWSheet:Range("V2:V" + STRING(i-linha)):Style = "Comma".
    chWSheet:Range("W2:W" + STRING(i-linha)):numberformat = "###.###.###.##0,00". 
    chWSheet:Range("W2:W" + STRING(i-linha)):Style = "Comma".
    chWSheet:Range("X2:X" + STRING(i-linha)):numberformat = "###.###.###.##0,00". 
    chWSheet:Range("X2:X" + STRING(i-linha)):Style = "Comma".
    chWSheet:Range("Y2:Y" + STRING(i-linha)):numberformat = "###.###.###.##0,00". 
    chWSheet:Range("Y2:Y" + STRING(i-linha)):Style = "Comma".
END PROCEDURE.
