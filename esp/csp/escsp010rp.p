/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*:T*******************************************************************************
**
**  Programa.: esp/csp/escsp010rp.p
**  Objetivo.: Gerar comparativo real/padr∆o entre o material, m∆o-de-obre e GGF.
**  Criaá∆o..: 07/06/2010
**  Vers∆o...: 000 - Criar o programa baseado no produto padr∆o 'Comparativo
**             Real / Padr∆o' (CS0501) - Fabiano Sakae Ribeiro (SQL Works).
**
*******************************************************************************/
{include/i-prgvrs.i ESCSP010RP 2.04.00.000}


/* ***************************  Definitions  ************************** */
DEFINE BUFFER bff-estrutura FOR estrutura.
DEFINE BUFFER bf-estrutura  FOR estrutura.

/* Local Temp-Table Definitions ---                                     */
DEFINE TEMP-TABLE tt-mat NO-UNDO
    FIELD it-codigo         LIKE item.it-codigo
    FIELD cod-refer         LIKE movto-mat.referencia
    FIELD quant-pad         LIKE movto-mat.quantidade
    FIELD quant-real        LIKE movto-mat.quantidade
    FIELD dt-movto          LIKE operacao.data-ult-ent
    FIELD vl-mobext         LIKE operacao.preco-medio
    FIELD val-dd            AS DECIMAL FORMAT "->>>,>>>,>>9.99"
    FIELD qt-reservas-orig  LIKE reservas.quant-orig
    FIELD qt-reservas-atend LIKE reservas.quant-atend
    FIELD qt-reservas-saldo LIKE reservas.quant-orig.

DEFINE TEMP-TABLE tt-ggf NO-UNDO
    FIELD cc-codigo  LIKE centro-custo.cc-codigo
    FIELD gm-codigo  LIKE grup-maquina.gm-codigo
    FIELD tempo-pad  AS DECIMAL FORMAT "->>>>>,>>9.9999"
    FIELD tempo-real AS DECIMAL FORMAT "->>>>>,>>9.9999"
    FIELD tempo-pre  AS DECIMAL FORMAT "->>>>>,>>9.9999".

DEFINE TEMP-TABLE tt-mob NO-UNDO
    FIELD it-codigo  LIKE item.it-codigo
    FIELD op-codigo  LIKE operacao.op-codigo
    FIELD cd-mob-dir LIKE tab-mob-dir.cd-mob-dir
    FIELD tempad     AS DECIMAL FORMAT "->>>,>>9.9999"
    FIELD temreal    AS DECIMAL FORMAT "->>>,>>9.9999".

DEFINE TEMP-TABLE tt-moedas NO-UNDO
    FIELD cod-moeda            AS INTEGER
    FIELD qtd-decimais         AS INTEGER
    FIELD ind-tratamento-infor AS INTEGER
    FIELD ind-tratamento-calc  AS INTEGER.

DEFINE TEMP-TABLE tt-proces-item NO-UNDO LIKE proces-item.

/* Include Definitions ---                                              */
{esp/csp/escsp010.i} /* Definiá∆o da temp-table tt-param, tt-digita e tt-raw-digita */
{cdp/cdcfgman.i}
{include/i-rpvar.i}

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-acomp               AS HANDLE                                                                        NO-UNDO.

DEFINE VARIABLE c-estab               LIKE ord-prod.cod-estabel                                                        NO-UNDO.
DEFINE VARIABLE d-data-ini            AS DATE                       FORMAT "99/99/9999"          INITIAL 01/01/1900  NO-UNDO.
DEFINE VARIABLE d-data-fim            AS DATE                       FORMAT "99/99/9999"          INITIAL TODAY       NO-UNDO.
DEFINE VARIABLE d-dtmov-ini           AS DATE                       FORMAT "99/99/9999"          INITIAL 01/01/1900  NO-UNDO.
DEFINE VARIABLE d-dtmov-fim           AS DATE                       FORMAT "99/99/9999"          INITIAL TODAY       NO-UNDO.
DEFINE VARIABLE i-estado              AS INTEGER                                                   INITIAL 1           NO-UNDO.
DEFINE VARIABLE v-estado              AS CHARACTER                  FORMAT "x(12)"                                   NO-UNDO.
DEFINE VARIABLE de-variacao-min       AS DECIMAL                    FORMAT "->>9.99"             INITIAL "-999.99" NO-UNDO.
DEFINE VARIABLE de-variacao-max       AS DECIMAL                    FORMAT "->>9.99"             INITIAL "999.99"  NO-UNDO.
DEFINE VARIABLE l-var-zero            AS LOGICAL                    FORMAT "Sim/Nao"             INITIAL NO          NO-UNDO.
DEFINE VARIABLE da-corte-es           LIKE estrutura.data-inicio                                   INITIAL TODAY       NO-UNDO.
DEFINE VARIABLE da-corte-op           LIKE operacao.data-inicio                             INITIAL TODAY       NO-UNDO.
DEFINE VARIABLE l-parametro           AS LOGICAL                                                                       NO-UNDO.
DEFINE VARIABLE c-usuario             AS CHARACTER                                                                     NO-UNDO.
DEFINE VARIABLE i-moeda               AS INTEGER                    FORMAT "9"                   INITIAL 0           NO-UNDO.
DEFINE VARIABLE i-tipo-preco          AS INTEGER                                                   INITIAL 1           NO-UNDO.
DEFINE VARIABLE i-tipo-custo          AS INTEGER                                                   INITIAL 1           NO-UNDO.
DEFINE VARIABLE i-tempo               AS INTEGER                                                                       NO-UNDO.
DEFINE VARIABLE de-tipo-estado        AS CHARACTER                  FORMAT "x(16)"                                   NO-UNDO.
DEFINE VARIABLE l-imprime             AS LOGICAL                                                                       NO-UNDO.
DEFINE VARIABLE de-totpad             AS DECIMAL                    FORMAT "->>>,>>>,>>9.99"                         NO-UNDO.
DEFINE VARIABLE de-totreal            AS DECIMAL                    FORMAT "->>>,>>>,>>9.99"                         NO-UNDO.
DEFINE VARIABLE de-tempad             AS DECIMAL                    FORMAT "->>>>>,>>9.9999"                         NO-UNDO.
DEFINE VARIABLE de-temreal            AS DECIMAL                    FORMAT "->>>>>,>>9.9999"                         NO-UNDO.
DEFINE VARIABLE l-fnc-cc-custo-estab  AS LOGICAL                                                   INITIAL NO          NO-UNDO.
DEFINE VARIABLE c-lt-oper-ext         AS CHARACTER                  FORMAT "x(20)"                                   NO-UNDO.
DEFINE VARIABLE c-destino             AS CHARACTER                  FORMAT "x(35)"                                   NO-UNDO.
DEFINE VARIABLE c-arquivo             AS CHARACTER                  FORMAT "x(35)"                                   NO-UNDO.
DEFINE VARIABLE c-ult-per-fech        AS CHARACTER                                                                     NO-UNDO.
DEFINE VARIABLE da-iniper             AS DATE                       FORMAT "99/99/9999"                              NO-UNDO.
DEFINE VARIABLE da-fimper             AS DATE                       FORMAT "99/99/9999"                              NO-UNDO.
DEFINE VARIABLE i-per-corrente        AS INTEGER                    FORMAT "99"                                      NO-UNDO.
DEFINE VARIABLE i-ano-corrente        AS INTEGER                    FORMAT "9999"                                    NO-UNDO.
DEFINE VARIABLE da-iniper-fech        AS DATE                       FORMAT "99/99/9999"                              NO-UNDO.
DEFINE VARIABLE da-fimper-fech        AS DATE                       FORMAT "99/99/9999"                              NO-UNDO.
DEFINE VARIABLE c-per                 LIKE ext-per-custo.periodo                                                       NO-UNDO.
DEFINE VARIABLE l-rot-item            AS LOGICAL                                                                       NO-UNDO.
DEFINE VARIABLE l-primeira            AS LOGICAL                                                   INITIAL YES         NO-UNDO.
DEFINE VARIABLE l-page                AS LOGICAL                                                   INITIAL YES         NO-UNDO.
DEFINE VARIABLE c-dattran             AS CHARACTER                  FORMAT "x(10)"                                   NO-UNDO.
DEFINE VARIABLE l-flag                AS LOGICAL                                                                       NO-UNDO.
DEFINE VARIABLE de-qtidade-produzida  LIKE movto-mat.quantidade     FORMAT "->>>>,>>9.9999"                          NO-UNDO.
DEFINE VARIABLE c-op-item             LIKE item.it-codigo                                                              NO-UNDO.
DEFINE VARIABLE i-fat                 LIKE ord-prod.qt-reportada                                                       NO-UNDO.
DEFINE VARIABLE i-nivel               AS INTEGER                                                                       NO-UNDO.
DEFINE VARIABLE c-item                LIKE item.it-codigo                                                              NO-UNDO.
DEFINE VARIABLE l-rot-fan             AS LOGICAL                                                   INITIAL NO          NO-UNDO.
DEFINE VARIABLE c-cd-mob-dir          LIKE tab-mob-dir.cd-mob-dir                                                      NO-UNDO.
DEFINE VARIABLE de-valor-mob          LIKE item.preco-base                                                             NO-UNDO.
DEFINE VARIABLE i-var                 AS INTEGER                                                                       NO-UNDO.
DEFINE VARIABLE de-valpad             AS DECIMAL                    FORMAT "->>>,>>>,>>9.99"                         NO-UNDO.
DEFINE VARIABLE de-variacao           AS DECIMAL                    FORMAT "->>>>>,>>9.99"                           NO-UNDO.
DEFINE VARIABLE de-perc               AS DECIMAL                    FORMAT "->>9.99"                                 NO-UNDO.
DEFINE VARIABLE l-impmob              AS LOGICAL                                                                       NO-UNDO.
DEFINE VARIABLE de-valreal            AS DECIMAL                    FORMAT "->>>,>>>,>>9.99"                         NO-UNDO.
DEFINE VARIABLE de-valpre             AS DECIMAL                    FORMAT "->>>,>>>,>>9.99"                         NO-UNDO.
DEFINE VARIABLE de-valcc              AS DECIMAL                    FORMAT "->>>,>>>,>>9.99"                         NO-UNDO.
DEFINE VARIABLE de-valaux             AS DECIMAL                    FORMAT "->>>,>>>,>>9.99"                         NO-UNDO.
DEFINE VARIABLE de-qtidade            LIKE movto-mat.quantidade                                                        NO-UNDO.
DEFINE VARIABLE c-descricao           AS CHARACTER                  FORMAT "x(36)"                                   NO-UNDO.
DEFINE VARIABLE c-movmat              AS CHARACTER                  FORMAT "x(132)"                                  NO-UNDO.
DEFINE VARIABLE c-movmdo              AS CHARACTER                  FORMAT "x(132)"                                  NO-UNDO.
DEFINE VARIABLE c-movtmdo             AS CHARACTER                  FORMAT "x(132)"                                  NO-UNDO.
DEFINE VARIABLE c-movggf              AS CHARACTER                  FORMAT "x(132)"                                  NO-UNDO.
DEFINE VARIABLE i-documento           AS INTEGER                    FORMAT ">>>,>>9"             INITIAL 0           NO-UNDO.
DEFINE VARIABLE de-valor-mat-m-conver AS DECIMAL                    FORMAT "->>>,>>>,>>>,>>9.99"                     NO-UNDO.
DEFINE VARIABLE da-data               AS DATE                       FORMAT "99/99/9999"                              NO-UNDO.
DEFINE VARIABLE c-desc                LIKE centro-custo.descricao                                                      NO-UNDO.
DEFINE VARIABLE c-hm                  AS CHARACTER                  FORMAT "x(7)"                                    NO-UNDO.
DEFINE VARIABLE l-movmob              AS LOGICAL                                                   INITIAL YES         NO-UNDO.
DEFINE VARIABLE de-qt-esp             AS INTEGER                    FORMAT "99"                                      NO-UNDO.
DEFINE VARIABLE c-ge-codigo           LIKE item.ge-codigo                                                              NO-UNDO.
DEFINE VARIABLE l-mostra              AS LOGICAL                                                   INITIAL NO          NO-UNDO.
DEFINE VARIABLE de-quant-reserva      AS DECIMAL                    FORMAT "->>>,>>>,>>9.99"                         NO-UNDO.
DEFINE VARIABLE l-util-item           AS LOGICAL                                                                       NO-UNDO.
DEFINE VARIABLE de-quant              AS DECIMAL EXTENT 22                                                             NO-UNDO.
DEFINE VARIABLE de-tempo              AS DECIMAL                    FORMAT "->>>,>>9.9999"                           NO-UNDO.
DEFINE VARIABLE de-tempo-pre          AS DECIMAL                    FORMAT "->>>,>>9.9999"                           NO-UNDO.
DEFINE VARIABLE l-rejeita-dec         AS LOGICAL                                                                       NO-UNDO.
DEFINE VARIABLE c-liter-op-externa    AS CHARACTER                                                                     NO-UNDO.
DEFINE VARIABLE c-liter-ord-serv      AS CHARACTER                  FORMAT "x(15)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-item-1        AS CHARACTER                  FORMAT "x(06)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-ref-1         AS CHARACTER                  FORMAT "x(11)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-ge            AS CHARACTER                  FORMAT "x(03)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-docto         AS CHARACTER                  FORMAT "x(06)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-qt-ordem      AS CHARACTER                  FORMAT "x(16)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-emissao       AS CHARACTER                  FORMAT "x(08)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-inic          AS CHARACTER                  FORMAT "x(07)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-term          AS CHARACTER                  FORMAT "x(07)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-ult-rep       AS CHARACTER                  FORMAT "x(10)"                                   NO-UNDO.   
DEFINE VARIABLE c-liter-ct            AS CHARACTER                  FORMAT "x(10)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-qt-prd        AS CHARACTER                  FORMAT "x(08)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-est-ord       AS CHARACTER                  FORMAT "x(16)"                                   NO-UNDO.        
DEFINE VARIABLE c-liter-estabel       AS CHARACTER                  FORMAT "x(16)"                                   NO-UNDO.        
DEFINE VARIABLE c-liter-qt-refugada   AS CHARACTER                  FORMAT "x(13)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-un            AS CHARACTER                  FORMAT "x(02)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-ref           AS CHARACTER                  FORMAT "x(10)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-desc          AS CHARACTER                  FORMAT "x(12)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-res-qt-orig   AS CHARACTER                  FORMAT "x(16)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-res-qt-atend  AS CHARACTER                  FORMAT "x(16)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-res-qt-saldo  AS CHARACTER                  FORMAT "x(16)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-qt-padrao     AS CHARACTER                  FORMAT "x(12)"                                   NO-UNDO. 
DEFINE VARIABLE c-liter-qt-real       AS CHARACTER                  FORMAT "x(13)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-vl-padrao     AS CHARACTER                  FORMAT "x(15)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-vl-real       AS CHARACTER                  FORMAT "x(13)"                                   NO-UNDO. 
DEFINE VARIABLE c-liter-vr-perc       AS CHARACTER                  FORMAT "x(16)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-item          AS CHARACTER                  FORMAT "x(04)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-oper          AS CHARACTER                  FORMAT "x(04)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-mob-dir       AS CHARACTER                  FORMAT "x(07)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-tp-padrao     AS CHARACTER                  FORMAT "x(15)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-tp-real       AS CHARACTER                  FORMAT "x(10)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-cc-desc       AS CHARACTER                  FORMAT "x(21)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-hm            AS CHARACTER                  FORMAT "x(05)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-gr-maq-desc   AS CHARACTER                  FORMAT "x(21)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-tt-ggf        AS CHARACTER                  FORMAT "x(21)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-tot-mob       AS CHARACTER                  FORMAT "x(25)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-tt-material   AS CHARACTER                  FORMAT "x(19)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-sel           AS CHARACTER                  FORMAT "x(33)"                                   NO-UNDO.  
DEFINE VARIABLE c-liter-par           AS CHARACTER                  FORMAT "x(33)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-impres        AS CHARACTER                  FORMAT "x(18)"                                   NO-UNDO.
DEFINE VARIABLE c-fill132             AS CHARACTER                  FORMAT "x(132)"                                  NO-UNDO.
DEFINE VARIABLE c-liter-movto         AS CHARACTER                  FORMAT "x(28)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-mov-mob       AS CHARACTER                  FORMAT "x(30)"                                   NO-UNDO.
DEFINE VARIABLE c-liter-ggf           AS CHARACTER                  FORMAT "x(25)"                                   NO-UNDO.
DEFINE VARIABLE c-arquivo-novo        AS CHARACTER                                                                   NO-UNDO.
DEFINE VARIABLE c-descricao-pai       AS CHARACTER                  FORMAT "x(36)"                                   NO-UNDO.
DEFINE VARIABLE v-cod-conta           AS CHARACTER                  FORMAT "x(16)"                                   NO-UNDO.
/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.



/* ************************  Function Prototypes ********************** */

FUNCTION fn_ajust_dec RETURNS DECIMAL
 (p-valor AS DECIMAL, p-moeda AS INTEGER) FORWARD.

FUNCTION fn_vld_ajust_dec RETURNS DECIMAL
 (p-valor AS DECIMAL, p-moeda AS INTEGER) FORWARD.

FUNCTION f-item-uni-estab RETURNS CHARACTER
 (p-it-codigo AS CHARACTER, p-cod-estabel AS CHARACTER, p-campo AS CHARACTER) FORWARD.



/* **************************  Form Implementations ******************* */

FORM c-liter-ord-serv           ord-prod.nr-ord-produ
     c-liter-item-1      AT 34  ord-prod.it-codigo
     "-"                      ord-prod.un
     "-"                      c-descricao
     c-liter-ref-1              ord-prod.cod-refer
     c-liter-ge                 c-ge-codigo          SKIP
     c-liter-docto       AT 09  i-documento
     c-liter-qt-ordem           ord-prod.qt-ordem    SKIP
     c-liter-emissao            ord-prod.dt-emissao  FORMAT "99/99/9999"
     c-liter-inic               ord-prod.dt-inicio   FORMAT "99/99/9999"
     c-liter-term               ord-prod.dt-termino  FORMAT "99/99/9999"
     c-liter-ult-rep            c-dattran
     c-liter-ct                 ord-prod.ct-codigo   FORMAT "x(16)"
     c-liter-qt-prd             de-qtidade-produzida SKIP
     c-liter-est-ord            v-estado             SPACE(10)
     c-liter-estabel            ord-prod.cod-estabel
     c-liter-qt-refugada AT 105 ord-prod.qt-refugada
    WITH NO-LABEL NO-BOX WIDTH 132 FRAME f-cabe STREAM-IO.

