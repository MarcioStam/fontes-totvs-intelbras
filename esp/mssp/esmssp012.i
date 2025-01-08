/*****************************************************************************
** Programa: esp/mssp/esmssp012.i
** Vers∆o..: 1.00
** Data....: 15/03/2012
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Include para definiá∆o das temp-tables do programa ESMSSP012
*****************************************************************************/

{cdp/cdapi244.i "new shared"}   /* Definiá∆o temp-table tt-item */

DEFINE TEMP-TABLE tt-item-xml NO-UNDO
    FIELD it-codigo        LIKE item.it-codigo               /* C¢digo do Item             */
    FIELD un               LIKE item.un                      /* Unidade de Medida          */
    FIELD desc-item        LIKE item.desc-item               /* Descriá∆o do Item          */
    FIELD desc-inter       LIKE item.desc-inter              /* Desc. em Inglàs            */
    FIELD cod-estabel      LIKE item.cod-estabel             /* C¢digo do Estabelecimento  */
    FIELD fm-codigo        LIKE item.fm-codigo               /* Fam°lia Material           */
    FIELD class-fiscal     LIKE item.class-fiscal            /* NCM                        */
    FIELD narrativa        LIKE item.narrativa               /* Narrativa                  */
    FIELD responsavel      LIKE item.responsavel             /* Respons†vel                */
    FIELD peso-liquido     LIKE item.peso-liquido            /* Peso L°quido               */
    FIELD peso-bruto       LIKE item.peso-bruto              /* Peso Bruto                 */
    FIELD comprim          LIKE item.comprim                 /* Comprimento                */
    FIELD largura          LIKE item.largura                 /* Largura                    */
    FIELD altura           LIKE item.altura                  /* Altura                     */
    FIELD cd-folh-item     LIKE item.cd-folh-item            /* Folha Especificaá∆o        */
    FIELD ind-serv-mat     LIKE item.ind-serv-mat            /* Aplicaá∆o                  */
    FIELD tipo-contr       LIKE item.tipo-contr              /* Tipo de Controle           */
    FIELD ge-codigo        LIKE item.ge-codigo               /* Grupo de Estoque           */
    FIELD contr-qualid     LIKE item.contr-qualid            /* Controle de Qualidade      */
    FIELD fraciona         LIKE item.fraciona                /* Quantidade Fracionada      */
    FIELD criticidade      LIKE item.criticidade             /* Criticidade                */
    FIELD fm-cod-com       LIKE item.fm-cod-com              /* Fam°lia Comercial          */
    FIELD perc-nqa         LIKE item.perc-nqa                /* NQA                        */
    FIELD cd-planejado     LIKE item.cd-planejado            /* Planejador                 */
    FIELD reporte-ggf      LIKE item.reporte-ggf             /* Reporte GGF                */
    FIELD ind-tipo-movto   AS INTEGER FORMAT "99" INITIAL 1  /* Tipo Movimento             */
    FIELD destaq-ncm       LIKE int-item.destaque            /* Destaque NCM               */
    FIELD perc-gatt        LIKE int-item.perc-gatt           /* Percentual GATT            */
    FIELD ex-tarifario     LIKE int-item.ex-tarifario        /* Ex Tarif†rio               */
    FIELD nve              LIKE int-item.nve                 /* NVE                        */
    FIELD seq-suframa      LIKE int-item.seq-suframa         /* Sequància SUFRAMA          */
    FIELD tipo-item        AS CHARACTER FORMAT "x(02)"       /* Tipo do Item               */
    FIELD versao           AS DECIMAL                        /* Vers∆o                     */
    FIELD data-versao      AS DATE                           /* Data de Vers∆o             */
    FIELD cod-acond        AS CHARACTER                      /* Acondicionamento           */
    FIELD des-acond        AS CHARACTER                      /* Descriá∆o Acondicionamento */
    FIELD cod-amost        AS INTEGER                        /* Amostragem                 */
    FIELD des-amost        AS CHARACTER                      /* Descriá∆o Amostragem       */
    FIELD inf-adic         AS CHARACTER                      /* Informaá‰es Adicionais     */
    FIELD un-neg           AS CHARACTER                      /* Descriá∆o da Unid Neg¢cio  */
    FIELD aliquota-ii      LIKE item.aliquota-ii             /* Al°quota Imposto Importaá∆o */
    FIELD aliquota-ipi     LIKE item.aliquota-ipi            /* Al°quota IPI                */
    FIELD aliquota-pis     AS DECIMAL                        /* Al°quota PIS                */
    FIELD aliquota-cofins  AS DECIMAL                        /* Al°quota COFINS             */
    FIELD log-necessita-li LIKE item.log-necessita-li        /* Necessita LI?               */
    FIELD log-antidumping  LIKE int-item.log-antidumping     /* Tem Antidumping             */
    FIELD obs-antidumping  LIKE int-item.obs-antidumping     /* Observaá∆o Antidumping      */
    FIELD cest             LIKE sit-tribut.cdn-sit-tribut INITIAL 0    /* CEST */
    INDEX idx-item IS PRIMARY
        it-codigo.

