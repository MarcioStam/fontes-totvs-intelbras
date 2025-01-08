/***********************************************************************
**  Programa..: ESP/CEP/ESCEP064.1
**  Autor.....: Hoepers
**  Data......: 11/10/2012
**  Descricao.: Exportaá∆o Dados de Controle Quotas Manaus para Pinho
**  Vers∆o....: 001 11/10/2012 -  Desenvolvimento Programa
************************************************************************/

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    FIELD dat-inicial      AS DATE
    FIELD dat-final        AS DATE
    FIELD log-nfe          AS LOG
    FIELD log-nfs          AS LOG
    FIELD log-estoque      AS LOG
    FIELD log-perda        AS LOG
    FIELD log-estrutura    AS LOG
    FIELD log-tab-preco    AS LOG
    FIELD cod-estabel      AS CHAR.

define temp-table tt-raw-digita
    field raw-digita as raw.

define temp-table tt-item-doc-est NO-UNDO
    FIELD nro-docto        LIKE movto-estoq.nro-docto
    FIELD serie            LIKE movto-estoq.serie
    FIELD cod-emitente     LIKE movto-estoq.cod-emitente
    FIELD nat-operacao     LIKE movto-estoq.nat-operacao
    FIELD dt-emissao       LIKE movto-estoq.dt-trans
    FIELD des-decla-import LIKE docto-estoq-nfe-imp.des-decla-import
    FIELD it-codigo        LIKE movto-estoq.it-codigo
    FIELD quantidade       LIKE movto-estoq.quantidade
    FIELD un-fornec        LIKE movto-estoq.un
    FIELD un-interna       LIKE movto-estoq.un
    FIELD class-fiscal     LIKE ITEM.class-fiscal
    FIELD narrativa          AS CHAR
    FIELD ind-origem         AS INT  /* 1-Fornecedor, 2-Transferencia */
    FIELD ind-tipo           AS INT  /* 1-Materia-Prima, 2-Acabado    */
    INDEX id-item-doc-est
            serie
            nro-docto   
            cod-emitente
            nat-operacao
            it-codigo.

define temp-table tt-item-nfs NO-UNDO
    FIELD nr-nota-fis      LIKE movto-estoq.nro-docto
    FIELD serie            LIKE movto-estoq.serie
    FIELD cod-estabel      LIKE movto-estoq.cod-estabel
    FIELD dt-emis-nota     LIKE movto-estoq.dt-trans
    FIELD it-codigo        LIKE movto-estoq.it-codigo
    FIELD qt-faturada      LIKE movto-estoq.quantidade
    FIELD un-fatur         LIKE movto-estoq.un
    FIELD class-fiscal     LIKE ITEM.class-fiscal
    FIELD narrativa          AS CHAR
    FIELD ind-destino        AS INT  /* 1-Fornecedor, 2-Transferencia */
    FIELD ind-tipo           AS INT  /* 1-Materia-Prima, 2-Acabado    */
    INDEX id-item-nfs
            cod-estabel
            serie
            nr-nota-fis
            it-codigo.

define temp-table tt-estoque NO-UNDO
    FIELD it-codigo        LIKE sl-it-per.it-codigo
    FIELD data-saldo       LIKE sl-it-per.periodo
    FIELD quantidade       LIKE sl-it-per.quantidade
    FIELD un               LIKE ITEM.un
    FIELD class-fiscal     LIKE ITEM.class-fiscal
    FIELD narrativa          AS CHAR
    FIELD ind-tipo           AS INT /* 1-Materia-Prima, 2-Acabado    */
    INDEX id-item
            it-codigo
            data-saldo.

define temp-table tt-perdas NO-UNDO
    FIELD it-codigo        LIKE movto-estoq.it-codigo
    FIELD data-perda       LIKE movto-estoq.dt-trans
    FIELD quantidade       LIKE movto-estoq.quantidade
    FIELD un               LIKE movto-estoq.un
    FIELD class-fiscal     LIKE ITEM.class-fiscal
    FIELD narrativa          AS CHAR
    FIELD ind-tipo           AS INT  /* 1-Materia-Prima, 2-Acabado    */
    INDEX it-data-item
            data-perda
            it-codigo.

define temp-table tt-estrutura-exp NO-UNDO
    FIELD it-codigo        LIKE estrutura.it-codigo
    FIELD it-pai           LIKE estrutura.es-codigo
    FIELD quantidade       LIKE estrutura.quant-usada
    FIELD data-inicio      LIKE estrutura.data-inicio
    FIELD data-termino     LIKE estrutura.data-termino
    FIELD un               LIKE ITEM.un
    FIELD class-fiscal     LIKE ITEM.class-fiscal
    FIELD narrativa          AS CHAR
    FIELD seq                AS INT
    FIELD nivel              AS INT
    FIELD ind-origem         AS INT /* 1-Importado, 2-Nacional    */
    INDEX id-estrutura
            seq
            nivel.

define temp-table tt-naturezas NO-UNDO
    FIELD nat-operacao LIKE docum-est.nat-operacao
    FIELD log-entrada    AS LOG
    FIELD log-perda      AS LOG
    INDEX id-movto
            nat-operacao
            log-entrada
            log-perda.

define temp-table tt-cta-perda NO-UNDO
    FIELD ct-codigo AS CHAR FORMAT "X(8)".

define temp-table tt-item-importado NO-UNDO
    FIELD it-codigo     LIKE ITEM.it-codigo
    FIELD log-importado   AS LOG
    FIELD ind-tipo        AS INT
    INDEX id-item
            it-codigo.

define temp-table tt-tp-desp-imp NO-UNDO
    FIELD tp-desp-padrao LIKE item-uni-estab.tp-desp-padrao.

define temp-table tt-estrutura NO-UNDO
    field seq             as integer
    field it-codigo     like estrutura.it-codigo
    field nivel           as char format "X(16)"
    field row-estrutura   as rowid
    field es-codigo     like estrutura.es-codigo
    field refer         like    ref-item.cod-refer
    field quant-usada   like estrutura.quant-usada     
    field quant-liquid  like estrutura.quant-liquid
    field descricao     like item.desc-item
    field data-inicio   like estrutura.data-inicio
    field compr-fabric  like item.compr-fabric
    field un            like item.un
    field aux             as char   format "X(4)" 
    INDEX seq IS primary 
            seq ASCENDING
    INDEX es-codigo 
            es-codigo.   

define temp-table tt-item-estrutura NO-UNDO
    FIELD it-codigo     LIKE ITEM.it-codigo
    INDEX id-item
            it-codigo.

define temp-table tt-item-tab NO-UNDO
    FIELD it-codigo     LIKE ITEM.it-codigo
    FIELD cod-emitente  LIKE emitente.cod-emitente
    FIELD quant-min     LIKE item-tab.quant-min
    FIELD un            LIKE item.un
    FIELD pr-item       LIKE item-tab.pr-item
    FIELD mo-descricao  LIKE moeda.descricao
    INDEX id
          it-codigo.
