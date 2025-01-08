/**************************************************************************************************
** PROGRAMA...: espnfse2010.i - Definicao de TEMP-TABLEs para exportacao de RPS para CW-NFSe
** AUTOR......: Ivonei Vock - CW
** DATA.......: 01/09/2010
** ATUALIZACAO: 17/09/2012
**************************************************************************************************/

/** TEMP-TABLE: Parametros **/
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INT
    FIELD arquivo          AS CHAR FORMAT "x(35)":U
    FIELD usuario          AS CHAR FORMAT "x(12)":U
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INT
    FIELD classifica       AS INT
    FIELD desc-classifica  AS CHAR FORMAT "x(40)":U
    FIELD cod-estabel-ini  AS CHAR
    FIELD cod-estabel-fim  AS CHAR
    FIELD serie-ini        AS CHAR
    FIELD serie-fim        AS CHAR
    FIELD nr-rps-ini       AS CHAR
    FIELD nr-rps-fim       AS CHAR
    FIELD dt-emis-ini      AS DATE
    FIELD dt-emis-fim      AS DATE
    FIELD enviados         AS LOG
    FIELD cancelados       AS LOG 
    FIELD erros            AS LOG
    FIELD versao           AS CHAR
    FIELD arquivo-exp      AS CHAR
    FIELD nat-oper-ini     AS CHAR
    FIELD nat-oper-fim     AS CHAR.