FORM SKIP(1)
     c-movmat          SKIP(1)
     c-liter-item-1    AT 01
     c-liter-un        AT 18 
     c-liter-ref       AT 21
     c-liter-qt-padrao AT 51 
     c-liter-qt-real   AT 66
     c-liter-vl-padrao AT 79
     c-liter-vl-real   AT 97
     c-liter-vr-perc   AT 115 
     "---------------- -- -------------------- -------------------"
     "--------------- -------------- --------------- --------------- -------"
    WITH WIDTH 132 NO-LABEL NO-BOX FRAME f-movmat STREAM-IO.

FORM SKIP(1)
     c-movmdo
    WITH WIDTH 132 NO-BOX NO-LABEL FRAME f-cabmob STREAM-IO.

FORM tt-mat.it-codigo  AT 01
     item.un           AT 18
     tt-mat.cod-refer  AT 21  
     tt-mat.quant-pad  AT 45  FORMAT "->>>>>>,>>9.9999"
     tt-mat.quant-real AT 61  FORMAT "->>>>>>,>>9.9999"
     de-valpad         AT 77  FORMAT "->>>>>>>,>>9.99"
     de-valreal        AT 93  FORMAT "->>>>>>>,>>9.99"
     de-variacao       AT 110 FORMAT "->>>>>>,>>9.99"
     de-perc           AT 125 FORMAT "->>9.99"
     c-descricao       AT 01
    WITH NO-LABEL WIDTH 132 NO-BOX FRAME f-deta1 STREAM-IO.

FORM SKIP(1)
     c-movmat          SKIP(1)
     c-liter-item-1    AT 01
     c-liter-un        AT 18
     c-liter-desc      AT 21
     c-liter-qt-padrao AT 51
     c-liter-qt-real   AT 66
     c-liter-vl-padrao AT 79
     c-liter-vl-real   AT 97
     c-liter-vr-perc   AT 115
     "---------------- -- -------------------- -------------------"
     "--------------- -------------- --------------- --------------- -------"
    WITH WIDTH 132 NO-LABEL NO-BOX FRAME f-movmat1 STREAM-IO.

FORM tt-mat.it-codigo  AT 01
     item.un           AT 18
     c-descricao       AT 21  FORMAT "x(20)"
     tt-mat.quant-pad  AT 45  FORMAT "->>>>>>,>>9.9999"
     tt-mat.quant-real AT 61  FORMAT "->>>>>>,>>9.9999"
     de-valpad         AT 77  FORMAT "->>>>>>>,>>9.99"
     de-valreal        AT 93  FORMAT "->>>>>>>,>>9.99"
     de-variacao       AT 110 FORMAT "->>>>>>,>>9.99"
     de-perc           AT 125 FORMAT "->>9.99"
    WITH NO-LABEL WIDTH 132 NO-BOX FRAME f-deta11 STREAM-IO.

FORM c-movtmdo
     c-liter-item
     c-liter-oper        AT 17
     c-liter-mob-dir     AT 23
     c-liter-tp-padrao   AT 49
     c-liter-tp-real     AT 66
     c-liter-vl-padrao   AT 79
     c-liter-vl-real     AT 97
     c-liter-vr-perc     AT 115
     "--------------- ----- --------"
     "--------------"  AT 47
     "---------------" AT 62
     "--------------"  AT 78
     "---------------" AT 93
     "---------------" AT 109
     "-------"         AT 125
    WITH WIDTH 132 NO-LABEL NO-BOX FRAME f-deta3 STREAM-IO.

FORM tt-mob.it-codigo  AT 01
     tt-mob.op-codigo  AT 17
     tt-mob.cd-mob-dir AT 23
     tt-mob.tempad     AT 48
     tt-mob.temreal    AT 64
     de-valpad         AT 77
     de-valreal        AT 93
     de-variacao       AT 111
     de-perc           AT 125
    WITH NO-BOX NO-LABEL WIDTH 132 FRAME f-movmob STREAM-IO.

FORM SKIP(1)
     c-movggf
     c-liter-cc-desc
     c-liter-hm          AT 38 SKIP
     c-liter-gr-maq-desc
     c-liter-tp-padrao   AT 48
     c-liter-tp-real     AT 66
     c-liter-vl-padrao   AT 79
     c-liter-vl-real     AT 97
     c-liter-vr-perc     AT 115
     "--------- ---------------------------------- ---------------"
     "--------------- -------------- --------------- --------------- -------"
    WITH WIDTH 132 NO-LABEL NO-BOX FRAME f-movggf STREAM-IO.

FORM c-campo           AS CHARACTER FORM "x(9)"
     c-desc            AT 11
     tt-ggf.tempo-pad  AT 46
     tt-ggf.tempo-real AT 62
     de-valpad         AT 77
     de-valreal        AT 93
     de-variacao       AT 111
     de-perc           AT 125
    WITH NO-LABEL WIDTH 132 NO-BOX FRAME f-deta2 STREAM-IO.

FORM SKIP(1)
     c-liter-tt-ggf
     de-tempad    AT 46
     de-temreal   AT 62
     de-totpad    AT 77
     de-totreal   AT 93
     de-variacao  AT 111
     de-perc      AT 125
    WITH NO-BOX NO-LABEL WIDTH 132 FRAME f-mdo STREAM-IO.

FORM SKIP(1)
     c-liter-tot-mob
     de-tempad       TO 60
     de-temreal      TO 76
     de-totpad       TO 91
     de-totreal      TO 107
     de-variacao     TO 123
     de-perc         TO 131 SKIP(1)
    WITH NO-BOX NO-LABEL WIDTH 132 FRAME f-total-mob STREAM-IO.

FORM SKIP(1)
     c-liter-tt-material
     de-totpad           AT  77 FORMAT "->>>>>>>,>>9.99"
     de-totreal          AT  93 FORMAT "->>>>>>>,>>9.99"
     de-variacao         AT 110 FORMAT "->>>>>>,>>9.99"
     de-perc             AT 125 FORMAT "->>9.99"
    WITH NO-BOX NO-LABEL WIDTH 132 FRAME f-mat STREAM-IO.

FORM c-liter-sel                                      NO-LABEL SKIP(2)
     c-estab     COLON 35                                      SKIP
     d-data-ini  COLON 35 "|< >|" AT 53 d-data-fim  NO-LABEL SKIP            
     d-dtmov-ini COLON 35 "|< >|" AT 53 d-dtmov-fim NO-LABEL SKIP
    WITH WIDTH 132 SIDE-LABELS FRAME f-parametros-2 STREAM-IO.
        
FORM c-liter-par                                              NO-LABEL SKIP(2)
     de-tipo-estado  COLON 35                                          SKIP
     de-variacao-min COLON 35 "|< >|" AT 53 de-variacao-max NO-LABEL SKIP
     l-var-zero      COLON 35                                          SKIP
     da-corte-es     COLON 35                                          SKIP
     da-corte-op     COLON 35                                          SKIP
     c-liter-impres  AT 5                                     NO-LABEL SKIP(2)
     c-destino       COLON 35 "-"                                    SPACE(1)
     c-arquivo
     c-usuario       COLON 35
    WITH WIDTH 132 SIDE-LABELS FRAME f-param-definidos STREAM-IO.



/* ***************************  Main Block  *************************** */

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

ASSIGN c-estab         = tt-param.cod-estabel
       d-data-ini      = tt-param.dt-emissao-ini
       d-data-fim      = tt-param.dt-emissao-fin
       d-dtmov-ini     = tt-param.dt-movto-ini
       d-dtmov-fim     = tt-param.dt-movto-fin
       i-estado        = tt-param.ind-estado
       de-variacao-min = tt-param.variacao-ini
       de-variacao-max = tt-param.variacao-fin
       l-var-zero      = tt-param.lista-zero
       da-corte-es     = tt-param.dt-corte-estrut
       da-corte-op     = tt-param.dt-corte-operac
       l-parametro     = tt-param.l-imp-param
       c-usuario       = tt-param.usuario
       i-moeda         = 0 /* Real */
       i-tipo-preco    = 1 /* Mensal */
       i-tipo-custo    = 1 /* Todos */
       i-tempo         = 1 /* Horas */.
                                
ASSIGN c-liter-op-externa = "OP. EXTERNA".

IF tt-param.ind-estado = 1 THEN
    ASSIGN de-tipo-estado = "Todas".
ELSE
    IF tt-param.ind-estado = 2 THEN
        ASSIGN de-tipo-estado = TRIM({ininc/i01in271.i 04 6}).
    ELSE
        IF tt-param.ind-estado = 3 THEN
            ASSIGN de-tipo-estado = TRIM({ininc/i01in271.i 04 8}).
        ELSE
            ASSIGN de-tipo-estado = TRIM({ininc/i01in271.i 04 7}).

ASSIGN da-iniper-x = d-dtmov-ini
       da-fimper-x = d-dtmov-fim.

ASSIGN c-titulo-relat = "Comparativo Material GGF e M∆o-de-Obra Direta - Espec°fico"
       c-sistema      = "Espec°ficos Intelbras"
       c-programa     = "ESCSP010RP"
       c-versao       = "0.00"
       c-revisao      = "000".

{include/i-rpcab.i}
{include/i-rpout.i}

{esp/es0043.i} /* <--- c-dir-arquivo-session  */

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

ASSIGN l-imprime  = NO
       de-totpad  = 0
       de-totreal = 0
       de-tempad  = 0
       de-temreal = 0.

RUN piImprimeRelatorio.

{include/i-rpclo.i}

RETURN "OK".



/* **********************  Internal Procedures  *********************** */

PROCEDURE piImprimeRelatorio:
/*------------------------------------------------------------------------------
  Purpose:     Rotina de Impress∆o do Relatorio.
  Parameters:  N∆o h†.
  Notes:       CS0501C.P
------------------------------------------------------------------------------*/

    IF CAN-FIND(FIRST funcao
                WHERE funcao.cd-funcao = "spp-cc-custo-estab"
                  AND funcao.ativo NO-LOCK) THEN
        ASSIGN l-fnc-cc-custo-estab = YES.

    ASSIGN c-lt-oper-ext = "Operaá∆o Externa".

    RUN pi-literais.

    ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}
           c-arquivo = tt-param.arquivo.

    ASSIGN c-estab:LABEL         IN FRAME f-parametros-2    = "Estabelecimento"
           d-data-ini:LABEL      IN FRAME f-parametros-2    = "Data Emiss∆o"
           d-dtmov-ini:LABEL     IN FRAME f-parametros-2    = "Data Movtos"
           de-tipo-estado:LABEL  IN FRAME f-param-definidos = "Tipo Estado"
           de-variacao-min:LABEL IN FRAME f-param-definidos = "Faixa Variaá∆o"
           l-var-zero:LABEL      IN FRAME f-param-definidos = "Listar Variaá∆o Zero"
           da-corte-es:LABEL     IN FRAME f-param-definidos = "Corte da Estrutura"
           da-corte-op:LABEL     IN FRAME f-param-definidos = "Corte das Operaá‰es"
           c-destino:LABEL       IN FRAME f-param-definidos = "Destino"
           c-usuario:LABEL       IN FRAME f-param-definidos = "Usu†rio".

    FIND FIRST param-global NO-LOCK.
    FIND FIRST param-estoq  NO-LOCK.

    IF param-estoq.tp-fech = 1 THEN
        ASSIGN c-ult-per-fech = param-estoq.ult-per-fech.
    ELSE DO:
        FIND FIRST estab-mat
            WHERE estab-mat.cod-estabel = tt-param.cod-estabel NO-LOCK NO-ERROR.

        IF AVAILABLE estab-mat THEN
            ASSIGN c-ult-per-fech = estab-mat.ult-per-fech.
        ELSE
            ASSIGN c-ult-per-fech = param-estoq.ult-per-fech.
    END.

    RUN cdp/cdapi005.p (INPUT  c-ult-per-fech,
                        OUTPUT da-iniper,
                        OUTPUT da-fimper,
                        OUTPUT i-per-corrente,
                        OUTPUT i-ano-corrente,
                        OUTPUT da-iniper-fech,
                        OUTPUT da-fimper-fech).

    ASSIGN c-per = STRING(i-ano-corrente, "9999") + STRING(i-per-corrente, "99").

    ASSIGN c-liter-movto   = "Movimentaá‰es Material"
           c-liter-ggf     = "Movimentaá‰es GGF"
           c-liter-mov-mob = "Movimentaá‰es M∆o-de-Obra".

    ASSIGN c-fill132 = FILL("-", 132)
           c-movmat  = FILL("-", 85) + c-liter-movto   + FILL("-", 25)
           c-movmdo  = FILL("-", 85) + c-liter-mov-mob + FILL("-", 22)
           c-movtmdo = FILL("-", 85) + c-liter-mov-mob + FILL("-", 22)
           c-movggf  = FILL("-", 85) + c-liter-ggf     + FILL("-", 30)
           c-empresa = grupo.

    ASSIGN da-iniper-x = d-dtmov-ini
           da-fimper-x = d-dtmov-fim.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Comparativo Real x Padr∆o").

    IF OPSYS = 'unix'
    THEN ASSIGN c-dir-arquivo-session =  c-dir-arquivo-session + c-usuario + '/'.
    ELSE ASSIGN c-dir-arquivo-session =  c-dir-arquivo-session + c-usuario + '\'.

   /* ASSIGN c-arquivo-novo = SESSION:TEMP-DIRECTORY + "ESCSP010-" + REPLACE(STRING(TODAY, "99/99/99"), "/", "") + "-" + REPLACE(STRING(TIME, "HH:MM:SS"), ":", "") + ".txt". */
    ASSIGN c-arquivo-novo = c-dir-arquivo-session + "ESCSP010-" + REPLACE(STRING(TODAY, "99/99/99"), "/", "") + "-" + REPLACE(STRING(TIME, "HH:MM:SS"), ":", "") + ".txt".
    
    PUT UNFORMATTED SKIP "Arquivo Gerado: " c-arquivo-novo SKIP.  
    
    OUTPUT TO VALUE(c-arquivo-novo) NO-CONVERT.
        PUT UNFORMATTED                            
            c-liter-ord-serv    ";"
            c-liter-item-1      ";"
            "un"              ";"
            "descricao"       ";"
            c-liter-ref-1       ";"
            c-liter-ge          ";"
            c-liter-emissao     ";"
            c-liter-docto       ";"
            c-liter-est-ord     ";"
            c-liter-inic        ";"
            c-liter-ct          ";"
            c-liter-qt-ordem    ";"
            c-liter-term        ";"
            c-liter-qt-prd      ";"
            c-liter-ult-rep     ";"
            c-liter-estabel     ";"
            c-liter-qt-refugada ";"
            c-liter-item-1      ";"
            c-liter-un          ";"
            c-liter-desc        ";"
            c-liter-res-qt-orig ";"
            c-liter-res-qt-atend ";"
            c-liter-res-qt-saldo ";"
            c-liter-qt-padrao   ";"
            c-liter-qt-real     ";"
            c-liter-vl-padrao   ";"
            c-liter-vl-real     ";"
            "Variacao"        ";"
            "Percentual"      SKIP.
    OUTPUT CLOSE.

    IF i-estado = 1 THEN DO:
        FOR EACH ord-prod USE-INDEX estabel
            WHERE ord-prod.cod-estabel = c-estab NO-LOCK ON STOP UNDO, LEAVE:

            IF ord-prod.dt-emissao < d-data-ini OR ord-prod.dt-emissao > d-data-fim THEN NEXT.
    
            FIND FIRST rot-item
                WHERE rot-item.it-codigo = ord-prod.it-codigo NO-LOCK NO-ERROR.
    
            ASSIGN l-rot-item = IF AVAILABLE rot-item THEN YES ELSE NO
                   l-primeira = YES
                   l-page     = NO.
    
            RUN piRotinaImpressao.
    
            RUN pi-acompanhar IN h-acomp (INPUT STRING(ord-prod.nr-ord-produ)).
        END.
    END.
    ELSE DO:
        FOR EACH ord-prod USE-INDEX estabel
            WHERE ord-prod.cod-estabel = c-estab NO-LOCK ON STOP UNDO, LEAVE:

            IF ord-prod.dt-emissao < d-data-ini OR ord-prod.dt-emissao > d-data-fim THEN NEXT.

            IF (i-estado = 2 AND ord-prod.estado <> 6) OR (i-estado = 3 AND ord-prod.estado <> 8) OR (i-estado = 4 AND ord-prod.estado <> 7) THEN NEXT.
    
            FIND FIRST rot-item
                WHERE rot-item.it-codigo = ord-prod.it-codigo NO-LOCK NO-ERROR.
    
            ASSIGN l-rot-item = IF AVAILABLE rot-item THEN YES ELSE NO
                   l-primeira = YES
                   l-page     = NO.
    
            RUN piRotinaImpressao.
    
            RUN pi-acompanhar IN h-acomp (INPUT STRING(ord-prod.nr-ord-produ)).
        END.
    END.

    RUN pi-finalizar IN h-acomp.
    RUN pi-parametros.

END PROCEDURE.

PROCEDURE pi-literais:
/*------------------------------------------------------------------------------
  Purpose:     Literais da Frame.
  Parameters:  N∆o h†.
  Notes:       CS0501C.P
------------------------------------------------------------------------------*/
    ASSIGN c-liter-ord-serv      = "Ordem Serviáo:"
           c-liter-item-1        = "Item:"
           c-liter-ref-1         = "Ref.:"
           c-liter-ge            = "Ge:"
           c-liter-docto         = "Docto:"
           c-liter-qt-ordem      = "Quant da Ordem:"
           c-liter-emissao       = "Emiss∆o:"
           c-liter-inic          = "Inic:"
           c-liter-term          = "Term:"
           c-liter-ult-rep       = "Ult rep:"
           c-liter-ct            = "Ct:"
           c-liter-qt-prd        = "Qt Prd:"
           c-liter-est-ord       = "Estado Ordem:"
           c-liter-estabel       = "Estabelecimento:"
           c-liter-qt-refugada   = "Qt Refugada:"
           c-liter-un            = "Un"
           c-liter-ref           = "Referància"
           c-liter-desc          = "Descriá∆o"
           c-liter-res-qt-orig   = "Qt Reserva Orig"
           c-liter-res-qt-atend  = "Qt Reserva Atend"
           c-liter-res-qt-saldo  = "Qt Reserva Saldo"
           c-liter-qt-padrao     = "Qt Padr∆o"
           c-liter-qt-real       = "Quant Real"
           c-liter-vl-padrao     = "Valor Padr∆o"
           c-liter-vl-real       = "Valor Real"
           c-liter-vr-perc       = "Variaá∆o     Perc"
           c-liter-item          = "Item"
           c-liter-oper          = "Oper"
           c-liter-mob-dir       = "Mob Dir"
           c-liter-tp-padrao     = "Tempo Padr∆o"
           c-liter-tp-real       = "Tempo Real"
           c-liter-cc-desc       = "C Custo   Descriá∆o"
           c-liter-hm            = "Horas"
           c-liter-gr-maq-desc   = "Grup Maq  Descriá∆o"
           c-liter-tt-ggf        = "Total GGF:"
           c-liter-tot-mob       = "Total M∆o-de-Obra:"
           c-liter-tt-material   = "Total Materiais:"
           c-liter-par           = "P A R ∂ M E T R O S"
           c-liter-sel           = "S E L E Ä « O"
           c-liter-impres        = "I M P R E S S « O".
