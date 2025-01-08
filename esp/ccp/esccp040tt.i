DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino        AS   INTEGER
    FIELD arquivo        AS   CHARACTER FORMAT "x(35)":U
    FIELD usuario        AS   CHARACTER FORMAT "x(12)":U
    FIELD data-exec      AS   DATE
    FIELD hora-exec      AS   INTEGER
    FIELD cd-plano       AS   INTEGER   FORMAT ">>9"         
    FIELD benefic        AS   INTEGER                        
    FIELD en-con2        AS   LOGICAL                        
    FIELD entrada2       AS   LOGICAL                        
    FIELD re-con2        AS   LOGICAL                        
    FIELD remessa2       AS   LOGICAL                        
    FIELD transfer2      AS   LOGICAL                        
    FIELD cred-aprov     AS   LOGICAL                        
    FIELD ord-comp       AS   LOGICAL                        
    FIELD ord-prod       AS   LOGICAL                        
    FIELD pedidos        AS   LOGICAL                        
    FIELD planejada      AS   LOGICAL                        
    FIELD res-comp       AS   LOGICAL                        
    FIELD res-plan       AS   LOGICAL                        
    FIELD sald-est       AS   LOGICAL                        
    FIELD sald-terc      AS   LOGICAL                        
    FIELD dt-corte       AS   DATE      FORMAT "99/99/9999":U
    FIELD dt-plan        AS   DATE      FORMAT "99/99/9999":U
    FIELD estab-ini      AS   CHARACTER FORMAT "x(5)" 
    FIELD estab-fim      AS   CHARACTER FORMAT "x(5)"        
    FIELD unid-negoc-ini AS   CHARACTER FORMAT "X(3)":U
    FIELD unid-negoc-fim AS   CHARACTER FORMAT "X(3)":U
    FIELD embarque       LIKE embarque-imp.embarque
    .
    
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem            AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo          AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

/* Local Variable Definitions ---                                       */
{cdp/cdcfgman.i} /******* Include para mini-flexibiliza‡Æo *********/
{esp/ccp/esccp032.i22} /*cdp/cd0666.i*/   /* defini»’o da tt-erro            */
{esp/ccp/esccp032.i24} /*cpapi020.i*/ /*** tt-balanceia  ***/
{esp/ccp/esccp032.i25} /*cpapi020.i1*/ /******* funcoes p/ fator de concentracao e ppm ***/

{esp/es0018.i}

DEFINE VARIABLE c-liter            as   character format "x(18)" extent 15          NO-UNDO.
DEFINE VARIABLE de-quantidade      as   decimal   format "->>>,>>>,>>9.9999" init 0 NO-UNDO.
DEFINE VARIABLE de-saldo-inic      as   decimal   format "->>>>>,>>9.9999"          no-undo.
DEFINE VARIABLE de-saldo-terc      as   decimal   format "->>>>>,>>9.9999"          no-undo.
DEFINE VARIABLE de-saldo-inic-teor as   decimal   format "->>>>>,>>9.9999"          no-undo.
DEFINE VARIABLE de-saldo-terc-teor as   decimal   format "->>>>>,>>9.9999"          no-undo.
DEFINE VARIABLE da-op-corte        as   date init ?                                 NO-UNDO.
DEFINE VARIABLE de-quant-segur     like item.quant-segur                            NO-UNDO.
DEFINE VARIABLE de-saldo           as   decimal format "->>>>>,>>9.9999"            NO-UNDO.
DEFINE VARIABLE l-apenas-oem       AS   LOGICAL                                     NO-UNDO.
DEFINE VARIABLE c-clientes-oem     AS   CHARACTER                                   NO-UNDO.
DEFINE VARIABLE de-saldo-item      as   decimal format "->>>>>,>>9.9999" init 0     NO-UNDO.
DEFINE VARIABLE de-saldo-aloc      as   decimal format "->>>>>,>>9.9999" init 0     NO-UNDO.
DEFINE VARIABLE de-ped-saldo       as   decimal                                     NO-UNDO.
DEFINE VARIABLE i-tam-per          as   integer                                     NO-UNDO.
DEFINE VARIABLE da-termino         as   date format "99/99/9999"                    NO-UNDO.
DEFINE VARIABLE da-inicio          as   date format "99/99/9999"                    NO-UNDO.
DEFINE VARIABLE da-data-aux        as   date                                        NO-UNDO.
DEFINE VARIABLE da-dat             as   date format "99/99/9999"                    NO-UNDO.
DEFINE VARIABLE da-dat-in          as   date format "99/99/9999"                    NO-UNDO.
DEFINE VARIABLE de-qt-seg          as   decimal                                     NO-UNDO.
DEFINE VARIABLE i-nr-dias          as   integer                                     NO-UNDO.
DEFINE VARIABLE i-ressup           as   integer                                     NO-UNDO.
DEFINE VARIABLE da-termino-f       as   date format "99/99/9999"                    NO-UNDO.
DEFINE VARIABLE i-ind              as   integer                                     NO-UNDO.
DEFINE VARIABLE de-qt-min          as   decimal                                     NO-UNDO.
DEFINE VARIABLE de-qt-dlt          as   decimal                                     NO-UNDO.
DEFINE VARIABLE i-dias-dlt         as   integer                                     NO-UNDO.
DEFINE VARIABLE de-vezes           as   decimal                                     NO-UNDO.
DEFINE VARIABLE i-res-var          as   integer                                     NO-UNDO.
DEFINE VARIABLE h-acomp            AS   HANDLE                                      NO-UNDO.
DEFINE VARIABLE c-plan-ini         LIKE ITEM.cd-planejado                           NO-UNDO.
DEFINE VARIABLE c-plan-fim         LIKE ITEM.cd-planejado                           NO-UNDO.
DEFINE VARIABLE i-nr-linha-ini     AS   INTEGER                                     NO-UNDO.
DEFINE VARIABLE i-nr-linha-fim     AS   INTEGER                                     NO-UNDO.
DEFINE VARIABLE c-item-referencia  LIKE ITEM.it-codigo                              NO-UNDO.
DEFINE VARIABLE de-tot-reserva     AS   DECIMAL                                     NO-UNDO.
DEFINE VARIABLE de-tot-rateio      AS   DECIMAL                                     NO-UNDO.
DEFINE VARIABLE de-tot-perc-rat    AS   DECIMAL                                     NO-UNDO.