/** TEMP-TABLE: RPS **/
DEFINE TEMP-TABLE tt-rps NO-UNDO
    FIELD id-transacao          AS INT  /*1 emissao, 3 cancelar*/
    FIELD serie                 LIKE nota-fiscal.serie
    FIELD cod-estabel           LIKE nota-fiscal.cod-estabel
    FIELD nr-rps                LIKE nota-fiscal.nr-nota-fis
    FIELD dt-emis-rps           LIKE nota-fiscal.dt-emis-nota
    FIELD cod-emitente          LIKE emitente.cod-emitente
    FIELD cod-servico           AS INT
    FIELD desc-servico          AS CHAR
    FIELD observ-nota           AS CHAR
    FIELD desc-fatura           AS CHAR
    FIELD cod-prestador         AS INT  FORMAT ">>9"
    FIELD nat-op-municipal      AS CHAR FORMAT "x(4)"
    FIELD estab-ibge            AS INT  FORMAT ">>>>>>>9"
    FIELD estab-cgc             AS CHAR FORMAT "x(14)"
    FIELD servico-ibge          AS INT  FORMAT ">>>>>>>9"
    FIELD cli-pessoa            AS INT  FORMAT ">" /*1-PF, 0-PJ EXT TRD*/
    FIELD cli-cgc               AS CHAR FORMAT "x(14)"
    FIELD cli-razao             AS CHAR FORMAT "x(60)"
    FIELD cli-end-rua           AS CHAR FORMAT "x(75)"
    FIELD cli-end-numero        AS CHAR FORMAT "x(09)"
    FIELD cli-end-bairro        AS CHAR FORMAT "x(40)"
    FIELD cli-end-complemento   AS CHAR
    FIELD cli-end-cidade        AS CHAR FORMAT "x(40)"
    FIELD cli-end-estado        AS CHAR FORMAT "x(02)"
    FIELD cli-end-cep           AS CHAR FORMAT "x(08)"
    FIELD cli-email             AS CHAR
    FIELD cli-ibge              AS INT  FORMAT ">>>>>>>9"
    FIELD cli-ins-municipal     LIKE emitente.ins-municipal
    FIELD cli-ins-estadual      LIKE emitente.ins-estadual
    FIELD cli-telefone          AS CHAR FORMAT "x(15)"
    FIELD cli-ddd               AS CHAR FORMAT "x(03)"
    FIELD cli-logradouro        AS CHAR FORMAT "x(10)"
    FIELD cli-pais              AS CHAR FORMAT "x(05)"
    FIELD aliq-iss              AS DEC  FORMAT ">>9.99"
    FIELD aliq-irrf             AS DEC  FORMAT ">>9.99"
    FIELD aliq-pis              AS DEC  FORMAT ">>9.99"
    FIELD aliq-cofins           AS DEC  FORMAT ">>9.99"
    FIELD aliq-csll             AS DEC  FORMAT ">>9.99"
    FIELD aliq-inss             AS DEC  FORMAT ">>9.99"
    FIELD vl-irf                AS DEC  FORMAT ">>>>>>>9.99"
    FIELD vl-pis                AS DEC  FORMAT ">>>>>>>9.99"
    FIELD vl-cofins             AS DEC  FORMAT ">>>>>>>9.99"
    FIELD vl-csll               AS DEC  FORMAT ">>>>>>>9.99"
    FIELD vl-iss                AS DEC  FORMAT ">>>>>>>9.99"
    FIELD vl-inss               AS DEC  FORMAT ">>>>>>>9.99"
    FIELD vl-iss-retido         AS DEC  FORMAT ">>>>>>>9.99"
    FIELD i-iss-retido          AS INT  /*0-NAO, 1-SIM*/
    FIELD vl-iss-base           AS DEC  FORMAT ">>>>>>>9.99"
    FIELD vl-servico            AS DEC  FORMAT ">>>>>>>9.99"
    FIELD vl-deducao            AS DEC  FORMAT ">>>>>>>9.99"
    FIELD vl-desconto           AS DEC  FORMAT ">>>>>>>9.99"
    FIELD vl-retencoes          AS DEC  FORMAT ">>>>>>>9.99"
    FIELD motivo-cancela        AS CHAR FORMAT "x(150)"
    FIELD i-status-conv         AS INT  /*0-NAO ENVIADO (NOVA RPS E SUBSTITUICAO, 4-CANCELADO (CENCELAR RPS SEM CONVERSAO)*/
    FIELD nr-nota-subs          AS CHAR
    FIELD string_livre_1        AS CHAR FORMAT "x(256)"
    FIELD string_livre_2        AS CHAR FORMAT "x(256)"
    FIELD string_livre_3        AS CHAR FORMAT "x(256)"
    FIELD serie-ext             LIKE nota-fiscal.serie       INITIAL ""
    FIELD nr-rps-ext            LIKE nota-fiscal.nr-nota-fis INITIAL ""
    FIELD vl-desconto-incond    AS DEC  FORMAT ">>>>>>>9.99"
    FIELD int-tipo              AS CHAR FORMAT "x(1)"        INITIAL ""
    FIELD int-cgc               AS CHAR FORMAT "x(14)"       INITIAL ""
    FIELD int-razao             AS CHAR FORMAT "x(115)"      INITIAL ""
    FIELD int-ins-municipal     AS CHAR FORMAT "x(15)"       INITIAL ""
    FIELD cod-obra              AS CHAR FORMAT "x(15)"       INITIAL ""
    FIELD cod-art               AS CHAR FORMAT "x(15)"       INITIAL ""
    FIELD cli-tipo-endereco     AS CHAR FORMAT "x(255)"      INITIAL ""
    FIELD serv-cd-servico       AS CHAR FORMAT "x(255)"      INITIAL ""
    FIELD serv-item-lista       AS CHAR FORMAT "x(255)"      INITIAL ""
    FIELD serv-cnae             AS CHAR FORMAT "x(255)"      INITIAL ""
    FIELD estab-ins             AS CHAR FORMAT "x(15)"       INITIAL ""
    FIELD rps-mail-cli          AS CHAR FORMAT "x(100)"      INITIAL ""
    FIELD dt-competencia        AS DATE
    FIELD resp-retencao         AS INT  FORMAT ">"
    FIELD ibge-incidencia       AS INT  FORMAT ">>>>>>>"
    FIELD cod-pais              AS CHAR FORMAT "x(2)"        INITIAL ""
    FIELD nr-proc-susp-exig     AS CHAR FORMAT "x(30)"       INITIAL ""
    FIELD estab-razao           AS CHAR FORMAT "x(80)"       INITIAL ""
    FIELD estab-endereco        AS CHAR FORMAT "x(35)"       INITIAL ""
    FIELD estab-complemento     AS CHAR FORMAT "x(35)"       INITIAL ""
    FIELD estab-numero          AS CHAR FORMAT "x(09)"       INITIAL "0"
    FIELD estab-bairro          AS CHAR FORMAT "x(15)"       INITIAL ""
    FIELD estab-cep             AS CHAR FORMAT "x(08)"       INITIAL ""
    FIELD estab-estado          AS CHAR FORMAT "x(02)"       INITIAL ""
    FIELD estab-ddd             AS CHAR FORMAT "x(03)"       INITIAL ""
    FIELD estab-telefone        AS CHAR FORMAT "x(09)"       INITIAL ""
    FIELD estab-email           AS CHAR FORMAT "x(80)"       INITIAL ""
    FIELD estab-reg-espec-trib  AS CHAR FORMAT "x(02)"       INITIAL ""
    FIELD estab-optante-simples AS CHAR FORMAT "x(01)"       INITIAL ""
    FIELD estab-incent-cultural AS CHAR FORMAT "x(01)"       INITIAL ""
    FIELD subst-serie           AS CHAR FORMAT "x(05)"       INITIAL ""
    FIELD subst-nr-rps          AS CHAR FORMAT "x(15)"       INITIAL ""
    FIELD nr-nfse               AS CHAR FORMAT "x(16)"       INITIAL ""
    FIELD cd-verificacao        AS CHAR FORMAT "x(16)"       INITIAL ""
    INDEX ch-unico AS UNIQUE AS PRIMARY
          serie
          cod-estabel
          nr-rps
          id-transacao.


