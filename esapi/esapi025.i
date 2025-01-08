DEFINE TEMP-TABLE tt-item-json NO-UNDO
       //FIELD reporte-ggf      LIKE item.reporte-ggf   
       FIELD codItem         LIKE item.it-codigo              /*  C¢digo do Item             */  /* ESTA NO JSON */
       FIELD un              LIKE item.un                     /*  Unidade de Medida          */  /* ESTA NO JSON */
       FIELD descItem        LIKE item.desc-item              /*  Descri‡Æo do Item          */  /* ESTA NO JSON */
       FIELD descInter       LIKE item.desc-inter             /*  Desc. em Inglˆs            */  /* ESTA NO JSON */
       FIELD codEstabel      LIKE item.cod-estabel            /*  C¢digo do Estabelecimento  */  /* ESTA NO JSON */
       FIELD fmCodigo        LIKE item.fm-codigo              /*  Fam¡lia Material           */  /* ESTA NO JSON */
       FIELD fmCodigoOri     LIKE item.fm-codigo              /*  Fam¡lia Material           */  /* ESTA NO JSON */
       FIELD fmTrib          LIKE item.fm-codigo              /*  Familia Tributaria*/
       FIELD classFiscal     LIKE item.class-fiscal           /*  NCM                        */  /* ESTA NO JSON */
       FIELD narrativa       LIKE item.narrativa              /*  Narrativa                  */
       FIELD responsavel     LIKE item.responsavel            /*  Respons vel                */
       FIELD pesoLiquido     LIKE item.peso-liquido           /*  Peso L¡quido               */  /* ESTA NO JSON */
       FIELD pesoBruto       LIKE item.peso-bruto             /*  Peso Bruto                 */  /* ESTA NO JSON */
       FIELD comprim         LIKE item.comprim                /*  Comprimento                */
       FIELD largura         LIKE item.largura                /*  Largura                    */
       FIELD altura          LIKE item.altura                 /*  Altura                     */
       FIELD folhaEspecif    LIKE item.cd-folh-item           /*  Folha Especifica‡Æo        */
       FIELD servMat         LIKE item.ind-serv-mat           /*  Aplica‡Æo                  */
       FIELD tipoControle    LIKE item.tipo-contr             /*  Tipo de Controle           */
       FIELD grEstoque       LIKE item.ge-codigo              /*  Grupo de Estoque           */
       FIELD contrQualid     LIKE item.contr-qualid           /*  Controle de Qualidade      */
       FIELD fraciona        LIKE item.fraciona               /*  Quantidade Fracionada      */
       FIELD criticidade     LIKE item.criticidade            /*  Criticidade                */
       FIELD famComerc       LIKE item.fm-cod-com             /*  Fam¡lia Comercial          */
       FIELD percNQA         LIKE item.perc-nqa               /*  NQA                        */
       FIELD cdPlanejador    LIKE item.cd-planejado           /*  Planejador                 */
       FIELD destaqNCM       LIKE int-item.destaque           /*  Destaque NCM               */
       FIELD percGATT        LIKE int-item.perc-gatt          /*  Percentual GATT            */
       FIELD exTarifario     LIKE int-item.ex-tarifario       /*  Ex Tarif rio               */
       FIELD nve             LIKE int-item.nve                /*  NVE                        */
       FIELD seqSuframa      LIKE int-item.seq-suframa        /*  Sequˆncia SUFRAMA          */
       FIELD tipoItem        AS CHARACTER FORMAT "x(02)"      /*  Tipo do Item               */
       FIELD versao          AS DECIMAL                       /*  VersÆo                     */
       FIELD dataVersao      AS DATE                          /*  Data de VersÆo             */
       FIELD codAcond        AS CHARACTER                     /*  Acondicionamento           */
       FIELD desAcond        AS CHARACTER                     /*  Descri‡Æo Acondicionamento */
       FIELD codAmost        AS INTEGER                       /*  Amostragem                 */
       FIELD desAmost        AS CHARACTER                     /*  Descri‡Æo Amostragem       */
       FIELD infAdic         AS CHARACTER                     /*  Informa‡äes Adicionais     */
       FIELD unNeg           AS INTEGER                       /*  Unid Neg¢cio               */
       FIELD cod-unid-neg    AS CHAR                          /*  Unid Neg¢cio Datasul       */
       FIELD aliquotaII      LIKE item.aliquota-ii            /*  Al¡quota Imposto Importa‡Æo */
       FIELD aliquotaIPI     LIKE item.aliquota-ipi           /*  Al¡quota IPI                */  
       FIELD aliquotaPIS     AS DECIMAL                       /*  Al¡quota PIS                */
       FIELD aliquotaCOFINS  AS DECIMAL                       /*  Al¡quota COFINS             */
       FIELD necessitaLI     LIKE item.log-necessita-li       /*  Necessita LI?               */
       FIELD antidumping     LIKE int-item.log-antidumping    /*  Tem Antidumping             */
       FIELD obsAntidumping  LIKE int-item.obs-antidumping    /*  Observa‡Æo Antidumping      */
       FIELD cest            LIKE sit-tribut.cdn-sit-tribut INITIAL 0                 /* CEST */
       FIELD origem          LIKE ITEM.codigo-orig            /*  Codigo Origem               */
       FIELD leiInformatica  AS LOG                           /* Item de lei da Informatica   */
       FIELD desc-comp-item          AS CHAR
       FIELD desc-venda              AS CHAR
       FIELD desc-ingles             AS CHAR
       FIELD usuario                 AS CHAR

       FIELD tipo-ex                 AS CHAR
       FIELD ato-legal-ex            AS CHAR
       FIELD ato-num-ex              AS INT
       FIELD orgao-emis-ex           AS CHAR
       FIELD ano-ex                  AS INT
       FIELD aliquotaPIS-imp         AS DEC
       FIELD aliquotaCOFINS-imp      AS DEC
       FIELD narrativa-manaus        AS CHAR 
       FIELD faturavel               AS LOG
       FIELD ped-energia             AS CHAR

       FIELD FabricaItem             AS CHAR 
       FIELD ProjetoSuframa          AS CHAR

       FIELD ItemOrigin              AS CHAR
       FIELD ItemOrigin2             AS CHAR

       FIELD lei-116                 AS CHAR
       FIELD lei-116-sub             AS CHAR
       FIELD resum-ingles            AS CHAR
       FIELD meses-valid             AS CHAR
       FIELD qtde-prod-emb           AS DEC
       FIELD compr-emb               AS DEC
       FIELD larg-emb                AS DEC
       FIELD altura-emb              AS DEC
       FIELD ex-ipi                  AS CHAR
       FIELD pais-ori                AS CHAR.

DEFINE TEMP-TABLE tt-item-fabric NO-UNDO
    FIELD cod-fabric LIKE item-fabric.cod-fabric
    FIELD it-fabric  LIKE item-fabric.it-fabric
    FIELD referencia LIKE item-fabric.referencia.

DEFINE TEMP-TABLE tt-proj-suframa
    FIELD nr-projeto  AS INT
    FIELD seq-suframa AS INT
    FIELD controlado  AS LOG.

/* Temp-table de retorno, com as mensagens do processo */
DEFINE TEMP-TABLE tt-mensagem-2 NO-UNDO
    FIELD tip-msgs   AS INTEGER   FORMAT ">9":U INITIAL 1
    FIELD informacao AS CHARACTER FORMAT "x(250)"
    FIELD mensagem   AS CHARACTER FORMAT "x(250)":U.





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