DEFINE NEW GLOBAL SHARED VARIABLE da-dt-plan    as   date format "99/99/9999" init "12/31/9999" NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-pedidos     as   logical   init yes                         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-res-comp    as   logical   init yes                         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-ord-comp    as   logical   init NO                          NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE da-dt-corte   as   date format "99/99/9999" init "12/31/9999" NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-cod-refer   like ref-item.cod-refer                         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-sald-est    as   logical   init yes                         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-remessa     as   logical   init yes                         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-entrada     as   logical   init yes                         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-transfer    as   logical   init yes                         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-remessa-con as   logical   init yes                         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-ent-con     as   logical   init yes                         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-sald-terc   as   logical   init NO                          NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-estab-ini   as   character init "105"                       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-estab-fim   as   character init "105"                       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-ord-prod    as   logical   init NO                          NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-planejada   as   logical   init NO                          NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE i-benefic     as   integer   init 2                           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-cred-aprov  as   logical   init yes                         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-depositos   as   logical                                    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE p-remessa     as   logical   init yes                         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE p-entrada     as   logical   init yes                         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE p-transfer    as   logical   init yes                         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE p-re-con      as   logical   init yes                         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE p-en-con      as   logical   init yes                         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-res-plan    as   logical   init yes                         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE i-cod-plano   like pl-prod.cd-plano INIT 5                    NO-UNDO.

&IF defined(bf_man_206b) &THEN
    DEFINE NEW GLOBAL SHARED VARIABLE c-unid-negoc-ini  as character init ""    NO-UNDO.
    DEFINE NEW GLOBAL SHARED VARIABLE c-unid-negoc-fim  as character init "ZZZ" NO-UNDO.
&ENDIF

DEFINE BUFFER b-ped-item for ped-item.
DEFINE BUFFER b3-item    for item.
DEFINE BUFFER b1-item    for item.
DEFINE BUFFER b-periodo  for periodo.
DEFINE BUFFER b-item     for item.

DEFINE TEMP-TABLE tt-depositos
    field cod-estabel like estabelec.cod-estabel column-label "Cod Estabel"
    field cod-depos   like deposito.cod-depos    column-label "Cod Deposito".

DEFINE TEMP-TABLE tt-estoq NO-UNDO
    field tipo         as   character format "x(08)"
    field referencia   as   character format "x(85)"
    field quantidade   like de-quantidade
    field dt-inicio    as   date format "99/99/9999"
    field dt-termino   as   date format "99/99/9999"
    field saldo        as   decimal format "->>>>>>,>>9.9999"
    field observ       as   character format "x(18)" 
    field item-pai     as   character 
    field unid-negoc   as   character format "x(3)"
    index codigo is primary dt-termino tipo.

DEFINE TEMP-TABLE tt-itens-relacao NO-UNDO
    FIELD it-codigo     LIKE ITEM.it-codigo
    FIELD it-original   LIKE ITEM.it-codigo
    FIELD dt-termino    AS   DATE
    FIELD quantidade    LIKE de-quantidade
    FIELD item-embarque LIKE ITEM.it-codigo
    FIELD qtde-embarque LIKE de-quantidade
    FIELD l-considerar  AS   LOGICAL
    INDEX id-item
            it-codigo
            it-original
    INDEX id-considerar
            l-considerar.

DEFINE TEMP-TABLE tt-itens-projeto NO-UNDO
    FIELD cod-projeto   LIKE int-projeto.cod-projeto
    FIELD desc-projeto  LIKE int-projeto.desc-projeto
    FIELD c-item-filho    AS CHAR
    FIELD c-item-acabado  AS CHAR
    FIELD c-des-item-pai  AS CHAR
    FIELD c-des-item-emb  AS CHAR
    FIELD de-qtd-reserva  AS DEC
    FIELD de-qtd-embarque AS DEC
    FIELD de-qtd-rateio   AS DEC
    FIELD de-perc-rateio  AS DEC
    FIELD de-qtd-estrut   AS DEC
    INDEX id-projeto
            cod-projeto
            c-item-acabado
            c-item-filho
    INDEX id-filho
            c-item-filho
            c-item-acabado
    INDEX id-acabado
            c-item-acabado.

DEFINE TEMP-TABLE tt-itens-embarque NO-UNDO
    FIELD it-codigo       LIKE ITEM.it-codigo
    FIELD de-qtd-embarque   AS DEC
    INDEX id-item
            it-codigo.


DEFINE BUFFER bf-item             FOR ITEM.
DEFINE BUFFER bf-tt-itens-projeto FOR tt-itens-projeto.

/* definicao da tt-epc */
{include/i-epc200.i1}

DEFINE VARIABLE c-arquivo-csv AS CHARACTER FORMAT "X(100)":U NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER FORMAT 'x(200)':U NO-UNDO.

DEFINE STREAM str-excel.