DEFINE TEMP-TABLE tt-item-fabric NO-UNDO
    FIELD cod-fabric LIKE item-fabric.cod-fabric
    FIELD it-fabric  LIKE item-fabric.it-fabric
    FIELD referencia LIKE item-fabric.referencia.

/* Valores para o campo: tt-item-xml.tipo-item
<OPTION VALUE="x">Nao informado
<OPTION VALUE="0">0 - Mercadoria para Revenda
<OPTION VALUE="1">1 - Materia-prima
<OPTION VALUE="2">2 - Embalagem
<OPTION VALUE="3">3 - Produto em Processo
<OPTION VALUE="4">4 - Produto Acabado
<OPTION VALUE="5">5 - Subproduto
<OPTION VALUE="6">6 - Produto Intermedi rio
<OPTION VALUE="7">7 - Material de Uso e Consumo
<OPTION VALUE="8">8 - Ativo Imobilizado
<OPTION VALUE="9">9 - Servicos
<OPTION VALUE="a">10 - Outros Insumos
<OPTION VALUE="b">99 - Outras
*/

DEFINE TEMP-TABLE tt-item-alt LIKE item
    FIELD cod-maq-origem  AS INTEGER FORMAT "9999"      INITIAL 0
    FIELD num-processo    AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0
    FIELD num-sequencia   AS INTEGER FORMAT ">>>>>9"    INITIAL 0
    FIELD ind-tipo-movto  AS INTEGER FORMAT "99"        INITIAL 1
    INDEX ch-codigo       IS PRIMARY  cod-maq-origem
                                      num-processo
                                      num-sequencia.


/* Temp-table utilizada pelo programa ESCRM005 */
DEFINE TEMP-TABLE tt-atributo-entrada NO-UNDO
    FIELD tipo          AS CHARACTER
    FIELD nome          AS CHARACTER
    FIELD nome-pai      AS CHARACTER
    FIELD valor         AS CHARACTER
    INDEX id_principal  AS PRIMARY UNIQUE
        tipo
        nome
        nome-pai.


/* Temp-table utilizada pelo programa CDAPI344 */
DEFINE TEMP-TABLE tt-versao-integr NO-UNDO
    FIELD cod-versao-integracao AS INTEGER FORMAT "999"
    FIELD ind-origem-msg        AS INTEGER FORMAT "99" /* i01mp900.i */.

/* Temp-table utilizada pelo programa CDAPI344 */
DEFINE TEMP-TABLE tt-erros-geral NO-UNDO
    FIELD identif-msg           AS CHAR    FORMAT "x(60)"
    FIELD num-sequencia-erro    AS INTEGER FORMAT "999"
    FIELD cod-erro              AS INTEGER FORMAT "99999"   
    FIELD des-erro              AS CHAR    FORMAT "x(60)"
    FIELD cod-maq-origem        AS INTEGER FORMAT "999"
    FIELD num-processo          AS INTEGER FORMAT "999999999".


/* Temp-table de retorno, com as mensagens do processo */
DEFINE TEMP-TABLE tt-mensagem NO-UNDO
    FIELD tip-msgs AS INTEGER   FORMAT ">9":U INITIAL 1
    FIELD mensagem AS CHARACTER FORMAT "x(250)":U.