END PROCEDURE.

PROCEDURE pi-parametros:
/*------------------------------------------------------------------------------
  Purpose:     Imprime parÉmetros.
  Parameters:  N∆o h†.
  Notes:       CS0501C.P
------------------------------------------------------------------------------*/
    IF l-page           AND
       NOT(l-parametro) THEN DO:
        PAGE.
        DISPLAY "" WITH STREAM-IO.
    END.

    IF l-parametro THEN DO:
        PAGE.

        ASSIGN l-var-zero:FORMAT  IN FRAME f-param-definidos = "Sim/N∆o".

        DISP c-liter-sel
             c-estab
             d-data-ini      d-data-fim
             d-dtmov-ini     d-dtmov-fim
            WITH FRAME f-parametros-2 STREAM-IO.

        DISP c-liter-par
             de-tipo-estado
             de-variacao-min
             de-variacao-max
             l-var-zero
             da-corte-es
             da-corte-op
             c-liter-impres
             c-destino
             c-arquivo
             c-usuario
            WITH FRAME f-param-definidos STREAM-IO.
    END.
END PROCEDURE.

PROCEDURE piRotinaImpressao:
/*------------------------------------------------------------------------------
  Purpose:     Rotina de impress∆o.
  Parameters:  N∆o h†.
  Notes:       CS0501.I
------------------------------------------------------------------------------*/
    FIND FIRST movto-mat NO-LOCK USE-INDEX data
        WHERE movto-mat.nr-ord-produ = ord-prod.nr-ord-produ
          AND movto-mat.dt-trans    >= d-dtmov-ini
          AND movto-mat.dt-trans    <= d-dtmov-fim NO-ERROR.

    FIND FIRST movto-ggf NO-LOCK USE-INDEX ordem
        WHERE movto-ggf.nr-ord-produ = ord-prod.nr-ord-produ
          AND movto-ggf.dt-trans    >= d-dtmov-ini
          AND movto-ggf.dt-trans    <= d-dtmov-fim NO-ERROR.

    FIND FIRST movto-dir NO-LOCK USE-INDEX ordem
        WHERE movto-dir.nr-ord-produ  = ord-prod.nr-ord-produ
          AND movto-dir.dt-trans     >= d-dtmov-ini
          AND movto-dir.dt-trans     <= d-dtmov-fim NO-ERROR.

    IF NOT AVAILABLE movto-mat AND
       NOT AVAILABLE movto-ggf AND
       NOT AVAILABLE movto-dir THEN NEXT.

    FIND LAST movto-mat NO-LOCK USE-INDEX data
        WHERE movto-mat.nr-ord-produ = ord-prod.nr-ord-produ
          AND movto-mat.dt-trans    >= d-dtmov-ini
          AND movto-mat.dt-trans    <= d-dtmov-fim
          AND movto-mat.it-codigo    = ord-prod.it-codigo
          AND movto-mat.esp-docto    = 1
          AND movto-mat.tipo-trans   = 1 NO-ERROR.

    ASSIGN c-dattran = IF AVAILABLE movto-mat THEN STRING(movto-mat.dt-trans, "99/99/9999") ELSE "".

    ASSIGN l-flag  = YES.

    RUN piGeraComponMat.

    ASSIGN de-totpad  = 0
           de-totreal = 0
           de-qtidade = 0
           de-tempad  = 0
           de-temreal = 0.

    FOR EACH movto-mat USE-INDEX data
        WHERE movto-mat.nr-ord-prod = ord-prod.nr-ord-produ
          AND movto-mat.dt-trans   >= d-dtmov-ini
          AND movto-mat.dt-trans   <= d-dtmov-fim NO-LOCK:

        IF  movto-mat.it-codigo = ord-prod.it-codigo AND
           (movto-mat.esp-docto = 1                  OR
            movto-mat.esp-docto = 8)                 THEN NEXT.

        FIND FIRST tt-mat
            WHERE tt-mat.it-codigo = movto-mat.it-codigo
              AND tt-mat.cod-refer = movto-mat.referencia NO-ERROR.

        IF movto-mat.tipo-trans = 1 THEN
            ASSIGN de-qtidade = - movto-mat.quantidade.
        ELSE
            ASSIGN de-qtidade = movto-mat.quantidade.

        IF NOT AVAILABLE tt-mat THEN DO:
            CREATE tt-mat.
            ASSIGN tt-mat.it-codigo  = movto-mat.it-codigo
                   tt-mat.cod-refer  = movto-mat.referencia
                   tt-mat.quant-real = de-qtidade.          

            FOR EACH bff-estrutura NO-LOCK
               WHERE bff-estrutura.it-codigo = ord-prod.it-codigo
                 AND bff-estrutura.fantasma  = YES:
               
               FOR EACH bf-estrutura NO-LOCK
                  WHERE bf-estrutura.it-codigo = bff-estrutura.es-codigo:
               
                   FOR EACH estrutura 
                      WHERE estrutura.it-codigo = bf-estrutura.es-codigo
                        AND estrutura.es-codigo = movto-mat.it-codigo:

                       /*** Pula registros de estrutura fora da validade ***/
                       IF estrutura.data-termino <= DATE(01, 01, 0001) OR
                          estrutura.data-inicio  >  DATE(12, 31, 9999) THEN NEXT.
                       
                       IF estrutura.data-inicio  >  da-corte-es OR
                          estrutura.data-termino <= da-corte-es THEN NEXT.
                       
                       ASSIGN tt-mat.quant-pad = ord-prod.qt-ordem * (estrutura.qtd-compon / estrutura.qtd-item * estrutura.proporcao / 100).
                   END.

               END.

            END.
        END.
        ELSE
            ASSIGN tt-mat.quant-real = tt-mat.quant-real + de-qtidade.

        FIND FIRST item
            WHERE item.it-codigo = movto-mat.it-codigo NO-LOCK NO-ERROR.

        IF NOT AVAILABLE item THEN NEXT.

        IF item.tipo-contr = 4 THEN DO:
            ASSIGN de-valor-mat-m-conver = IF i-tipo-preco = 2
                                                THEN (movto-mat.valor-mat-o[i-moeda + 1] + movto-mat.valor-ggf-o[i-moeda + 1] + movto-mat.valor-mob-o[i-moeda + 1])
                                                ELSE &IF DEFINED(bf_man_custeio_item) &THEN &ELSE
                                                     IF i-tipo-preco = 3 THEN
                                                         (movto-mat.valor-mat-p[i-moeda + 1] + movto-mat.valor-ggf-p[i-moeda + 1] + movto-mat.valor-mob-p[i-moeda + 1])
                                                     ELSE
                                                     &ENDIF
                                                     /* Mensal/Ult.Entrada/Reposiá∆o/Base */
                                                     (movto-mat.valor-mat-m[i-moeda + 1] + movto-mat.valor-ggf-m[i-moeda + 1] + movto-mat.valor-mob-m[i-moeda + 1]).
            IF movto-mat.tipo-trans = 1 THEN
                ASSIGN de-valor-mat-m-conver = de-valor-mat-m-conver * (-1).

            ASSIGN tt-mat.val-dd = tt-mat.val-dd + de-valor-mat-m-conver.
        END.
    END.

    FOR EACH tt-mat
        BREAK BY tt-mat.it-codigo
              BY tt-mat.cod-refer:

        FIND FIRST item
            WHERE item.it-codigo = tt-mat.it-codigo NO-LOCK NO-ERROR.
            
        &IF DEFINED(bf_man_custeio_item) &THEN
        FIND FIRST item-uni-estab
            WHERE item-uni-estab.it-codigo   = tt-mat.it-codigo
              AND item-uni-estab.cod-estabel = tt-param.cod-estabel NO-LOCK NO-ERROR.

        IF NOT AVAILABLE item-uni-estab THEN NEXT.
        &ENDIF

        ASSIGN de-valreal  = 0
               de-valaux   = 0
               c-descricao = IF tt-mat.it-codigo = c-liter-op-externa
                                THEN c-lt-oper-ext
                                ELSE IF AVAILABLE item THEN
                                        item.desc-item
                                     ELSE "".
                                         
        IF tt-mat.it-codigo = c-liter-op-externa THEN
            ASSIGN da-data   = tt-mat.dt-movto
                   de-valaux = tt-mat.vl-mobext[i-moeda + 1].
        ELSE DO:
            IF i-tipo-preco = 4 THEN
                &IF DEFINED(bf_man_custeio_item) &THEN
                ASSIGN da-data   = item-uni-estab.data-base
                       de-valaux = item-uni-estab.preco-base.
                &ELSE
                ASSIGN da-data   = item.data-base
                       de-valaux = item.preco-base.
                &ENDIF
            ELSE
                IF i-tipo-preco = 6 THEN
                    &IF DEFINED(bf_man_custeio_item) &THEN
                    ASSIGN da-data   = item-uni-estab.data-ult-ent
                           de-valaux = item-uni-estab.preco-ul-ent.
                    &ELSE
                    ASSIGN da-data   = item.data-ult-ent
                           de-valaux = item.preco-ul-ent.
                    &ENDIF
                ELSE
                    IF i-tipo-preco = 5 THEN
                        &IF DEFINED(bf_man_custeio_item) &THEN
                        ASSIGN da-data   = item-uni-estab.data-ult-rep
                               de-valaux = item-uni-estab.preco-repos.
                        &ELSE
                        ASSIGN da-data   = item.data-ult-rep
                               de-valaux = item.preco-repos.
                        &ENDIF
                    ELSE DO:
                        FIND FIRST item-estab
                            WHERE item-estab.it-codigo   = item.it-codigo
                              AND item-estab.cod-estabel = tt-param.cod-estabel NO-LOCK NO-ERROR.

                        IF AVAILABLE item-estab THEN
                            ASSIGN da-data   = TODAY
                                   de-valaux = IF i-tipo-preco = 1
                                                    THEN item-estab.val-unit-mat-m[i-moeda + 1] + item-estab.val-unit-ggf-m[i-moeda + 1] + item-estab.val-unit-mob-m[i-moeda + 1]
                                                    ELSE &IF DEFINED(bf_man_custeio_item) &THEN
                                                         item-estab.val-unit-mat-o[i-moeda + 1] + item-estab.val-unit-ggf-o[i-moeda + 1] + item-estab.val-unit-mob-o[i-moeda + 1].
                                                         &ELSE
                                                         IF i-tipo-preco = 2 THEN
                                                             item-estab.val-unit-mat-o[i-moeda + 1] + item-estab.val-unit-ggf-o[i-moeda + 1] + item-estab.val-unit-mob-o[i-moeda + 1]
                                                         ELSE
                                                             item-estab.val-unit-mat-p[i-moeda + 1] + item-estab.val-unit-ggf-p[i-moeda + 1] + item-estab.val-unit-mob-p[i-moeda + 1].
                                                         &ENDIF
                    END.
        END.

        IF  tt-mat.it-codigo <> c-liter-op-externa AND
           (tt-mat.it-codigo  = " "              OR
            item.tipo-contr   = 4)                 THEN
            ASSIGN de-valaux = tt-mat.val-dd.

        IF i-tipo-preco > 3 THEN DO:
            RUN cdp/cd0812.p (INPUT  0,
                              INPUT  i-moeda,
                              INPUT  de-valaux,
                              INPUT  da-data,
                              OUTPUT de-valaux).

            IF de-valaux = ? THEN
                ASSIGN de-valaux = 0.
        END.

        IF  tt-mat.it-codigo <> c-liter-op-externa AND
           (tt-mat.it-codigo = " "               OR
            item.tipo-contr  = 4)                  THEN
            ASSIGN de-valreal  = de-valreal + de-valaux
                   de-valpad   = 0
                   de-variacao = 0.
        ELSE DO:
            ASSIGN de-valreal  = de-valreal + de-valaux
                   de-valpad   = fn_ajust_dec((de-valreal * tt-mat.quant-pad), i-moeda)
                   de-valreal  = fn_ajust_dec((de-valreal * tt-mat.quant-real), i-moeda)
                   de-variacao = de-valreal - de-valpad.
        END.

        IF de-valpad   = 0 AND
           de-variacao = 0 THEN
            ASSIGN de-perc = 0.
        ELSE
            IF de-valpad    = 0 AND
               de-variacao <> 0 THEN
                ASSIGN de-perc = 999.99.
            ELSE
                ASSIGN de-perc = (de-variacao * 100) / de-valpad.
                    
        IF de-perc > 999.99 THEN
            ASSIGN de-perc = 999.99.
        ELSE
            IF de-perc < -999.99 THEN
                ASSIGN de-perc = -999.99.

        IF de-valpad < 0          AND
           de-valpad < de-valreal THEN DO:
            ASSIGN de-perc = de-perc * -1.
        END.

        FIND FIRST reservas NO-LOCK
             WHERE reservas.nr-ord-prod = ord-prod.nr-ord-produ
               AND reservas.it-codigo   = tt-mat.it-codigo NO-ERROR.
        IF AVAIL reservas THEN DO:
            ASSIGN tt-mat.qt-reservas-orig  = reservas.quant-orig 
                   tt-mat.qt-reservas-atend = reservas.quant-atend
                   tt-mat.qt-reservas-saldo = reservas.quant-orig - reservas.quant-atend.
        END.

        IF de-perc >= de-variacao-min AND
           de-perc <= de-variacao-max THEN DO:
            IF de-perc    = 0  AND
               l-var-zero = NO THEN
                ASSIGN de-perc = 0.
            ELSE DO:
                IF l-flag THEN DO:
                    PAGE.
                        
                    FIND FIRST item
                        WHERE item.it-codigo = ord-prod.it-codigo NO-LOCK NO-ERROR.

                    IF AVAILABLE item THEN
                        ASSIGN c-descricao     = item.desc-item
                               c-descricao-pai = item.desc-item
                               c-ge-codigo     = item.ge-codigo.
                    ELSE
                        ASSIGN c-descricao     = ""
                               c-descricao-pai = ""
                               c-ge-codigo     = 0.

                    ASSIGN v-estado    = {ininc/i01in271.i 04 ord-prod.estado}
                           v-cod-conta = ord-prod.ct-codigo + ord-prod.sc-codigo.

                    DISP c-liter-ord-serv    ord-prod.nr-ord-produ
                         c-liter-item-1      ord-prod.it-codigo
                                             ord-prod.un
                                             c-descricao
                         c-liter-ref-1       ord-prod.cod-refer
                         c-liter-ge          c-ge-codigo
                         c-liter-emissao     ord-prod.dt-emissao
                         c-liter-docto       i-documento
                         c-liter-est-ord     v-estado
                         c-liter-inic        ord-prod.dt-inicio
                         c-liter-ct          v-cod-conta
                         c-liter-qt-ordem    ord-prod.qt-ordem
                         //c-liter-emissao     ord-prod.dt-emissao
                         //c-liter-inic        ord-prod.dt-inicio
                         c-liter-term        ord-prod.dt-termino
                         c-liter-qt-prd      de-qtidade-produzida
                         c-liter-ult-rep     c-dattran
                         //c-liter-ct          v-cod-conta
                         c-liter-qt-prd      de-qtidade-produzida
                         //c-liter-est-ord     v-estado
                         c-liter-estabel     ord-prod.cod-estabel
                         c-liter-qt-refugada ord-prod.qt-refugada
                        WITH NO-LABELS FRAME f-cabe STREAM-IO.

                    ASSIGN l-flag = NO.

                    FIND FIRST item
                        WHERE item.it-codigo = tt-mat.it-codigo NO-LOCK NO-ERROR.

                    ASSIGN c-descricao = IF tt-mat.it-codigo <> c-liter-op-externa
                                            THEN IF AVAILABLE item THEN item.desc-item ELSE ""
                                            ELSE c-lt-oper-ext.
                END.

                IF tt-mat.it-codigo <> c-liter-op-externa THEN DO:
                    IF l-primeira         OR
                       LINE-COUNTER >= 64 OR
                       LINE-COUNTER <= 12 THEN DO:
                        DISP c-movmat
                             c-liter-item-1
                             c-liter-un
                             c-liter-desc
                             c-liter-qt-padrao
                             c-liter-qt-real
                             c-liter-vl-padrao
                             c-liter-vl-real
                             c-liter-vr-perc
                            WITH WIDTH 132 NO-LABEL NO-BOX FRAME f-movmat1 STREAM-IO.

                        ASSIGN l-primeira = NO
                               l-mostra   = YES.
                    END.

                    DISP tt-mat.it-codigo
                         item.un
                         c-descricao
                         tt-mat.quant-pad
                         tt-mat.quant-real
                         de-valpad
                         de-valreal
                         de-variacao
                         de-perc
                        WITH FRAME f-deta11 STREAM-IO.
                    DOWN WITH FRAME f-deta11.

                    OUTPUT TO VALUE(c-arquivo-novo) NO-CONVERT APPEND.
                    PUT UNFORMATTED 
                        ord-prod.nr-ord-produ ";"
                        ord-prod.it-codigo    ";"
                        ord-prod.un           ";"
                        c-descricao-pai       ";"
                        ord-prod.cod-refer    ";"
                        c-ge-codigo           ";"
                        ord-prod.dt-emissao   ";"
                        i-documento           ";"
                        v-estado              ";"
                        ord-prod.dt-inicio    ";"
                        ord-prod.ct-codigo    ";"
                        //ord-prod.sc-codigo    ";"
                        ord-prod.qt-ordem     ";"
                        ord-prod.dt-termino   ";"
                        de-qtidade-produzida  ";"
                        c-dattran             ";"
                        ord-prod.cod-estabel  ";"
                        ord-prod.qt-refugada  ";"
                        tt-mat.it-codigo      ";"
                        item.un               ";"
                        c-descricao           ";"
                        tt-mat.qt-reservas-orig ";"
                        tt-mat.qt-reservas-atend ";"
                        tt-mat.qt-reservas-saldo ";"
                        tt-mat.quant-pad      ";"
                        tt-mat.quant-real     ";"
                        de-valpad             ";"
                        de-valreal            ";"
                        de-variacao           ";"
                        de-perc               SKIP.
                    OUTPUT CLOSE.
                END.
                ELSE DO:
                    IF l-primeira         OR
                       LINE-COUNTER >= 64 OR
                       LINE-COUNTER <= 12 THEN DO:
                        DISP c-movmat
                             c-liter-item-1
                             c-liter-un
                             c-liter-ref
                             c-liter-qt-padrao
                             c-liter-qt-real
                             c-liter-vl-padrao
                             c-liter-vl-real
                             c-liter-vr-perc
                            WITH WIDTH 132 NO-LABEL NO-BOX FRAME f-movmat STREAM-IO.

                        ASSIGN l-primeira = NO
                               l-mostra   = YES.
                    END.

                    IF tt-mat.it-codigo = c-liter-op-externa THEN DO:
                        DISP tt-mat.it-codigo
                             tt-mat.cod-refer
                             " " @ item.un
                             " " @ c-descricao
                             tt-mat.quant-pad
                             tt-mat.quant-real
                             de-valpad de-valreal
                             de-variacao
                             de-perc
                            WITH FRAME f-deta1 STREAM-IO.
                        DOWN WITH FRAME f-deta1.

                        OUTPUT TO VALUE(c-arquivo-novo) NO-CONVERT APPEND.
                        PUT UNFORMATTED 
                            ord-prod.nr-ord-produ ";"
                            ord-prod.it-codigo    ";"
                            ord-prod.un           ";"
                            c-descricao-pai       ";"
                            ord-prod.cod-refer    ";"
                            c-ge-codigo           ";"
                            ord-prod.dt-emissao   ";"
                            i-documento           ";"
                            v-estado              ";"
                            ord-prod.dt-inicio    ";"
                            ord-prod.ct-codigo    ";"
                            //ord-prod.sc-codigo    ";"
                            ord-prod.qt-ordem     ";"
                            ord-prod.dt-termino   ";"
                            de-qtidade-produzida  ";"
                            c-dattran             ";"
                            ord-prod.cod-estabel  ";"
                            ord-prod.qt-refugada  ";"
                            tt-mat.it-codigo      ";"
                            item.un               ";"
                            c-descricao           ";"
                            tt-mat.qt-reservas-orig ";"
                            tt-mat.qt-reservas-atend ";"
                            tt-mat.qt-reservas-saldo ";"
                            tt-mat.quant-pad      ";"
                            tt-mat.quant-real     ";"
                            de-valpad             ";"
                            de-valreal            ";"
                            de-variacao           ";"
                            de-perc               SKIP.
                        OUTPUT CLOSE.
                    END.
                END.

                ASSIGN l-imprime = YES.

                IF LINE-COUNTER > 63 THEN
                    ASSIGN l-flag = YES.

                ASSIGN de-totpad  = de-totpad  + de-valpad
                       de-totreal = de-totreal + de-valreal
                       de-tempad  = de-tempad  + tt-mat.quant-pad
                       de-temreal = de-temreal + tt-mat.quant-real.
            END.
        END.
    END.

    ASSIGN de-variacao = de-totreal - de-totpad.

    IF de-totpad   = 0 AND
       de-variacao = 0 THEN
        ASSIGN de-perc = 0.

    ELSE
        IF de-totpad    = 0 AND
           de-variacao <> 0 THEN
            ASSIGN de-perc = 999.99.
        ELSE
            ASSIGN de-perc = (de-variacao * 100) / de-totpad.
                
    IF de-perc > 999.99 THEN
        ASSIGN de-perc = 999.99.
    ELSE
        IF de-perc < -999.99 THEN
            ASSIGN de-perc = -999.99.
            
    IF de-totpad < 0          AND
       de-totpad < de-totreal THEN
        ASSIGN de-perc = de-perc * -1.

    IF l-flag    AND
       l-imprime THEN DO:
        PAGE.

        ASSIGN l-flag = NO
               v-estado = {ininc/i01in271.i 04 i-estado}.
    
        FIND FIRST item
            WHERE item.it-codigo = ord-prod.it-codigo NO-LOCK NO-ERROR.
    
        ASSIGN c-ge-codigo = IF AVAILABLE item THEN item.ge-codigo ELSE 0
               c-descricao = item.desc-item
               v-cod-conta = ord-prod.ct-codigo + ord-prod.sc-codigo.
    
        
        DISP c-liter-ord-serv    ord-prod.nr-ord-produ
             c-liter-item-1      ord-prod.it-codigo
                                 ord-prod.un
                                 c-descricao
             c-liter-ref-1       ord-prod.cod-refer
             c-liter-ge          c-ge-codigo
             c-liter-emissao     ord-prod.dt-emissao
             c-liter-docto       i-documento
             c-liter-est-ord     v-estado
             c-liter-inic        ord-prod.dt-inicio
             c-liter-ct          v-cod-conta
             c-liter-qt-ordem    ord-prod.qt-ordem
             c-liter-emissao     ord-prod.dt-emissao
             c-liter-inic        ord-prod.dt-inicio
             c-liter-term        ord-prod.dt-termino
             c-liter-qt-prd      de-qtidade-produzida
             c-liter-ult-rep     c-dattran
             c-liter-ct          v-cod-conta
             c-liter-qt-prd      de-qtidade-produzida
             c-liter-est-ord     v-estado
             c-liter-estabel     ord-prod.cod-estabel
             c-liter-qt-refugada ord-prod.qt-refugada
            WITH NO-LABELS FRAME f-cabe STREAM-IO.
    END.

    IF l-imprime AND
       l-mostra THEN DO:
        DOWN WITH FRAME f-mat.
        DISP c-liter-tt-material
             de-totpad
             de-totreal
             de-variacao
             de-perc
            WITH FRAME f-mat STREAM-IO.
    END.

    ASSIGN l-imprime = NO.

    FOR EACH movto-ggf USE-INDEX ordem
        WHERE movto-ggf.nr-ord-produ = ord-prod.nr-ord-produ
          AND movto-ggf.dt-trans    >= d-dtmov-ini
          AND movto-ggf.dt-trans    <= d-dtmov-fim NO-LOCK:
        
        IF movto-ggf.tipo-trans = 1 THEN
            ASSIGN de-qtidade = movto-ggf.horas-report.
        ELSE
            ASSIGN de-qtidade = - movto-ggf.horas-report.

        RUN csp/csapi501.p (INPUT  i-tempo,
                            INPUT  1,
                            INPUT  de-qtidade,
                            OUTPUT de-qtidade).

        FIND FIRST tt-ggf
            WHERE tt-ggf.cc-codigo = movto-ggf.cc-codigo
              AND tt-ggf.gm-codigo = movto-ggf.gm-codigo NO-LOCK NO-ERROR.

        IF NOT AVAILABLE tt-ggf THEN DO:
            CREATE tt-ggf.
            ASSIGN tt-ggf.cc-codigo  = movto-ggf.cc-codigo
                   tt-ggf.gm-codigo  = movto-ggf.gm-codigo
                   tt-ggf.tempo-real = de-qtidade.
        END.
        ELSE
            ASSIGN tt-ggf.tempo-real = tt-ggf.tempo-real + de-qtidade.
    END.

    FIND FIRST tt-ggf NO-LOCK NO-ERROR.

    IF AVAILABLE tt-ggf THEN DO:
        ASSIGN l-impmob   = YES
               de-totpad  = 0
               de-totreal = 0
               de-valcc   = 0
               de-tempad  = 0
               de-temreal = 0.

        FOR EACH tt-ggf NO-LOCK
            BREAK BY tt-ggf.cc-codigo
                  BY tt-ggf.gm-codigo:

            IF l-fnc-cc-custo-estab THEN DO:
                FIND FIRST ext-per-custo-estab
                    WHERE ext-per-custo-estab.cc-codigo   = tt-ggf.cc-codigo
                      AND ext-per-custo-estab.cod-estabel = tt-param.cod-estabel
                      AND ext-per-custo-estab.mo-codigo   = i-moeda
                      AND ext-per-custo-estab.periodo     = c-per NO-LOCK NO-ERROR.

                IF AVAILABLE ext-per-custo-estab THEN DO i-var = 1 TO 6:
                    ASSIGN de-valcc = IF i-tipo-custo = 2
                                        THEN de-valcc + ext-per-custo-estab.custo-prev[i-var]
                                        ELSE IF i-tipo-custo = 1 THEN de-valcc + ext-per-custo-estab.custo-total[i-var] ELSE de-valcc + ext-per-custo-estab.custo-pad[i-var].
                END.
            END.
            ELSE DO:
                FIND FIRST ext-per-custo
                    WHERE ext-per-custo.cc-codigo = tt-ggf.cc-codigo
                      AND ext-per-custo.mo-codigo = i-moeda
                      AND ext-per-custo.periodo   = c-per NO-LOCK NO-ERROR.

                IF AVAILABLE ext-per-custo THEN DO i-var = 1 TO 6:
                    ASSIGN de-valcc = IF i-tipo-custo = 2
                                        THEN de-valcc + ext-per-custo.custo-prev[i-var]
                                        ELSE if  i-tipo-custo = 1 THEN de-valcc + ext-per-custo.custo-total[i-var] ELSE de-valcc + ext-per-custo.custo-pad[i-var].
                END.
            END.

            FIND FIRST centro-custo
                WHERE centro-custo.cc-codigo = tt-ggf.cc-codigo NO-LOCK NO-ERROR.

            IF NOT AVAILABLE centro-custo THEN NEXT.

            FIND FIRST grup-maquina
                WHERE grup-maquina.gm-codigo = tt-ggf.gm-codigo NO-LOCK NO-ERROR.

            IF i-tipo-custo = 1 THEN DO:
                IF l-fnc-cc-custo-estab THEN
                    ASSIGN de-valcc = fn_ajust_dec((de-valcc / IF AVAILABLE ext-per-custo-estab THEN ext-per-custo-estab.horas-report ELSE 1), i-moeda).
                ELSE
                    ASSIGN de-valcc = fn_ajust_dec((de-valcc / IF AVAILABLE centro-custo THEN centro-custo.horas-report ELSE 1), i-moeda).
            END.

            ASSIGN de-valreal = fn_ajust_dec(((de-valcc * tt-ggf.tempo-real)), i-moeda)
                   de-valpad  = fn_ajust_dec(((de-valcc * tt-ggf.tempo-pad)),  i-moeda)
                   de-valpre  = fn_ajust_dec(((de-valcc * tt-ggf.tempo-pre)),  i-moeda).

            IF de-valreal = ? THEN
                ASSIGN de-valreal = 0.

            IF de-valpad = ? THEN
                ASSIGN de-valpad  = 0.

            IF de-valpre = ? THEN
                ASSIGN de-valpre  = 0.

            ASSIGN de-variacao = de-valreal - de-valpad
                   de-perc     = IF de-valpad = 0 AND de-variacao = 0 THEN 0 ELSE IF de-valpad = 0 AND de-variacao <> 0 THEN 999.99 ELSE (de-variacao * 100) / de-valpad
                   de-perc     = IF de-perc > 999.99 THEN 999.99 ELSE IF de-perc < -999.99 THEN -999.99 ELSE de-perc.

            IF de-valpad < 0          AND
               de-valpad < de-valreal THEN
                ASSIGN de-perc = de-perc * -1.

            IF de-perc >= de-variacao-min AND
               de-perc <= de-variacao-max THEN DO:
                IF de-perc    = 0  AND
                   l-var-zero = NO THEN
                    ASSIGN de-perc = 0.

                ELSE DO:
                    IF l-flag THEN DO:
                        PAGE.

                        FIND FIRST item
                            WHERE item.it-codigo = ord-prod.it-codigo NO-LOCK NO-ERROR.

                        ASSIGN c-ge-codigo = IF AVAILABLE item THEN item.ge-codigo ELSE 0 c-descricao = item.desc-item
                               v-cod-conta = ord-prod.ct-codigo + ord-prod.sc-codigo.

                        DISP c-liter-ord-serv    ord-prod.nr-ord-produ
                             c-liter-item-1      ord-prod.it-codigo
                                                 ord-prod.un
                                                 c-descricao
                             c-liter-ref-1       ord-prod.cod-refer
                             c-liter-ge          c-ge-codigo
                             c-liter-emissao     ord-prod.dt-emissao
                             c-liter-docto       i-documento
                             c-liter-est-ord     v-estado
                             c-liter-inic        ord-prod.dt-inicio
                             c-liter-ct          v-cod-conta
                             c-liter-qt-ordem    ord-prod.qt-ordem
                             c-liter-emissao     ord-prod.dt-emissao
                             c-liter-inic        ord-prod.dt-inicio
                             c-liter-term        ord-prod.dt-termino
                             c-liter-qt-prd      de-qtidade-produzida 
                             c-liter-ult-rep     c-dattran
                             c-liter-ct          v-cod-conta
                             c-liter-qt-prd      de-qtidade-produzida 
                             c-liter-est-ord     v-estado
                             c-liter-estabel     ord-prod.cod-estabel
                             c-liter-qt-refugada ord-prod.qt-refugada 
                            WITH NO-LABELS FRAME f-cabe STREAM-IO.

                        ASSIGN l-flag = NO.

                        DISP c-movggf
                             c-liter-cc-desc
                             c-liter-hm
                             c-liter-gr-maq-desc
                             c-liter-tp-padrao
                             c-liter-tp-real
                             c-liter-vl-padrao
                             c-liter-vl-real
                             c-liter-vr-perc
                            WITH FRAME f-movggf STREAM-IO.
                    END.

                    IF l-impmob THEN DO:
                        DISP c-movggf
                             c-liter-cc-desc
                             c-liter-hm
                             c-liter-gr-maq-desc
                             c-liter-tp-padrao
                             c-liter-tp-real
                             c-liter-vl-padrao
                             c-liter-vl-real
                             c-liter-vr-perc
                            WITH FRAME f-movggf STREAM-IO.

                        ASSIGN l-impmob = NO.
                    END.

                    IF AVAILABLE centro-custo THEN DO:
                        IF centro-custo.tempo-ggf = 1 THEN
                            ASSIGN c-hm = "Hom.".
                        ELSE
                            ASSIGN c-hm = "Maq.".
                    END.

                    IF FIRST-OF(tt-ggf.cc-codigo) THEN DO:
                        IF AVAILABLE centro-custo THEN DO:
                            de-qt-esp = 26 - LENGTH(centro-custo.descricao).

                            DISP STRING(tt-ggf.cc-codigo, "99999999") @ c-campo
                                 SUBSTRING(centro-custo.descricao,1,26) + FILL(" ", de-qt-esp) + " " + c-hm @ c-desc
                                WITH FRAME f-deta2 STREAM-IO.
                            DOWN WITH FRAME f-deta2 STREAM-IO.
                        END.
                    END.

                    assign c-desc = IF AVAILABLE grup-maquina THEN grup-maquina.descricao ELSE "".

                    IF l-var-zero = NO AND
                       de-variacao = 0 THEN NEXT.

                    DISP tt-ggf.gm-codigo @ c-campo
                         c-desc
                         tt-ggf.tempo-pad
                         tt-ggf.tempo-real
                         de-valpad
                         de-valreal
                         de-variacao
                         de-perc
                        WITH FRAME f-deta2 STREAM-IO.
                    DOWN WITH FRAME f-deta2.

                    IF LINE-COUNTER > 63 THEN
                        ASSIGN l-flag = YES.

                    ASSIGN l-imprime  = YES
                           de-totpad  = de-totpad  + de-valpad
                           de-totreal = de-totreal + de-valreal
                           de-tempad  = de-tempad  + tt-ggf.tempo-pad
                           de-temreal = de-temreal + tt-ggf.tempo-real
                           de-valcc = 0.
                END.
            END.

            ASSIGN de-variacao = de-totreal - de-totpad
                   de-perc     = IF de-totpad = 0 AND de-variacao = 0
                                    THEN 0
                                    ELSE IF de-totpad = 0 AND de-variacao <> 0
                                            THEN 999.99
                                            ELSE (de-variacao * 100) / de-totpad
                   de-perc     = IF de-perc > 999.99
                                    THEN 999.99
                                    ELSE IF de-perc < -999.99
                                            THEN -999.99
                                            ELSE de-perc.

            IF de-totpad < 0          AND
               de-totpad < de-totreal THEN
                ASSIGN de-perc = de-perc * -1.
        END.

        IF l-imprime THEN DO:
            DOWN WITH FRAME f-mdo.

            DISP c-liter-tt-ggf
                 de-tempad
                 de-temreal
                 de-totpad
                 de-totreal
                 de-variacao
                 de-perc
                WITH FRAME f-mdo STREAM-IO.
            DOWN WITH FRAME f-mdo.
        END.
    END.
    

    /********************* MOVIMENTAÄÂES M«O-DE-OBRA **************************/
    ASSIGN l-imprime = NO.

    FOR EACH movto-dir USE-INDEX ordem
        WHERE movto-dir.nr-ord-produ = ord-prod.nr-ord-produ
          AND movto-dir.dt-trans    >= d-dtmov-ini
          AND movto-dir.dt-trans    <= d-dtmov-fim NO-LOCK:
        IF movto-dir.tipo-trans = 1 THEN
            ASSIGN de-qtidade = movto-dir.tempo-homem.
        ELSE
            ASSIGN de-qtidade = - movto-dir.tempo-homem.
                
        FIND FIRST tt-mob
            WHERE tt-mob.op-codigo  = movto-dir.op-codigo
              AND tt-mob.cd-mob-dir = movto-dir.cd-mob-dir NO-ERROR.

        IF NOT AVAILABLE tt-mob THEN DO:
            CREATE tt-mob.
            ASSIGN tt-mob.it-codigo  = movto-dir.it-codigo
                   tt-mob.op-codigo  = movto-dir.op-codigo
                   tt-mob.cd-mob-dir = movto-dir.cd-mob-dir
                   tt-mob.temreal    = de-qtidade.
        END.
        ELSE
            ASSIGN tt-mob.temreal    = temreal + de-qtidade
                   tt-mob.it-codigo  = movto-dir.it-codigo
                   tt-mob.cd-mob-dir = movto-dir.cd-mob-dir.

        IF AVAILABLE tt-mob THEN
            RUN csp/csapi501.p (INPUT  i-tempo,
                                INPUT  1,
                                INPUT  tt-mob.temreal,
                                OUTPUT tt-mob.temreal).
    END.

    
    FIND FIRST tt-mob NO-LOCK NO-ERROR.

    IF AVAILABLE tt-mob THEN DO:
        ASSIGN l-impmob   = YES
               de-totpad  = 0
               de-totreal = 0
               de-valcc   = 0
               de-tempad  = 0
               de-temreal = 0
               l-primeira = YES.

        FOR EACH tt-mob NO-LOCK
            BREAK BY tt-mob.it-codigo
                  BY tt-mob.op-codigo:
            FIND FIRST tab-mob-dir
                WHERE tab-mob-dir.cd-mob-dir = tt-mob.cd-mob-dir NO-LOCK NO-ERROR.

            IF AVAILABLE(tab-mob-dir) THEN DO:
                ASSIGN c-cd-mob-dir = tab-mob-dir.cd-mob-dir.

                IF i-tipo-custo = 1 THEN /* Total */
                    ASSIGN de-valor-mob = tab-mob-dir.vl-corrente[i-moeda + 1].
                ELSE
                    IF i-tipo-custo = 2 THEN /* Previsto */
                        ASSIGN de-valor-mob = tab-mob-dir.vl-orcado[i-moeda + 1].
                    ELSE
                        IF i-tipo-custo = 3 THEN /* Padr∆o */
                            ASSIGN de-valor-mob = tab-mob-dir.vl-padrao[i-moeda + 1].
            END.
            ELSE
                ASSIGN de-valor-mob = 0.

            ASSIGN de-valreal = fn_ajust_dec(((de-valor-mob * tt-mob.temreal)), i-moeda)
                   de-valpad  = fn_ajust_dec(((de-valor-mob * tt-mob.tempad)),  i-moeda).

            IF de-valreal = ? THEN
                ASSIGN de-valreal = 0.
            
            IF de-valpad  = ? THEN
                ASSIGN de-valpad  = 0.

            ASSIGN de-variacao = de-valreal - de-valpad
                   de-perc     = IF de-valpad = 0 AND de-variacao = 0
                                    THEN 0
                                    ELSE
                                        IF de-valpad = 0 AND de-variacao <> 0 THEN 999.99 ELSE (de-variacao * 100) / de-valpad.

            ASSIGN de-perc     = IF de-perc > 999.99
                                    THEN 999.99
                                    ELSE
                                        IF de-perc < -999.99 THEN -999.99 ELSE de-perc.                                                

            IF de-valpad < 0          AND
               de-valpad < de-valreal THEN
                ASSIGN de-perc = de-perc * -1.

            IF de-perc >= de-variacao-min AND
               de-perc <= de-variacao-max THEN DO:

                IF de-perc    = 0  AND
                   l-var-zero = NO THEN
                    ASSIGN de-perc = 0.
                ELSE DO:
                    IF l-movmob THEN DO:
                        DISP c-movmdo
                            WITH FRAME f-cabmob.
                        ASSIGN l-movmob = NO.
                    END.
                    IF l-primeira         OR
                       LINE-COUNTER  > 63 OR
                       LINE-COUNTER <= 8  THEN DO:
                        FIND FIRST item
                            WHERE item.it-codigo = ord-prod.it-codigo NO-LOCK NO-ERROR.

                        ASSIGN c-ge-codigo = IF AVAILABLE item THEN item.ge-codigo ELSE 0
                               c-descricao = item.desc-item
                               v-cod-conta = ord-prod.ct-codigo + ord-prod.sc-codigo.

                        IF LINE-COUNTER >  63 OR
                           LINE-COUNTER <= 8  THEN
                            
                            DISP c-liter-ord-serv    ord-prod.nr-ord-produ
                                 c-liter-item-1      ord-prod.it-codigo
                                                     ord-prod.un
                                                     c-descricao
                                 c-liter-ref-1       ord-prod.cod-refer
                                 c-liter-ge          c-ge-codigo
                                 c-liter-emissao     ord-prod.dt-emissao
                                 c-liter-docto       i-documento
                                 c-liter-est-ord     v-estado
                                 c-liter-inic        ord-prod.dt-inicio
                                 c-liter-ct          v-cod-conta
                                 c-liter-qt-ordem    ord-prod.qt-ordem
                                 c-liter-emissao     ord-prod.dt-emissao
                                 c-liter-inic        ord-prod.dt-inicio
                                 c-liter-term        ord-prod.dt-termino
                                 c-liter-qt-prd      de-qtidade-produzida
                                 c-liter-ult-rep     c-dattran
                                 c-liter-ct          v-cod-conta
                                 c-liter-qt-prd      de-qtidade-produzida
                                 c-liter-est-ord     v-estado
                                 c-liter-estabel     ord-prod.cod-estabel
                                 c-liter-qt-refugada ord-prod.qt-refugada
                                WITH NO-LABELS FRAME f-cabe STREAM-IO.

                        DISP c-movmdo
                            WITH FRAME f-cabmob.

                        DISP c-liter-item
                             c-liter-oper
                             c-liter-mob-dir
                             c-liter-tp-padrao
                             c-liter-tp-real
                             c-liter-vl-padrao
                             c-liter-vl-real
                             c-liter-vr-perc
                            WITH FRAME f-deta3 STREAM-IO.

                        ASSIGN l-primeira = NO
                               l-mostra   = NO.
                    END.

                    DISP tt-mob.it-codigo
                         tt-mob.op-codigo
                         tt-mob.cd-mob-dir
                         tt-mob.tempad
                         tt-mob.temreal
                         de-valpad
                         de-valreal
                         de-variacao
                         de-perc
                        WITH FRAME f-movmob.
                    DOWN WITH FRAME f-movmob.

                    ASSIGN l-imprime  = YES
                           de-tempad  = de-tempad  + tt-mob.tempad
                           de-temreal = de-temreal + tt-mob.temreal
                           de-totpad  = de-totpad  + de-valpad
                           de-totreal = de-totreal + de-valreal.
                END.
            END.
        END.

        ASSIGN l-movmob    = YES
               de-variacao = de-totreal - de-totpad
               de-perc     = IF de-totpad = 0 AND de-variacao = 0 THEN 0 ELSE IF de-totpad = 0 AND de-variacao <> 0 THEN 999.99 ELSE (de-variacao * 100) / de-totpad
               de-perc     = IF de-perc > 999.99 THEN 999.99 ELSE IF de-perc < -999.99 THEN -999.99 ELSE de-perc.

        IF de-totpad < 0          AND
           de-totpad < de-totreal THEN
            ASSIGN de-perc = de-perc * -1.

        IF l-imprime THEN DO:
            DOWN WITH FRAME f-total-mob.

            DISP c-liter-tot-mob
                 de-tempad
                 de-temreal
                 de-totpad
                 de-totreal
                 de-variacao
                 de-perc
                WITH FRAME f-total-mob STREAM-IO.
        END.
        ELSE
            PUT "" SKIP.
    END.    

