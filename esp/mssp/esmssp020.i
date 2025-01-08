/*------------------------------------------------------------------------
    File        : ESMSSP020.I
    Purpose     : Consulta Item - Procedure: consultaItem
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    Created     : Junho de 2012
    Notes       : <none>
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-item NO-UNDO
    FIELD it-codigo        LIKE item.it-codigo                              /* C¢digo do Item              */
    FIELD un               LIKE item.un                                     /* Unidade de Medida           */
    FIELD desc-item        LIKE item.desc-item                              /* Descri‡Æo do Item           */
    FIELD desc-inter       LIKE item.desc-inter                             /* Desc. em Inglˆs             */
    FIELD cod-estabel      LIKE item.cod-estabel                            /* C¢digo do Estabelecimento   */
    FIELD fm-codigo        LIKE item.fm-codigo                              /* Fam¡lia Material            */
    FIELD desc-fam-mat     LIKE familia.descricao                           /* Descri‡Æo Fam¡lia Material  */
    FIELD class-fiscal     LIKE item.class-fiscal                           /* NCM                         */
    FIELD des-class-fiscal LIKE classif-fisc.descricao                      /* Descri‡Æo NCM               */
    FIELD narrativa        LIKE item.narrativa                              /* Narrativa                   */
    FIELD narrat-manaus    LIKE item.narrativa                              /* Narrativa Manaus            */
    FIELD responsavel      LIKE item.responsavel                            /* Respons vel                 */
    FIELD peso-liquido     LIKE item.peso-liquido                           /* Peso L¡quido                */
    FIELD peso-bruto       LIKE item.peso-bruto                             /* Peso Bruto                  */
    FIELD comprim          LIKE item.comprim                                /* Comprimento                 */
    FIELD largura          LIKE item.largura                                /* Largura                     */
    FIELD altura           LIKE item.altura                                 /* Altura                      */
    FIELD cd-folh-item     LIKE item.cd-folh-item                           /* Folha Especifica‡Æo         */
    FIELD ind-serv-mat     LIKE item.ind-serv-mat                           /* Aplica‡Æo                   */
    FIELD tipo-contr       LIKE item.tipo-contr                             /* Tipo de Controle            */
    FIELD ge-codigo        LIKE item.ge-codigo                              /* Grupo de Estoque            */
    FIELD contr-qualid     LIKE item.contr-qualid                           /* Controle de Qualidade       */
    FIELD fraciona         LIKE item.fraciona                               /* Quantidade Fracionada       */
    FIELD criticidade      LIKE item.criticidade                            /* Criticidade                 */
    FIELD fm-cod-com       LIKE item.fm-cod-com                             /* Fam¡lia Comercial           */
    FIELD desc-fam-com     LIKE fam-comerc.descricao                        /* Descri‡Æo Fam¡lia Comercial */
    FIELD perc-nqa         LIKE item.perc-nqa                               /* NQA                         */
    FIELD cd-planejado     LIKE item.cd-planejado                           /* Planejador                  */
    FIELD reporte-ggf      LIKE item.reporte-ggf                            /* Reporte GGF                 */
    FIELD destaq-ncm       LIKE int-item.destaque                           /* Destaque NCM                */
    FIELD desc-dest-ncm    LIKE destaque-classif-fisc.descricao             /* Descri‡Æo Destaque NCM      */
    FIELD perc-gatt        LIKE int-item.perc-gatt                          /* Percentual GATT             */
    FIELD ex-tarifario     LIKE int-item.ex-tarifario                       /* Ex Tarif rio                */
    FIELD nve              LIKE int-item.nve                                /* NVE                         */
    FIELD seq-suframa      LIKE int-item.seq-suframa                        /* Sequˆncia SUFRAMA           */
    FIELD tipo-item        AS CHARACTER FORMAT "x(2)":U LABEL "Tipo Item":U /* Tipo do Item                */
    FIELD versao           AS DECIMAL                                       /* VersÆo                      */
    FIELD data-versao      AS DATE                                          /* Data de VersÆo              */
    FIELD cod-acond        AS CHARACTER                                     /* Acondicionamento            */
    FIELD des-acond        AS CHARACTER                                     /* Descri‡Æo Acondicionamento  */
    FIELD cod-amost        AS INTEGER                                       /* Amostragem                  */
    FIELD des-amost        AS CHARACTER                                     /* Descri‡Æo Amostragem        */
    FIELD inf-adic         AS CHARACTER                                     /* Informa‡äes Adicionais      */
    FIELD un-neg           AS CHARACTER                                     /* Descri‡Æo da Unid Neg¢cio   */
    FIELD aliquota-ii      LIKE item.aliquota-ii                            /* Al¡quota Imposto Importa‡Æo */
    FIELD aliquota-ipi     LIKE item.aliquota-ipi                           /* Al¡quota IPI                */
    FIELD aliquota-pis     AS DECIMAL                                       /* Al¡quota PIS                */
    FIELD aliquota-cofins  AS DECIMAL                                       /* Al¡quota COFINS             */
    FIELD log-necessita-li LIKE item.log-necessita-li                       /* Necessita LI?               */
    FIELD log-antidumping  LIKE int-item.log-antidumping     /* Tem Antidumping             */
    FIELD obs-antidumping  LIKE int-item.obs-antidumping     /* Observa‡Æo Antidumping      */
    FIELD cest             LIKE sit-tribut-relacto.cdn-sit-tribut INITIAL 0 FORMAT ">>>>>>9"
    INDEX idx-item IS PRIMARY UNIQUE
        it-codigo.

DEFINE TEMP-TABLE tt-item-fabric NO-UNDO
    FIELD cod-fabric LIKE item-fabric.cod-fabric
    FIELD nome-abrev LIKE fabricante.nome-abrev
    FIELD it-codigo  LIKE item-fabric.it-codigo
    FIELD it-fabric  LIKE item-fabric.it-fabric
    FIELD referencia LIKE item-fabric.referencia
    INDEX idx-item-fabric IS PRIMARY UNIQUE
        it-codigo
        cod-fabric
    INDEX idx-fabric-item IS UNIQUE
        cod-fabric
        it-codigo.

DEFINE TEMP-TABLE tt-mensagem NO-UNDO
    FIELD sequencia   AS INTEGER   FORMAT ">>>>9":U LABEL "Sequˆncia":U     COLUMN-LABEL "Seq":U
    FIELD codigo      LIKE cadast_msg.cdn_msg
    FIELD tipo        AS CHARACTER FORMAT "x(20)":U LABEL "Tipo Mensagem":U COLUMN-LABEL "Tipo Msg":U
    FIELD mensagem    LIKE cadast_msg.des_text_msg 
    FIELD complemento LIKE cadast_msg.dsl_help_msg
    INDEX chPrimaria IS PRIMARY UNIQUE
        sequencia
    INDEX chCodigo
        sequencia
        codigo
    INDEX chTipo
        sequencia
        tipo.