/** TEMP-TABLE: ITENS DA RPS **/
DEFINE TEMP-TABLE tt-rps-item NO-UNDO
    FIELD serie               LIKE nota-fiscal.serie
    FIELD cod-estabel         LIKE nota-fiscal.cod-estabel
    FIELD nr-rps              LIKE nota-fiscal.nr-nota-fis
    FIELD it-codigo           LIKE it-nota-fisc.it-codigo
    FIELD nr-seq-fat          LIKE it-nota-fisc.nr-seq-fat
    FIELD desc-item           LIKE item.desc-item
    FIELD desc-servico        AS CHAR
    FIELD desc-vl-item        AS CHAR
    FIELD quantidade          LIKE it-nota-fisc.qt-fatura[1]
    FIELD vl-preuni           LIKE it-nota-fisc.vl-preuni
    FIELD vl-tot-item         LIKE it-nota-fisc.vl-tot-item
    FIELD vl-deducao          LIKE it-nota-fisc.vl-preuni
    FIELD vl-base-iss         LIKE it-nota-fisc.vl-biss-it
    FIELD un-medida           LIKE it-nota-fisc.un-fatur
    FIELD vl-irf              AS DEC FORMAT ">>>>>>>9.99"
    FIELD vl-pis              AS DEC FORMAT ">>>>>>>9.99"
    FIELD vl-cofins           AS DEC FORMAT ">>>>>>>9.99"
    FIELD vl-csll             AS DEC FORMAT ">>>>>>>9.99"
    FIELD vl-iss              AS DEC FORMAT ">>>>>>>9.99"
    FIELD vl-inss             AS DEC FORMAT ">>>>>>>9.99"
    FIELD vl-iss-ret          AS DEC FORMAT ">>>>>>>9.99"
    FIELD serie-ext           LIKE nota-fiscal.serie       INITIAL ""
    FIELD nr-rps-ext          LIKE nota-fiscal.nr-nota-fis INITIAL ""
    INDEX ch-unico AS UNIQUE AS PRIMARY
          serie
          cod-estabel
          nr-rps
          it-codigo
          nr-seq-fat.


/** TEMP-TABLE: TRATAMENTO DE ERROS **/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD seq         AS INT
    FIELD cod-estabel LIKE nota-fiscal.cod-estabel
    FIELD nr-rps      LIKE nota-fiscal.nr-nota-fis
    FIELD serie       LIKE nota-fiscal.serie
    FIELD cod-erro    AS CHAR FORMAT "x(04)"
    FIELD des-erro    AS CHAR FORMAT "x(90)"
    INDEX ch-unico AS PRIMARY
          seq.