END PROCEDURE.

PROCEDURE piGeraComponMat:
/*------------------------------------------------------------------------------
  Purpose:     Gera componentes a partir do numero da ordem.Material
  Parameters:  N∆o h†.
  Notes:       CS0501A.P
------------------------------------------------------------------------------*/
    FOR EACH tt-mat:
        DELETE tt-mat.
    END.

    FOR EACH tt-ggf:
        DELETE tt-ggf.
    END.

    FOR EACH tt-mob:
        DELETE tt-mob.
    END.

    ASSIGN de-qtidade-produzida = 0.

    FOR EACH movto-mat USE-INDEX ordem
        WHERE  movto-mat.nr-ord-prod = ord-prod.nr-ord-produ
          AND  movto-mat.it-codigo   = ord-prod.it-codigo
          AND (movto-mat.esp-docto   = 1 OR  movto-mat.esp-docto = 8)
          AND  movto-mat.dt-trans   >= d-dtmov-ini
          AND  movto-mat.dt-trans   <= d-dtmov-fim NO-LOCK:
        
        IF movto-mat.tipo-trans = 1 THEN
            ASSIGN de-qtidade-produzida = de-qtidade-produzida + movto-mat.quantidade.
        ELSE
            ASSIGN de-qtidade-produzida = de-qtidade-produzida - movto-mat.quantidade.
    END.

    DO ON ERROR UNDO, RETURN ERROR:
        ASSIGN c-op-item = ord-prod.it-codigo
               i-fat     = de-qtidade-produzida
               i-nivel   = 1
               c-item    = ord-prod.it-codigo.

        RUN piGeraComponGGF.

        ASSIGN de-quant[1] = de-qtidade-produzida.

        &IF DEFINED (bf_man_sfc_lc) &THEN
        /** So gerar† reservas para lista de componentes para o primeiro n°vel.
        Os itens fantasma n∆o podem possuir lista de componentes associada ***/
        IF ord-prod.cod-lista-compon <> "" THEN DO:
            ASSIGN de-quant[1] = de-qtidade-produzida.

            RUN pi-navega-lista-compon (INPUT ord-prod.cod-refer,
                                        INPUT ord-prod.it-codigo,
                                        INPUT ord-prod.cod-lista-compon).
        END.
        ELSE DO:
            RUN pi-navega-estrutura (INPUT ord-prod.cod-refer,
                                     INPUT ord-prod.it-codigo,
                                     INPUT DATE(01, 01, 0001),
                                     INPUT DATE(12, 31, 9999),
                                     INPUT "").
        END.
        &ELSE
        RUN pi-navega-estrutura (INPUT ord-prod.cod-refer,
                                 INPUT ord-prod.it-codigo,
                                 INPUT DATE(01, 01, 0001),
                                 INPUT DATE(12, 31, 9999),
                                 INPUT "").
        &ENDIF
    END.

END PROCEDURE.

PROCEDURE pi-navega-estrutura:
/*------------------------------------------------------------------------------
  Purpose:     Utilizada para gerar as reservas do primeiro n°vel da ordem e
               tambÇm dos fantasmas (recursivamente).
  Parameters:  c-ref-pai   (Referància do item pai)
               it-codigo   (Item pai)
               da-inicio   (In°cio de validade para seleá∆o de registros de
                            estrutura)
               da-termino  (Fim de validade para seleá∆o de registros de
                            estrutura)
               p-cod-lista (Lista de componentes para determinar a lista v†lida
                            para a reserva).
  Notes:       CS0501A.P
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER c-ref-pai   AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER c-it-codigo AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER da-inicio   AS DATE        NO-UNDO.
    DEFINE INPUT PARAMETER da-termino  AS DATE        NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-lista AS CHARACTER   NO-UNDO.

    DEFINE BUFFER b-item      FOR item.
    DEFINE BUFFER b-item-pai  FOR item.
    DEFINE BUFFER b-estrutura FOR estrutura.

    DEFINE VARIABLE c-ref-filho    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE rw-saldo       AS ROWID       NO-UNDO.
    DEFINE VARIABLE da-inicio-max  AS DATE        NO-UNDO.
    DEFINE VARIABLE da-termino-min AS DATE        NO-UNDO.
    DEFINE VARIABLE c-cod-lista    AS CHARACTER   NO-UNDO.

    DO ON ERROR UNDO, RETURN ERROR:
        
        ASSIGN i-nivel     = i-nivel + 1
               c-cod-lista = p-cod-lista.

        &IF DEFINED (bf_man_sfc_lc) &THEN
        FOR EACH b-estrutura FIELDS(it-codigo    es-codigo   qtd-compon 
                                    quant-usada  qtd-item    cod-lista-compon
                                    proporcao    fantasma    data-inicio
                                    data-termino sequencia   cod-roteiro
                                    op-codigo    tipo-sobra  tempo-reserv)
            USE-INDEX codigo
            WHERE b-estrutura.it-codigo        = c-it-codigo
              AND b-estrutura.cod-lista-compon = "" NO-LOCK:
        &ELSE
        FOR EACH b-estrutura FIELDS(it-codigo    es-codigo   quant-usada
                                    proporcao    fantasma    data-inicio
                                    data-termino sequencia   cod-roteiro
                                    op-codigo    tipo-sobra  tempo-reserv)
            USE-INDEX codigo
            WHERE b-estrutura.it-codigo = c-it-codigo  NO-LOCK:
        &ENDIF.
        
            /*** Pula registros de estrutura fora da validade ***/
            IF b-estrutura.data-termino <= da-inicio  OR
               b-estrutura.data-inicio  >  da-termino THEN NEXT.

            IF b-estrutura.data-inicio  >  da-corte-es OR
               b-estrutura.data-termino <= da-corte-es THEN NEXT.

            ASSIGN da-inicio-max  = MAXIMUM(b-estrutura.data-inicio, da-inicio)
                   da-termino-min = MINIMUM(b-estrutura.data-termino, da-termino).

            FOR FIRST b-item FIELDS(it-codigo   fraciona     tipo-con-est
                                    tipo-contr  tipo-requis  cod-obsoleto
                                    un          cod-localiz  deposito-pad)
                WHERE b-item.it-codigo = b-estrutura.es-codigo NO-LOCK:
            END.

            FOR FIRST b-item-pai FIELDS(it-codigo   fraciona     tipo-con-est
                                        tipo-contr  tipo-requis  cod-obsoleto
                                        un          cod-localiz  deposito-pad)
                WHERE b-item-pai.it-codigo = b-estrutura.it-codigo NO-LOCK:
            END.

            IF b-item.tipo-con-est     = 4 OR
               b-item-pai.tipo-con-est = 4 THEN DO:
                RUN cdp/cd9060.p (INPUT  b-estrutura.it-codigo,
                                  INPUT  b-estrutura.sequencia,
                                  INPUT  b-estrutura.es-codigo,
                                  INPUT  c-ref-pai,
                                  OUTPUT l-util-item,
                                  OUTPUT c-ref-filho).
            END.
            ELSE
                ASSIGN l-util-item = YES
                       c-ref-filho = "".

            IF l-util-item THEN DO:
                &IF DEFINED (bf_man_sfc_lc) &THEN
                ASSIGN de-quant[i-nivel]    = de-quant[i-nivel - 1] * b-estrutura.qtd-compon / b-estrutura.qtd-item * b-estrutura.proporcao / 100.
                &ELSE
                ASSIGN de-quant[i-nivel]    = de-quant[i-nivel - 1] * b-estrutura.quant-usada * b-estrutura.proporcao / 100.
                &ENDIF
                
                IF NOT b-item.fraciona                         AND
                   INT(de-quant[i-nivel]) <> de-quant[i-nivel] THEN
                    IF de-quant[i-nivel] > 0 THEN
                        ASSIGN de-quant[i-nivel] = TRUNCATE(de-quant[i-nivel],0) + 1.
                    ELSE
                        ASSIGN de-quant[i-nivel] = TRUNCATE(de-quant[i-nivel],0) - 1.             

                IF b-estrutura.fantasma THEN DO:
                    IF CAN-FIND(FIRST estrutura
                                WHERE estrutura.it-codigo = b-item.it-codigo NO-LOCK) THEN DO:
                        ASSIGN i-fat = de-quant[i-nivel].

                        IF  ord-prod.tipo            <> 2                                       AND
                            b-estrutura.quant-usada   > 0                                       AND
                           (CAN-FIND(FIRST operacao
                                     WHERE operacao.it-codigo = b-estrutura.es-codigo NO-LOCK)  OR
                            CAN-FIND(FIRST rot-item
                                     WHERE rot-item.it-codigo = b-estrutura.es-codigo NO-LOCK)) THEN DO:

                            IF CAN-FIND(FIRST rot-item
                                        WHERE rot-item.it-codigo = b-estrutura.es-codigo NO-LOCK) THEN
                                ASSIGN l-rot-fan = YES.
                            ELSE
                                ASSIGN l-rot-fan = NO.

                            ASSIGN c-op-item  = b-estrutura.es-codigo
                                   i-fat      = de-quant[i-nivel]
                                   l-rot-item = NO.

                            RUN piGeraComponGGF.

                            ASSIGN c-item = b-estrutura.es-codigo.
                        END.

                        RUN pi-navega-estrutura (INPUT c-ref-filho,
                                                 INPUT b-item.it-codigo,
                                                 INPUT da-inicio-max,
                                                 INPUT da-termino-min,
                                                 INPUT p-cod-lista).
                    END.
                    ELSE
                        IF b-item.it-codigo    <> "" AND
                           b-item.tipo-contr   <> 4    AND
                           b-item.tipo-requis  <> 3    AND
                           b-item.cod-obsoleto <> 4    THEN DO:

                            FIND FIRST reservas
                                WHERE reservas.nr-ord-produ = ord-prod.nr-ord-produ
                                  AND reservas.it-codigo    = b-estrutura.es-codigo NO-LOCK NO-ERROR.

                            IF AVAILABLE reservas THEN
                                ASSIGN de-quant-reserva = reservas.quant-requis.

                            FIND FIRST tt-mat
                                WHERE tt-mat.it-codigo = b-estrutura.es-codigo
                                  AND tt-mat.cod-refer = c-ref-filho NO-ERROR.

                            IF NOT AVAILABLE tt-mat THEN DO:
                                CREATE tt-mat.
                                ASSIGN tt-mat.it-codigo = b-estrutura.es-codigo
                                       tt-mat.cod-refer = c-ref-filho
                                       tt-mat.quant-pad = de-quant[i-nivel].                             
                            END.
                            ELSE
                                ASSIGN tt-mat.quant-pad = tt-mat.quant-pad + de-quant[i-nivel].
                        END.
                END.
                ELSE
                    IF b-item.it-codigo    <> "" AND
                       b-item.tipo-contr   <> 4    AND
                       b-item.tipo-requis  <> 3    AND
                       b-item.cod-obsoleto <> 4    THEN DO:
                        FIND FIRST reservas
                            WHERE reservas.nr-ord-produ = ord-prod.nr-ord-produ
                              AND reservas.it-codigo    = b-estrutura.es-codigo NO-LOCK NO-ERROR.

                        IF AVAILABLE reservas THEN
                            ASSIGN de-quant-reserva = reservas.quant-requis.

                        FIND FIRST tt-mat
                            WHERE tt-mat.it-codigo = b-estrutura.es-codigo
                              AND tt-mat.cod-refer = c-ref-filho NO-ERROR.

                        IF NOT AVAILABLE tt-mat THEN DO:
                            CREATE tt-mat.
                            ASSIGN tt-mat.it-codigo = b-estrutura.es-codigo
                                   tt-mat.cod-refer = c-ref-filho
                                   tt-mat.quant-pad = de-quant[i-nivel].
                        END.
                        ELSE
                            ASSIGN tt-mat.quant-pad = tt-mat.quant-pad + de-quant[i-nivel].
                    END.
            END.
        END.

        ASSIGN i-nivel = i-nivel - 1. 

    END.

END PROCEDURE.

&IF DEFINED (bf_man_sfc_lc) &THEN
PROCEDURE pi-navega-lista-compon:
/*------------------------------------------------------------------------------
  Purpose:     Utilizada para gerar as reservas a partir da lista de componentes
               associada a ordem para o primeiro n°vel da ordem e tambÇm dos
               fantasmas (VIA PI-NAVEGA-ESTRUTURA), criando tambÇm as operaá‰es
               correspondentes.
  Parameters:  c-ref-pai   (Referància do item pai)
               it-codigo   (Item pai).
  Notes:       CS0501A.P
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER c-ref-pai   AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER c-it-codigo AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER c-cod-lista AS CHARACTER   NO-UNDO.

    DEFINE BUFFER b-item-lista-compon FOR item-lista-compon.
    DEFINE BUFFER b-item              FOR item.

    DEFINE VARIABLE c-ref-filho    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE de-fator-lista AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE da-inicio      AS DATE        NO-UNDO.
    DEFINE VARIABLE da-termino     AS DATE        NO-UNDO.
    DEFINE VARIABLE da-inicio-max  AS DATE        NO-UNDO.
    DEFINE VARIABLE da-termino-min AS DATE        NO-UNDO.
    DEFINE VARIABLE rw-saldo       AS ROWID       NO-UNDO.

    ASSIGN i-nivel    = 2                   /*** N°vel do componente corresponde ao segundo n°vel ***/
           da-inicio  = DATE(01, 01, 0001)  /*** verificar planejamento para poder usar: min(today, ord-prod.dt-inicio) ***/
           da-termino = DATE(12, 31, 9999).

    FIND FIRST lista-compon-item
        WHERE lista-compon-item.it-codigo        = ord-prod.it-codigo
          AND lista-compon-item.cod-lista-compon = c-cod-lista NO-LOCK NO-ERROR.

    IF NOT AVAILABLE lista-compon-item THEN
        RETURN.

    /*** Identifica qual a quantidade da lista entra na composiªío do item. ***/
    ASSIGN de-fator-lista  = lista-compon-item.qtd-lista / lista-compon-item.qtd-item
           da-inicio-max   = MAXIMUM(lista-compon-item.data-inicio, da-inicio)
           da-termino-min  = lista-compon-item.data-termino
           c-cod-lista     = lista-compon-item.cod-lista-compon.

    FOR EACH b-item-lista-compon
        WHERE b-item-lista-compon.cod-lista-compon  =  ord-prod.cod-lista-compon
          AND b-item-lista-compon.log-compon-altern =  NO
          AND b-item-lista-compon.data-termino      >  da-inicio-max
          AND b-item-lista-compon.data-inicio       <= da-termino-min NO-LOCK:

        IF b-item-lista-compon.data-inicio  >  da-corte-es OR
           b-item-lista-compon.data-termino <= da-corte-es THEN NEXT.

        ASSIGN da-inicio-max  = MAXIMUM(da-inicio-max,b-item-lista-compon.data-inicio)
               da-termino-min = MINIMUM(da-termino-min,b-item-lista-compon.data-termino)
               de-quant[2]    = de-quant[1]. /*ord-prod.qt-ordem.*/

        FOR FIRST b-item FIELDS(it-codigo   fraciona     tipo-con-est
                                tipo-contr  tipo-requis  cod-obsoleto
                                un          cod-localiz  deposito-pad)
            WHERE b-item.it-codigo = b-item-lista-compon.es-codigo NO-LOCK:
        END.

        /** Nesta vers∆o se assume que a lista de componentes vale para todas as referàncias do pai ***/
        IF b-item.tipo-con-est = 4 THEN DO:
            IF b-item-lista-compon.cod-ref-es = "" THEN DO:
                IF CAN-FIND(FIRST ref-item
                            WHERE ref-item.it-codigo = b-item-lista-compon.es-codigo
                              AND ref-item.cod-refer = ord-prod.cod-refer) THEN
                    ASSIGN l-util-item = YES
                           c-ref-filho = ord-prod.cod-refer.
                ELSE
                    ASSIGN l-util-item = NO
                           c-ref-filho = "".
            END.
            ELSE
                ASSIGN l-util-item = YES
                       c-ref-filho = b-item-lista-compon.cod-ref-es.
        END.
        ELSE
            ASSIGN l-util-item = YES
                   c-ref-filho = "".

        IF l-util-item THEN DO:
            ASSIGN de-quant[2] = de-quant[2] * (b-item-lista-compon.qtd-compon / b-item-lista-compon.qtd-lista) * de-fator-lista * (b-item-lista-compon.proporcao / 100).

            IF b-item.fraciona   = NO          AND
               INT(de-quant[2]) <> de-quant[2] THEN
                ASSIGN de-quant[2] = TRUNCATE(de-quant[2],0) + 1.

            IF b-item.it-codigo    <> "" AND
               b-item.tipo-contr   <> 4    AND
               b-item.tipo-requis  <> 3    AND
               b-item.cod-obsoleto <> 4    THEN DO:
                
                IF b-item-lista-compon.fantasma THEN DO:
                    RUN pi-navega-estrutura (INPUT c-ref-filho,
                                             INPUT b-item.it-codigo,
                                             INPUT da-inicio-max,
                                             INPUT da-termino-min,
                                             INPUT c-cod-lista).                   
                END.
                ELSE DO:
                    FIND FIRST tt-mat
                        WHERE tt-mat.it-codigo = b-item-lista-compon.es-codigo NO-ERROR.

                    IF NOT AVAILABLE tt-mat THEN DO:
                        CREATE tt-mat.
                        ASSIGN tt-mat.it-codigo = b-item-lista-compon.es-codigo
                               tt-mat.cod-refer = c-ref-filho
                               tt-mat.quant-pad = de-quant[i-nivel].
                    END.
                    ELSE
                        ASSIGN tt-mat.quant-pad = tt-mat.quant-pad + de-quant[i-nivel].
                END.
            END.
        END.
    END.

END PROCEDURE.
&ENDIF.

PROCEDURE piGeraComponGGF:
/*------------------------------------------------------------------------------
  Purpose:     Gera componentes a partir do numero da ordem. GGF
  Parameters:  N∆o h†.
  Notes:       cs0501b.p
------------------------------------------------------------------------------*/
    FIND FIRST item
        WHERE item.it-codigo = ord-prod.it-codigo NO-LOCK NO-ERROR.

    IF l-rot-item OR l-rot-fan THEN DO:
        IF (CAN-FIND(FIRST proces-item
                     WHERE proces-item.it-codigo = ord-prod.it-codigo)) AND l-rot-item = YES THEN DO:

            RUN GerarListaProcesItem (INPUT ord-prod.it-codigo,
                                      INPUT ord-prod.qt-ordem,
                                      INPUT ord-prod.cod-estabel,
                                      INPUT ord-prod.cod-refer,
                                      INPUT ord-prod.dt-inicio,
                                      INPUT ord-prod.nr-linha,
                                      INPUT YES, /* N∆o gera lista de processos */
                                      &IF DEFINED(bf_man_206b) &THEN
                                      INPUT ord-prod.cod-unid-negoc,
                                      &ENDIF
                                      INPUT-OUTPUT TABLE tt-proces-item).

            FIND FIRST tt-proces-item NO-LOCK NO-ERROR.

            IF AVAILABLE tt-proces-item THEN DO:
                FOR EACH tt-proces-item
                    WHERE tt-proces-item.it-codigo        = ord-prod.it-codigo
                      AND tt-proces-item.cod-roteiro      = ord-prod.cod-roteiro
                      AND tt-proces-item.cod-lista-compon = ord-prod.cod-lista-compon NO-LOCK:
                    
                    FIND FIRST rot-fabric
                        WHERE rot-fabric.cod-roteiro = tt-proces-item.cod-roteiro NO-LOCK NO-ERROR.

                    IF rot-fabric.situacao <> 2 THEN
                        FOR EACH operacao
                            WHERE  operacao.it-codigo   = " "
                              AND  operacao.cod-roteiro = tt-proces-item.cod-roteiro
                              AND ((da-corte-op  = ? AND ord-prod.dt-inicio >= operacao.data-inicio AND ord-prod.dt-inicio < operacao.data-termino)
                               OR  (da-corte-op <> ? AND da-corte-op        >= operacao.data-inicio AND da-corte-op        < operacao.data-termino)) NO-LOCK:
                            
                            IF operacao.tipo-oper = 1 THEN DO:
                                IF operacao.nr-unidades > 0 THEN DO:
                                    RUN csp/csapi501.p (INPUT  i-tempo,               /* Unid. med. tempo a retornar (hora, min, seg, dias) */
                                                        INPUT  operacao.un-med-tempo, /* Unid. med. tempo utiliz. operaá∆o.un-med-tempo     */
                                                        INPUT  operacao.tempo-homem,  /* Tempo (homem/maquina/preparacao) utiliz. c†lculo   */
                                                        OUTPUT de-tempad).           /* Qtde retornado ap¢s c†lculo                        */

                                    ASSIGN de-tempad = (de-tempad * i-fat) / operacao.nr-unidades * operacao.proporcao / 100.
                                END.

                                IF operacao.cd-mob-dir <> "" THEN DO:
                                    FIND FIRST tab-mob-dir
                                        WHERE tab-mob-dir.cd-mob-dir = operacao.cd-mob-dir NO-LOCK NO-ERROR.

                                    IF AVAILABLE tab-mob-dir THEN DO:
                                        ASSIGN c-cd-mob-dir = tab-mob-dir.cd-mob-dir.
                                        
                                        IF i-tipo-custo = 1 THEN /* Total */
                                            ASSIGN de-valor-mob = tab-mob-dir.vl-corrente[i-moeda + 1].
                                        ELSE
                                            IF i-tipo-custo = 2 THEN /* Previsto */
                                                ASSIGN de-valor-mob = tab-mob-dir.vl-orcado[i-moeda + 1].
                                            ELSE
                                                IF i-tipo-custo = 3 THEN /* Padr∆o */
                                                    ASSIGN de-valor-mob = tab-mob-dir.vl-padrao[i-moeda + 1].
                                    END.
                                    ELSE
                                        ASSIGN de-valor-mob = 0.

                                    
                                    FIND FIRST tt-mob
                                        WHERE tt-mob.op-codigo = operacao.op-codigo
                                          AND tt-mob.it-codigo = operacao.it-codigo NO-ERROR.

                                    IF NOT AVAILABLE tt-mob THEN DO:
                                        CREATE tt-mob.
                                        ASSIGN tt-mob.it-codigo  = operacao.it-codigo
                                               tt-mob.op-codigo  = operacao.op-codigo
                                               tt-mob.cd-mob-dir = c-cd-mob-dir
                                               tt-mob.tempad     = de-tempad.
                                    END.                                    
                                END.

                                FIND FIRST grup-maquina
                                    WHERE grup-maquina.gm-codigo = operacao.gm-codigo NO-LOCK NO-ERROR.

                                FIND FIRST gm-estab
                                    WHERE gm-estab.gm-codigo   = grup-maquina.gm-codigo
                                      AND gm-estab.cod-estabel = c-estab NO-LOCK NO-ERROR.

                                IF AVAILABLE gm-estab THEN
                                    FIND FIRST centro-custo
                                        WHERE centro-custo.cc-codigo = gm-estab.cc-codigo NO-LOCK NO-ERROR.

                                IF AVAILABLE centro-custo     AND
                                   centro-custo.tempo-ggf = 1 THEN DO:
                                    RUN csp/csapi501.p (INPUT  i-tempo,               /*unid.med.tempo a retornar(hora,min,seg,dias)*/
                                                        INPUT  operacao.un-med-tempo, /*unid.med.tempo utiliz.operaªío.un-med-tempo*/
                                                        INPUT  operacao.tempo-homem,  /*tempo(homem/maquina/preparacao)utiliz.calculo*/
                                                        OUTPUT de-tempo).            /*qtde retornado apos calculo */

                                    ASSIGN de-tempo = (de-tempo * i-fat) / operacao.nr-unidades * operacao.proporcao / 100.
                                END.
                                ELSE DO:
                                    RUN csp/csapi501.p (INPUT  i-tempo,               /*unid.med.tempo a retornar(hora,min,seg,dias)*/
                                                        INPUT  operacao.un-med-tempo, /*unid.med.tempo utiliz.operaªío.un-med-tempo*/
                                                        INPUT  operacao.tempo-maquin,  /*tempo(homem/maquina/preparacao)utiliz.calculo*/
                                                        OUTPUT de-tempo).            /*qtde retornado apos calculo */

                                    ASSIGN de-tempo = ( de-tempo * i-fat) / operacao.nr-unidades * operacao.proporcao / 100.
                                END.
                                
                                IF de-tempo-pre = ? THEN
                                    ASSIGN de-tempo-pre = 0.

                                IF AVAILABLE centro-custo THEN DO:
                                    FIND FIRST tt-ggf
                                        WHERE tt-ggf.cc-codigo = centro-custo.cc-codigo
                                          AND tt-ggf.gm-codigo = grup-maquina.gm-codigo NO-ERROR.

                                    IF NOT AVAILABLE tt-ggf THEN DO:
                                        CREATE tt-ggf.
                                        ASSIGN tt-ggf.cc-codigo = centro-custo.cc-codigo
                                               tt-ggf.gm-codigo = grup-maquina.gm-codigo.
                                    END.
                                END.

                                IF AVAILABLE tt-ggf THEN
                                    ASSIGN tt-ggf.tempo-pad = tt-ggf.tempo-pad + de-tempo
                                           tt-ggf.tempo-pre = tt-ggf.tempo-pre + de-tempo-pre.
                            END.
                            ELSE DO:                                
                                FIND FIRST tt-mat
                                    WHERE tt-mat.it-codigo = c-liter-op-externa NO-ERROR.

                                IF NOT AVAILABLE tt-mat THEN DO:
                                    CREATE tt-mat.
                                    ASSIGN tt-mat.it-codigo = c-liter-op-externa
                                           tt-mat.quant-pad = i-fat.
                                END.

                                IF i-tipo-preco <= 3 THEN
                                    ASSIGN tt-mat.dt-movto               = TODAY
                                           tt-mat.vl-mobext[i-moeda + 1] = tt-mat.vl-mobext[i-moeda + 1] + operacao.preco-medio[i-moeda + 1].
                                ELSE DO:
                                    IF i-tipo-preco = 6 THEN
                                        ASSIGN tt-mat.dt-movto               = operacao.data-ult-ent
                                               tt-mat.vl-mobext[i-moeda + 1] = tt-mat.vl-mobext[i-moeda + 1] + operacao.preco-ul-ent.
                                    ELSE
                                        IF i-tipo-preco = 5 THEN
                                            ASSIGN tt-mat.dt-movto               = operacao.data-ult-rep
                                                   tt-mat.vl-mobext[i-moeda + 1] = tt-mat.vl-mobext[i-moeda + 1] + operacao.preco-repos.
                                        ELSE
                                            ASSIGN tt-mat.dt-movto               = TODAY
                                                   tt-mat.vl-mobext[i-moeda + 1] = tt-mat.vl-mobext[i-moeda + 1] + operacao.preco-base.
                                END.
                            END.
                        END.
                END.
            END.
        END.
        ELSE DO:
            FOR EACH rot-item
                WHERE rot-item.it-codigo = c-op-item NO-LOCK:

                IF rot-item.data-inicio > da-corte-op  AND
                   rot-item.data-termino < da-corte-op THEN NEXT. /*Validacao para desconsiderar operacoes de roteiros invalidos*/

                FIND FIRST rot-fabric
                    WHERE rot-fabric.cod-roteiro = rot-item.cod-roteiro NO-LOCK NO-ERROR.

                IF rot-fabric.situacao <> 2 THEN
                    FOR EACH operacao
                        WHERE  operacao.it-codigo = " "
                          AND  operacao.cod-roteiro = rot-item.cod-roteiro
                          AND ((da-corte-op  = ? AND ord-prod.dt-inicio >= operacao.data-inicio AND ord-prod.dt-inicio < operacao.data-termino)
                           OR  (da-corte-op <> ? AND da-corte-op        >= operacao.data-inicio AND da-corte-op        < operacao.data-termino)) NO-LOCK:
                    
                        IF operacao.tipo-oper = 1 THEN DO:

                            IF operacao.nr-unidades > 0 THEN DO:
                                RUN csp/csapi501.p (INPUT  i-tempo,               /* Unid. med. tempo a retornar (hora, min, seg, dias) */
                                                    INPUT  operacao.un-med-tempo, /* Unid. med. tempo utiliz. operacao.un-med-tempo     */
                                                    INPUT  operacao.tempo-homem,  /* Tempo (homem/m†quina/preparaá∆o) utiliz. c†lculo   */
                                                    OUTPUT de-tempad ).           /* Qtde retornado ap¢s c†lculo                        */

                                ASSIGN de-tempad = ((de-tempad * i-fat) / operacao.nr-unidades * operacao.proporcao / 100).
                            END.

                            IF operacao.cd-mob-dir <> "" THEN DO:
                                FIND FIRST tab-mob-dir
                                    WHERE tab-mob-dir.cd-mob-dir =  operacao.cd-mob-dir NO-LOCK NO-ERROR.

                                IF AVAILABLE tab-mob-dir THEN DO:
                                    ASSIGN c-cd-mob-dir = tab-mob-dir.cd-mob-dir.

                                    IF i-tipo-custo = 1 THEN /* Total */
                                        ASSIGN de-valor-mob = tab-mob-dir.vl-corrente[i-moeda + 1].
                                    ELSE
                                        IF i-tipo-custo = 2 THEN /* Previsto */
                                            ASSIGN de-valor-mob = tab-mob-dir.vl-orcado[i-moeda + 1].
                                        ELSE
                                            IF i-tipo-custo = 3 THEN /* Padr∆o */
                                                ASSIGN de-valor-mob = tab-mob-dir.vl-padrao[i-moeda + 1].
                                END.
                                ELSE
                                    ASSIGN de-valor-mob = 0.

                                FIND FIRST tt-mob
                                    WHERE tt-mob.op-codigo = operacao.op-codigo
                                      AND tt-mob.it-codigo = operacao.it-codigo NO-ERROR.

                                IF NOT AVAILABLE tt-mob THEN DO:
                                    CREATE tt-mob.
                                    ASSIGN tt-mob.it-codigo  = operacao.it-codigo
                                           tt-mob.op-codigo  = operacao.op-codigo
                                           tt-mob.cd-mob-dir = c-cd-mob-dir
                                           tt-mob.tempad     = de-tempad.
                                END.                                
                            END.

                            FIND FIRST grup-maquina
                                WHERE grup-maquina.gm-codigo = operacao.gm-codigo NO-LOCK NO-ERROR.

                            FIND FIRST gm-estab
                                WHERE gm-estab.gm-codigo   = grup-maquina.gm-codigo
                                  AND gm-estab.cod-estabel = c-estab NO-LOCK NO-ERROR.
                                
                            IF AVAILABLE gm-estab THEN
                                FIND FIRST centro-custo
                                    WHERE centro-custo.cc-codigo = gm-estab.cc-codigo NO-LOCK NO-ERROR.

                            IF AVAILABLE centro-custo AND
                               centro-custo.tempo-ggf = 1 THEN DO:
                                RUN csp/csapi501.p (INPUT  i-tempo,               /* Unid. med. tempo a retornar (hora, min, seg, dias) */
                                                    INPUT  operacao.un-med-tempo, /* Unid. med. tempo utiliz. operacao.un-med-tempo     */
                                                    INPUT  operacao.tempo-homem,  /* Tempo(homem/m†quina/preparaá∆o) utiliz. c†lculo    */
                                                    OUTPUT de-tempo).             /* Qtde retornado ap¢s c†lculo                        */

                                ASSIGN de-tempo = (de-tempo * i-fat) / operacao.nr-unidades * operacao.proporcao / 100.
                            END.
                            ELSE DO:
                                RUN csp/csapi501.p (INPUT  i-tempo,               /* Unid. med. tempo a retornar (hora, min, seg, dias) */
                                                    INPUT  operacao.un-med-tempo, /* Unid. med. tempo utiliz. operacao.un-med-tempo     */
                                                    INPUT  operacao.tempo-maquin, /* Tempo (homem/m†quina/preparaá∆o) utiliz. c†lculo   */ 
                                                    OUTPUT de-tempo).             /* Qtde retornado ap¢s c†lculo                        */
                                
                                ASSIGN de-tempo = (de-tempo * i-fat) / operacao.nr-unidades * operacao.proporcao / 100.
                            END.

                            IF de-tempo-pre = ? THEN
                                ASSIGN de-tempo-pre = 0.
                            
                            IF AVAILABLE centro-custo THEN DO:
                                FIND FIRST tt-ggf
                                    WHERE tt-ggf.cc-codigo = centro-custo.cc-codigo
                                      AND tt-ggf.gm-codigo = grup-maquina.gm-codigo NO-ERROR.

                                IF NOT AVAILABLE tt-ggf THEN DO:
                                    CREATE tt-ggf.
                                    ASSIGN tt-ggf.cc-codigo = centro-custo.cc-codigo
                                           tt-ggf.gm-codigo = grup-maquina.gm-codigo.
                                END.
                            END.

                            IF AVAILABLE tt-ggf THEN
                                ASSIGN tt-ggf.tempo-pad = tt-ggf.tempo-pad + de-tempo
                                       tt-ggf.tempo-pre = tt-ggf.tempo-pre + de-tempo-pre.
                        END.
                        ELSE DO:
                            FIND FIRST tt-mat
                                WHERE tt-mat.it-codigo =  c-liter-op-externa NO-ERROR.

                            IF NOT AVAILABLE tt-mat THEN DO:
                                CREATE tt-mat.
                                ASSIGN tt-mat.it-codigo = c-liter-op-externa
                                       tt-mat.quant-pad = i-fat.
                            END.

                            IF i-tipo-preco <= 3 THEN
                                ASSIGN tt-mat.dt-movto               = TODAY
                                       tt-mat.vl-mobext[i-moeda + 1] = tt-mat.vl-mobext[i-moeda + 1] + operacao.preco-medio[i-moeda + 1].
                            ELSE DO:
                                IF i-tipo-preco = 6 THEN
                                    ASSIGN tt-mat.dt-movto = operacao.data-ult-ent
                                           tt-mat.vl-mobext[i-moeda + 1] = tt-mat.vl-mobext[i-moeda + 1] + operacao.preco-ul-ent.
                                ELSE
                                    IF i-tipo-preco = 5 THEN
                                        ASSIGN tt-mat.dt-movto = operacao.data-ult-rep
                                               tt-mat.vl-mobext[i-moeda + 1] = tt-mat.vl-mobext[i-moeda + 1] + operacao.preco-repos.
                                    ELSE
                                        ASSIGN tt-mat.dt-movto = TODAY
                                               tt-mat.vl-mobext[i-moeda + 1] = tt-mat.vl-mobext[i-moeda + 1] + operacao.preco-base.
                            END.
                        END.
                    END.
            END.
        END.
    END.
    ELSE DO:
        FOR EACH operacao
            WHERE  operacao.cod-roteiro = " "
              AND  operacao.it-codigo   = c-op-item
              AND ((da-corte-op  = ? AND ord-prod.dt-inicio >= operacao.data-inicio AND ord-prod.dt-inicio < operacao.data-termino)
               OR  (da-corte-op <> ? AND da-corte-op        >= operacao.data-inicio AND da-corte-op        <  operacao.data-termino)) NO-LOCK:
            
            IF operacao.tipo-oper = 1 THEN DO:
                IF operacao.nr-unidades > 0 THEN DO:
                    RUN csp/csapi501.p (INPUT  i-tempo,               /* Unid. med. tempo a retornar (hora, min, seg, dias) */
                                        INPUT  operacao.un-med-tempo, /* Unid. med. tempo utiliz. operacao.un-med-tempo     */
                                        INPUT  operacao.tempo-homem,  /* Tempo (homem/m†quina/preparaá∆o) utiliz. c†lculo   */
                                        OUTPUT de-tempad).            /* Qtde retornado ap¢s c†lculo                        */
                    
                    ASSIGN de-tempad = ((de-tempad * i-fat) / operacao.nr-unidades * operacao.proporcao / 100).
                END.

                IF operacao.cd-mob-dir <> "" THEN DO:
                    FIND FIRST tab-mob-dir
                        WHERE tab-mob-dir.cd-mob-dir =  operacao.cd-mob-dir NO-LOCK NO-ERROR.

                    IF AVAILABLE tab-mob-dir THEN DO:
                        ASSIGN c-cd-mob-dir = tab-mob-dir.cd-mob-dir.

                        IF i-tipo-custo = 1 THEN /* Total */
                            ASSIGN de-valor-mob = tab-mob-dir.vl-corrente[i-moeda + 1].
                        ELSE
                            IF i-tipo-custo = 2 THEN /* Previsto */
                                ASSIGN de-valor-mob = tab-mob-dir.vl-orcado[i-moeda + 1].
                            ELSE
                                IF i-tipo-custo = 3 THEN /* Padr∆o */
                                    ASSIGN de-valor-mob = tab-mob-dir.vl-padrao[i-moeda + 1].
                    END.
                    ELSE
                        ASSIGN de-valor-mob = 0.

                    FIND FIRST tt-mob
                        WHERE tt-mob.op-codigo = operacao.op-codigo
                          AND tt-mob.it-codigo = operacao.it-codigo NO-ERROR.

                    IF NOT AVAILABLE tt-mob THEN DO:
                        CREATE tt-mob.
                        ASSIGN tt-mob.it-codigo  = operacao.it-codigo
                               tt-mob.op-codigo  = operacao.op-codigo
                               tt-mob.cd-mob-dir = c-cd-mob-dir
                               tt-mob.tempad     = de-tempad.
                    END.
                END.

                FIND FIRST grup-maquina
                    WHERE grup-maquina.gm-codigo = operacao.gm-codigo NO-LOCK NO-ERROR.

                FIND FIRST gm-estab
                    WHERE gm-estab.gm-codigo   = grup-maquina.gm-codigo
                      AND gm-estab.cod-estabel = c-estab NO-LOCK NO-ERROR.

                IF AVAILABLE gm-estab THEN
                    FIND FIRST centro-custo
                        WHERE centro-custo.cc-codigo = gm-estab.cc-codigo NO-LOCK NO-ERROR.

                IF AVAILABLE centro-custo AND
                   centro-custo.tempo-ggf = 1 THEN DO:
                    RUN csp/csapi501.p (INPUT  i-tempo,               /* Unid. med. tempo a retornar (hora, min, seg, dias) */
                                        INPUT  operacao.un-med-tempo, /* Unid. med. tempo utiliz. operacao.un-med-tempo     */
                                        INPUT  operacao.tempo-homem,  /* Tempo (homem/m†quina/preparaá∆o) utiliz. c†lculo   */ 
                                        OUTPUT de-tempo).             /* Qtde retornado ap¢s c†lculo                        */

                    ASSIGN de-tempo = (de-tempo * i-fat) / operacao.nr-unidades * operacao.proporcao / 100.
                END.
                ELSE DO:
                    RUN csp/csapi501.p (INPUT  i-tempo,               /* Unid. med. tempo a retornar (hora, min, seg, dias) */
                                        INPUT  operacao.un-med-tempo, /* Unid. med. tempo utiliz. operacao.un-med-tempo     */
                                        INPUT  operacao.tempo-maquin, /* Tempo (homem/m†quina/preparaá∆o) utiliz. calculo   */
                                        OUTPUT de-tempo).             /* Qtde retornado ap¢s c†lculo                        */

                    ASSIGN de-tempo = (de-tempo * i-fat) / operacao.nr-unidades * operacao.proporcao / 100.
                END.

                IF de-tempo-pre = ? THEN
                    ASSIGN de-tempo-pre = 0.

                IF AVAILABLE centro-custo THEN DO:
                    FIND FIRST tt-ggf
                        WHERE tt-ggf.cc-codigo = centro-custo.cc-codigo
                          AND tt-ggf.gm-codigo = grup-maquina.gm-codigo NO-ERROR.

                    IF NOT AVAILABLE tt-ggf THEN DO:
                        CREATE tt-ggf.
                        ASSIGN tt-ggf.cc-codigo = centro-custo.cc-codigo
                               tt-ggf.gm-codigo = grup-maquina.gm-codigo.
                    END.
                END.
                
                IF AVAILABLE tt-ggf THEN
                    ASSIGN tt-ggf.tempo-pad = tt-ggf.tempo-pad + de-tempo
                           tt-ggf.tempo-pre = tt-ggf.tempo-pre + de-tempo-pre.
            END.
            ELSE DO:
                FIND FIRST tt-mat
                    WHERE tt-mat.it-codigo = c-liter-op-externa NO-ERROR.

                IF NOT AVAILABLE tt-mat THEN DO:
                    CREATE tt-mat.
                    ASSIGN tt-mat.it-codigo = c-liter-op-externa
                           tt-mat.quant-pad = i-fat.
                END.

                IF i-tipo-preco <= 3 THEN
                    ASSIGN tt-mat.dt-movto = TODAY
                           tt-mat.vl-mobext[i-moeda + 1] = tt-mat.vl-mobext[i-moeda + 1] + operacao.preco-medio[i-moeda + 1].
                ELSE DO:
                    IF i-tipo-preco = 6 THEN
                        ASSIGN tt-mat.dt-movto               = operacao.data-ult-ent
                               tt-mat.vl-mobext[i-moeda + 1] = tt-mat.vl-mobext[i-moeda + 1] + operacao.preco-ul-ent.
                    ELSE
                        IF i-tipo-preco = 5 THEN
                            ASSIGN tt-mat.dt-movto               = operacao.data-ult-rep
                                   tt-mat.vl-mobext[i-moeda + 1] = tt-mat.vl-mobext[i-moeda + 1] + operacao.preco-repos.
                        ELSE
                            ASSIGN tt-mat.dt-movto               = TODAY
                                   tt-mat.vl-mobext[i-moeda + 1] = tt-mat.vl-mobext[i-moeda + 1] + operacao.preco-base.
                END.
            END.
        END.
    END.

END PROCEDURE.

PROCEDURE GerarListaProcesItem:
/*------------------------------------------------------------------------------
  Purpose:     Gerar lista de processos ou encontrar 1 (um) processo para ser
               usado na fabricaá∆o do item.
  Parameters:  p-it-codigo
               p-qt-ordem
               p-cod-estabel
               p-cod-refer
               p-dt-inicio
               p-nr-linha
               p-log-gera-lista (Gera lista ou encontra primeiro processo)
               tt-proces-item
  Notes:       A procedure n∆o validar† a regra que tenha como input ?
               Estabelecimento, linha de produá∆o e quantidade.
               
               cpp/cpapi301.i7
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-it-codigo      LIKE ord-prod.it-codigo   NO-UNDO.
    DEFINE INPUT PARAMETER p-qt-ordem       LIKE ord-prod.qt-ordem    NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel    LIKE ord-prod.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-refer      LIKE ord-prod.cod-refer   NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-inicio      LIKE ord-prod.dt-inicio   NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-linha       LIKE ord-prod.nr-linha    NO-UNDO.
    DEFINE INPUT PARAMETER p-log-gera-lista AS LOGICAL                NO-UNDO.
    &IF DEFINED(bf_man_206b) &THEN
    DEFINE INPUT PARAMETER p-unid-negoc     AS CHARACTER              NO-UNDO.
    &ENDIF
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-proces-item.

    DEFINE VARIABLE v-soma-perc  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v-num-proces AS INTEGER     NO-UNDO.
    
    /** Eliminaá∆o da tt **/
    FOR EACH tt-proces-item:
        DELETE tt-proces-item.
    END.

    FOR EACH proces-item
        WHERE proces-item.it-codigo = p-it-codigo NO-LOCK:
        
        /*** Validade de datas para roteiro e lista componentes associadas ***/
        IF p-dt-inicio <> ? THEN DO:
            IF proces-item.cod-roteiro <> "" THEN DO:
                FIND rot-item
                    WHERE rot-item.it-codigo   = proces-item.it-codigo
                      AND rot-item.cod-roteiro = proces-item.cod-roteiro NO-LOCK NO-ERROR.

                IF NOT AVAILABLE rot-item                OR
                   (rot-item.data-inicio  > p-dt-inicio  OR
                    rot-item.data-termino < p-dt-inicio) THEN NEXT.
            END.
            IF proces-item.cod-lista-compon <> "" THEN DO:
                FIND FIRST lista-compon-item
                    WHERE lista-compon-item.cod-lista-compon = proces-item.cod-lista-compon
                      AND lista-compon-item.it-codigo        = proces-item.it-codigo NO-LOCK NO-ERROR.

                IF lista-compon-item.data-inicio  > p-dt-inicio OR
                   lista-compon-item.data-termino < p-dt-inicio THEN NEXT.       
            END.
        END.
        
        /* Verifica se existe restriá∆o para o processo */
        if proces-item.des-regra-proces <> "" OR
           proces-item.char-1           <> "" THEN DO:
            
            /*** Verifica a quantidade da ordem ***/
            IF  p-qt-ordem               <> ?           AND
                proces-item.qtd-min-item <> ?           AND
                proces-item.qtd-max-item <> ?           AND
               (p-qt-ordem <  proces-item.qtd-min-item  OR
                p-qt-ordem >= proces-item.qtd-max-item) THEN NEXT.

            /*** Verifica o estabelecimento do processo ***/
            IF p-cod-estabel           <> ?             AND
               proces-item.cod-estabel <> ""          AND
               proces-item.cod-estabel <> p-cod-estabel THEN NEXT.

            /*** Verifica a referencia ***/
            IF proces-item.cod-refer <> ""        AND
               proces-item.cod-refer <> p-cod-refer THEN NEXT.

            /*** Verifica a data de validade do processo ***/
            IF p-dt-inicio              <> ? AND
               proces-item.data-inicio  <> ? AND
               proces-item.data-termino <> ? THEN
                IF p-dt-inicio < proces-item.data-inicio  OR
                   p-dt-inicio > proces-item.data-termino THEN NEXT.

            /*** Verifica a linha de produá∆o ***/
            IF p-nr-linha           <> ?          AND
               proces-item.nr-linha <> ?          AND
               proces-item.nr-linha <> 0          AND
               proces-item.nr-linha <> p-nr-linha THEN NEXT.

            /*** Verifica a unidade de neg¢cio ***/
            &IF DEFINED(bf_man_206b) &THEN
            IF CAN-FIND(FIRST funcao
                        WHERE funcao.cd-funcao = "EMS2-UNIDADE-NEGOCIO"
                          AND funcao.ativo) THEN DO:
                if p-unid-negoc               <> ?            AND
                   p-unid-negoc               <> ""         AND
                   proces-item.cod-unid-negoc <> ?            AND
                   proces-item.cod-unid-negoc <> ""         AND
                   p-unid-negoc <> proces-item.cod-unid-negoc THEN NEXT.
            END.
            &ENDIF
        END.

        CREATE tt-proces-item.
        BUFFER-COPY proces-item TO tt-proces-item.

        IF NOT p-log-gera-lista THEN
            RETURN.

        ASSIGN v-soma-perc  = v-soma-perc + proces-item.proporcao
               v-num-proces = v-num-proces + 1.
    END.

    /*** Ajuste de somatoria de proporá‰es para 100 % ***/
    IF v-soma-perc > 0   AND
       v-soma-perc < 100 THEN
        FOR EACH tt-proces-item:
            ASSIGN tt-proces-item.proporcao = tt-proces-item.proporcao * 100 / v-soma-perc.
        END.

    IF v-soma-perc = 0 THEN
        FOR EACH tt-proces-item:
            ASSIGN tt-proces-item.proporcao = 100 / v-num-proces.
        END.
END PROCEDURE.



/* ************************  Function Implementations ***************** */

FUNCTION fn_ajust_dec RETURNS DECIMAL
 (p-valor AS DECIMAL, p-moeda AS INTEGER).
/*------------------------------------------------------------------------------
  Purpose:  Tratamento para n£mero de casas decimais.
    Notes:  cdp/cd1234.i
------------------------------------------------------------------------------*/
    FIND FIRST tt-moedas
        WHERE tt-moedas.cod-moeda = p-moeda NO-ERROR.

    IF NOT AVAILABLE tt-moedas THEN DO:
        FIND FIRST moeda
            WHERE moeda.mo-codigo = p-moeda NO-LOCK NO-ERROR.

        CREATE tt-moedas.
        ASSIGN tt-moedas.cod-moeda            = moeda.mo-codigo
               tt-moedas.qtd-decimais         = moeda.qtd-dec
               tt-moedas.ind-tratamento-infor = moeda.ind-val-infor
               tt-moedas.ind-tratamento-calc  = moeda.ind-val-calc.
    END.

    IF tt-moedas.qtd-decimais = 2 THEN
        RETURN p-valor.

    IF tt-moedas.ind-tratamento-calc = 1 THEN
        RETURN ROUND(p-valor, tt-moedas.qtd-decimais).
    ELSE
        RETURN TRUNCATE(p-valor, tt-moedas.qtd-decimais).
END FUNCTION.

FUNCTION fn_vld_ajust_dec RETURNS DECIMAL
 (p-valor AS DECIMAL, p-moeda AS INTEGER).
/*------------------------------------------------------------------------------
  Purpose:  Tratamento para n£mero de casas decimais.
    Notes:  cdp/cd1234.i
------------------------------------------------------------------------------*/
    FIND FIRST tt-moedas
        WHERE tt-moedas.cod-moeda = p-moeda NO-ERROR.

    IF NOT AVAILABLE tt-moedas THEN DO:
        FIND FIRST moeda
            WHERE moeda.mo-codigo = p-moeda NO-LOCK NO-ERROR.

        CREATE tt-moedas.
        ASSIGN tt-moedas.cod-moeda            = moeda.mo-codigo
               tt-moedas.qtd-decimais         = moeda.qtd-dec
               tt-moedas.ind-tratamento-infor = moeda.ind-val-infor
               tt-moedas.ind-tratamento-calc  = moeda.ind-val-calc.
    END.

    IF tt-moedas.qtd-decimais = 2 THEN
        RETURN p-valor.

    CASE tt-moedas.ind-tratamento-infor:
        WHEN 1 THEN
            RETURN ROUND(p-valor, tt-moedas.qtd-decimais).
        WHEN 2 THEN
            RETURN TRUNCATE(p-valor, tt-moedas.qtd-decimais).
        WHEN 3 THEN DO:
            IF TRUNCATE(p-valor, tt-moedas.qtd-decimais) <> p-valor THEN
                ASSIGN l-rejeita-dec = YES.
            RETURN p-valor.
        END.
    END.
END FUNCTION.

FUNCTION f-item-uni-estab RETURNS CHARACTER
 (p-it-codigo AS CHARACTER, p-cod-estabel AS CHARACTER, p-campo AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose:  item-uni-estab.
    Notes:  cdp/cd9203.i
------------------------------------------------------------------------------*/
    DEFINE VARIABLE l-fnc-pr-fiscal AS LOGICAL     NO-UNDO.
    DEFINE BUFFER b-item FOR item.
    DEFINE BUFFER b-item-uni-estab FOR item-uni-estab.

    IF CAN-FIND(FIRST funcao
                WHERE funcao.cd-funcao = "spp-pr-fiscal-estab"
                  AND funcao.ativo NO-LOCK) THEN
        ASSIGN l-fnc-pr-fiscal = YES.

    FIND FIRST b-item
        WHERE b-item.it-codigo = p-it-codigo NO-LOCK NO-ERROR.

    &IF DEFINED(bf_man_custeio_item) &THEN        
    &ELSE
    CASE p-campo:
        WHEN "data-base" THEN
            RETURN STRING(b-item.data-base).
        WHEN "preco-base" THEN
            RETURN STRING(b-item.preco-base).
        WHEN "data-ult-rep" THEN
            RETURN STRING(b-item.data-ult-rep).
        WHEN "preco-repos" THEN
            RETURN STRING(b-item.preco-repos).
        WHEN "data-ult-ent" THEN
            RETURN STRING(b-item.data-ult-ent).
        WHEN "preco-ul-ent" THEN
            RETURN STRING(b-item.preco-ul-ent).
        WHEN "preco-fiscal" THEN DO:
            &IF DEFINED(bf_man_204) &THEN
            IF l-fnc-pr-fiscal THEN DO:
                FIND FIRST item-uni-estab
                    WHERE item-uni-estab.it-codigo   = p-it-codigo
                      AND item-uni-estab.cod-estabel = p-cod-estabel NO-LOCK NO-ERROR.
                
                IF AVAILABLE item-uni-estab THEN
                    RETURN STRING(item-uni-estab.preco-fiscal).
                ELSE
                    RETURN "".                        
            END.
            ELSE
                RETURN STRING(b-item.preco-fiscal).
            &ELSE
            RETURN STRING(b-item.preco-fiscal).
            &ENDIF
        END.
    END.
    &ENDIF

    IF p-cod-estabel = ? THEN
        ASSIGN p-cod-estabel = b-item.cod-estabel.

    FIND FIRST b-item-uni-estab USE-INDEX codigo
        WHERE b-item-uni-estab.it-codigo   = p-it-codigo
          AND b-item-uni-estab.cod-estabel = p-cod-estabel NO-LOCK NO-ERROR.

    IF AVAILABLE b-item-uni-estab THEN DO:
        CASE p-campo:
            WHEN "altera-conta" THEN
                RETURN STRING(b-item-uni-estab.altera-conta).
            WHEN "cd-freq" THEN
                RETURN STRING(b-item-uni-estab.cd-freq).
            WHEN "cod-estab-gestor" THEN
                RETURN STRING(b-item-uni-estab.cod-estab-gestor).
            WHEN "cod-fat-ponder" THEN
                RETURN STRING(b-item-uni-estab.cod-fat-ponder).
            WHEN "cod-grp-compra" THEN
                RETURN STRING(b-item-uni-estab.cod-grp-compra).
            WHEN "crit-cc" THEN
                RETURN STRING(b-item-uni-estab.crit-cc).
            WHEN "crit-ce" THEN
                RETURN STRING(b-item-uni-estab.crit-ce).
            WHEN "data-pr-fisc" THEN
                RETURN STRING(b-item-uni-estab.data-pr-fisc).
            WHEN "data-ult-ressup" THEN
                RETURN STRING(b-item-uni-estab.data-ult-ressup).
            WHEN "dep-rej-cq" THEN
                RETURN STRING(b-item-uni-estab.dep-rej-cq).
            WHEN "deposito-cq" THEN
                RETURN STRING(b-item-uni-estab.deposito-cq).
            WHEN "fator-ponder[1]" THEN
                RETURN STRING(b-item-uni-estab.fator-ponder[1]).
            WHEN "fator-ponder[2]" THEN
                RETURN STRING(b-item-uni-estab.fator-ponder[2]).
            WHEN "fator-ponder[3]" THEN
                RETURN STRING(b-item-uni-estab.fator-ponder[3]).
            WHEN "fator-ponder[4]" THEN
                RETURN STRING(b-item-uni-estab.fator-ponder[4]).
            WHEN "fator-ponder[5]" THEN
                RETURN STRING(b-item-uni-estab.fator-ponder[5]).
            WHEN "fator-ponder[6]" THEN
                RETURN STRING(b-item-uni-estab.fator-ponder[6]).
            WHEN "fator-ponder[7]" THEN
                RETURN STRING(b-item-uni-estab.fator-ponder[7]).
            WHEN "fator-ponder[8]" THEN
                RETURN STRING(b-item-uni-estab.fator-ponder[8]).
            WHEN "fator-ponder[9]" THEN
                RETURN STRING(b-item-uni-estab.fator-ponder[9]).
            WHEN "fator-ponder[10]" THEN
                RETURN STRING(b-item-uni-estab.fator-ponder[10]).
            WHEN "fator-ponder[11]" THEN
                RETURN STRING(b-item-uni-estab.fator-ponder[11]).
            WHEN "fator-ponder[12]" THEN
                RETURN STRING(b-item-uni-estab.fator-ponder[12]).
            WHEN "ind-cons-prv" THEN
                RETURN STRING(b-item-uni-estab.ind-cons-prv).
            WHEN "ind-lista-csp" THEN
                RETURN STRING(b-item-uni-estab.ind-lista-csp).
            WHEN "ind-lista-mrp" THEN
                RETURN STRING(b-item-uni-estab.ind-lista-mrp).
            WHEN "ind-refugo" THEN
                RETURN STRING(b-item-uni-estab.ind-refugo).
            WHEN "lim-var-qtd" THEN
                RETURN STRING(b-item-uni-estab.lim-var-qtd).
            WHEN "lim-var-valor" THEN
                RETURN STRING(b-item-uni-estab.lim-var-valor).
            WHEN "log-ad-consumo" THEN
                RETURN STRING(b-item-uni-estab.log-ad-consumo).
            WHEN "log-finaliz-op" THEN
                RETURN STRING(b-item-uni-estab.log-finaliz-op).
            WHEN "lote-per-max" THEN
                RETURN STRING(b-item-uni-estab.lote-per-max).
            WHEN "ponto-encomenda" THEN
                RETURN STRING(b-item-uni-estab.ponto-encomenda).
            WHEN "prioridade-aprov" THEN
                RETURN STRING(b-item-uni-estab.prioridade-aprov).
            WHEN "qt-min-res-fabr" THEN
                RETURN STRING(b-item-uni-estab.qt-min-res-fabr).
            WHEN "res-min-fabri" THEN
                RETURN STRING(b-item-uni-estab.res-min-fabri).
            WHEN "tp-codigo" THEN
                RETURN STRING(b-item-uni-estab.tp-codigo).
            WHEN "tp-ressup" THEN
                RETURN STRING(b-item-uni-estab.tp-ressup).
            WHEN "var-qtd-re" THEN
                RETURN STRING(b-item-uni-estab.var-qtd-re).
            WHEN "var-qtd-res-fabr" THEN
                RETURN STRING(b-item-uni-estab.var-qtd-res-fabr).
            WHEN "var-tempo-res-fabr" THEN
                RETURN STRING(b-item-uni-estab.var-tempo-res-fabr).
            WHEN "var-val-re-maior" THEN
                RETURN STRING(b-item-uni-estab.var-val-re-maior).
            WHEN "var-val-re-menor" THEN
                RETURN STRING(b-item-uni-estab.var-val-re-menor).
            WHEN "variacao-perm" THEN
                RETURN STRING(b-item-uni-estab.variacao-perm).
            WHEN "vl-ggf-ant" THEN
                RETURN STRING(b-item-uni-estab.vl-ggf-ant).
            WHEN "vl-mat-ant" THEN
                RETURN STRING(b-item-uni-estab.vl-mat-ant).
            WHEN "vl-mob-ant" THEN
                RETURN STRING(b-item-uni-estab.vl-mob-ant).
            WHEN "cap-est-fabr" THEN
                RETURN STRING(b-item-uni-estab.cap-est-fabr).
            WHEN "cd-planejado" THEN
                RETURN STRING(b-item-uni-estab.cd-planejado).
            WHEN "char-1" THEN
                RETURN STRING(b-item-uni-estab.char-1).
            WHEN "char-2" THEN
                RETURN STRING(b-item-uni-estab.char-2).
            WHEN "check-sum" THEN
                RETURN STRING(b-item-uni-estab.check-sum).
            WHEN "ciclo-contag" THEN
                RETURN STRING(b-item-uni-estab.ciclo-contag).
            WHEN "classe-repro" THEN
                RETURN STRING(b-item-uni-estab.classe-repro).
            WHEN "classif-abc" THEN
                RETURN STRING(b-item-uni-estab.classif-abc).
            WHEN "cod-comprado" THEN
                RETURN STRING(b-item-uni-estab.cod-comprado).
            WHEN "cod-estabel" THEN
                RETURN STRING(b-item-uni-estab.cod-estabel).
            WHEN "cod-localiz" THEN
                RETURN STRING(b-item-uni-estab.cod-localiz).
            WHEN "cod-obsoleto" THEN
                RETURN STRING(b-item-uni-estab.cod-obsoleto).
            WHEN "consumo-aad" THEN
                RETURN STRING(b-item-uni-estab.consumo-aad).
            WHEN "consumo-prev" THEN
                RETURN STRING(b-item-uni-estab.consumo-prev).
            WHEN "contr-plan" THEN
                RETURN STRING(b-item-uni-estab.contr-plan).
            WHEN "contr-qualid" THEN
                RETURN STRING(b-item-uni-estab.contr-qualid).
            WHEN "conv-tempo-seg" THEN
                RETURN STRING(b-item-uni-estab.conv-tempo-seg).
            WHEN "criticidade" THEN
                RETURN STRING(b-item-uni-estab.criticidade).
            WHEN "curva-abc" THEN
                RETURN STRING(b-item-uni-estab.curva-abc).
            WHEN "data-1" THEN
                RETURN STRING(b-item-uni-estab.data-1).
            WHEN "data-2" THEN
                RETURN STRING(b-item-uni-estab.data-2).
            WHEN "data-base" THEN
                RETURN STRING(b-item-uni-estab.data-base).
            WHEN "data-ult-con" THEN
                RETURN STRING(b-item-uni-estab.data-ult-con).
            WHEN "data-ult-ent" THEN
                RETURN STRING(b-item-uni-estab.data-ult-ent).
            WHEN "data-ult-rep" THEN
                RETURN STRING(b-item-uni-estab.data-ult-rep).
            WHEN "data-ult-sai" THEN
                RETURN STRING(b-item-uni-estab.data-ult-sai).
            WHEN "dec-1" THEN
                RETURN STRING(b-item-uni-estab.dec-1).
            WHEN "dec-2" THEN
                RETURN STRING(b-item-uni-estab.dec-2).
            WHEN "demanda" THEN
                RETURN STRING(b-item-uni-estab.demanda).
            WHEN "deposito-pad" THEN
                RETURN STRING(b-item-uni-estab.deposito-pad).
            WHEN "div-ordem" THEN
                RETURN STRING(b-item-uni-estab.div-ordem).
            WHEN "emissao-ord" THEN
                RETURN STRING(b-item-uni-estab.emissao-ord).
            WHEN "fator-refugo" THEN
                RETURN STRING(b-item-uni-estab.fator-refugo).
            WHEN "horiz-fixo" THEN
                RETURN STRING(b-item-uni-estab.horiz-fixo).
            WHEN "ind-calc-meta" THEN
                RETURN STRING(b-item-uni-estab.ind-calc-meta).
            WHEN "ind-prev-demanda" THEN
                RETURN STRING(b-item-uni-estab.ind-prev-demanda).
            WHEN "int-1" THEN
                RETURN STRING(b-item-uni-estab.int-1).
            WHEN "int-2" THEN
                RETURN STRING(b-item-uni-estab.int-2).
            WHEN "it-codigo" THEN
                RETURN STRING(b-item-uni-estab.it-codigo).
            WHEN "loc-unica" THEN
                RETURN STRING(b-item-uni-estab.loc-unica).
            WHEN "log-1" THEN
                RETURN STRING(b-item-uni-estab.log-1).
            WHEN "log-2" THEN
                RETURN STRING(b-item-uni-estab.log-2).
            WHEN "lote-economi" THEN
                RETURN STRING(b-item-uni-estab.lote-economi).
            WHEN "lote-minimo" THEN
                RETURN STRING(b-item-uni-estab.lote-minimo).
            WHEN "lote-multipl" THEN
                RETURN STRING(b-item-uni-estab.lote-multipl).
            WHEN "nat-despesa" THEN
                RETURN STRING(b-item-uni-estab.nat-despesa).
            WHEN "nr-linha" THEN
                RETURN STRING(b-item-uni-estab.nr-linha).
            WHEN "periodo-fixo" THEN
                RETURN STRING(b-item-uni-estab.periodo-fixo).
            WHEN "perm-saldo-neg" THEN
                RETURN STRING(b-item-uni-estab.perm-saldo-neg).
            WHEN "politica" THEN
                RETURN STRING(b-item-uni-estab.politica).
            WHEN "preco-base" THEN
                RETURN STRING(b-item-uni-estab.preco-base).
            WHEN "preco-fiscal" THEN
                RETURN STRING(b-item-uni-estab.preco-fiscal).
            WHEN "preco-repos" THEN
                RETURN STRING(b-item-uni-estab.preco-repos).
            WHEN "preco-ul-ent" THEN
                RETURN STRING(b-item-uni-estab.preco-ul-ent).
            WHEN "prioridade" THEN
                RETURN STRING(b-item-uni-estab.prioridade).
            WHEN "qt-max-ordem" THEN
                RETURN STRING(b-item-uni-estab.qt-max-ordem).
            WHEN "qtd-batch-padrao" THEN
                RETURN STRING(b-item-uni-estab.qtd-batch-padrao).
            WHEN "qtd-refer-custo-dis" THEN
                RETURN STRING(b-item-uni-estab.qtd-refer-custo-dis).
            WHEN "quant-perda" THEN
                RETURN STRING(b-item-uni-estab.quant-perda).
            WHEN "quant-segur" THEN
                RETURN STRING(b-item-uni-estab.quant-segur).
            WHEN "rep-prod" THEN
                RETURN STRING(b-item-uni-estab.rep-prod).
            WHEN "reporte-ggf" THEN
                RETURN STRING(b-item-uni-estab.reporte-ggf).
            WHEN "reporte-mob" THEN
                RETURN STRING(b-item-uni-estab.reporte-mob).
            WHEN "res-cq-comp" THEN
                RETURN STRING(b-item-uni-estab.res-cq-comp).
            WHEN "res-cq-fabri" THEN
                RETURN STRING(b-item-uni-estab.res-cq-fabri).
            WHEN "res-for-comp" THEN
                RETURN STRING(b-item-uni-estab.res-for-comp).
            WHEN "res-int-comp" THEN
                RETURN STRING(b-item-uni-estab.res-int-comp).
            WHEN "ressup-fabri" THEN
                RETURN STRING(b-item-uni-estab.ressup-fabri).
            WHEN "sit-aloc" THEN
                RETURN STRING(b-item-uni-estab.sit-aloc).
            WHEN "tempo-segur" THEN
                RETURN STRING(b-item-uni-estab.tempo-segur).
            WHEN "tipo-est-seg" THEN
                RETURN STRING(b-item-uni-estab.tipo-est-seg).
            WHEN "tipo-lote-ec" THEN
                RETURN STRING(b-item-uni-estab.tipo-lote-ec).
            WHEN "tipo-requis" THEN
                RETURN STRING(b-item-uni-estab.tipo-requis).
            WHEN "tipo-sched" THEN
                RETURN STRING(b-item-uni-estab.tipo-sched).
            WHEN "tp-aloc-lote" THEN
                RETURN STRING(b-item-uni-estab.tp-aloc-lote).
            WHEN "val-fator-custo-dis" THEN
                RETURN STRING(b-item-uni-estab.val-fator-custo-dis).
            WHEN "var-mob-maior" THEN
                RETURN STRING(b-item-uni-estab.var-mob-maior).
            WHEN "var-mob-menor" THEN
                RETURN STRING(b-item-uni-estab.var-mob-menor).
            WHEN "var-rep" THEN
                RETURN STRING(b-item-uni-estab.var-rep).
            WHEN "var-transf" THEN
                RETURN STRING(b-item-uni-estab.var-transf).
            WHEN "variac-acum" THEN
                RETURN STRING(b-item-uni-estab.variac-acum).
            WHEN "vl-var-max" THEN
                RETURN STRING(b-item-uni-estab.vl-var-max).
            WHEN "vl-var-min" THEN
                RETURN STRING(b-item-uni-estab.vl-var-min).
            WHEN "val-lim-absor" THEN
                RETURN STRING(b-item-uni-estab.val-lim-absor).
        END CASE.
    END.
    
    RETURN "".
END FUNCTION.
