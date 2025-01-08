/******************************************************************************
**  Programa.: ESCRM001.I
**  Objetivo.: Defini‡äes das temp-tables de integra‡Æo do Datasul EMS 2 com o
**             Microsoft CRM Dynamics.
**  Autor....: Gustavo Eduardo Tamanini - Exponencial TI - 27.07.2010
**             Fabiano Sakae Ribeiro    - Exponencial TI - 02.08.2010
*******************************************************************************/

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino             AS INTEGER
    FIELD arquivo             AS CHARACTER FORMAT "x(35)":U
    FIELD usuario             AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec           AS DATE
    FIELD hora-exec           AS INTEGER
    FIELD classifica          AS INTEGER
    FIELD desc-classifica     AS CHARACTER FORMAT "x(40)":U
    FIELD l-canal-venda       AS LOGICAL
    FIELD l-cond-pagto        AS LOGICAL
    FIELD l-grp-cli           AS LOGICAL
    FIELD l-portador          AS LOGICAL
    FIELD l-receita-padrao    AS LOGICAL
    FIELD l-representante     AS LOGICAL
    FIELD l-transportadora    AS LOGICAL
    FIELD l-familia-estoq     AS LOGICAL
    FIELD l-familia-comercial AS LOGICAL
    FIELD l-grupo-estoque     AS LOGICAL
    FIELD l-produto           AS LOGICAL
    FIELD l-estrut-prod       AS LOGICAL
    FIELD l-tb-preco          AS LOGICAL
    FIELD l-rota              AS LOGICAL
    FIELD l-estabelec         AS LOGICAL
    FIELD l-tb-finan          AS LOGICAL
    FIELD l-nat-oper          AS LOGICAL
    FIELD l-mensagem          AS LOGICAL
    FIELD l-emitente          AS LOGICAL
    FIELD l-contato           AS LOGICAL
    FIELD l-local-entrega     AS LOGICAL
    FIELD l-relac-cliente     AS LOGICAL
    FIELD l-pedido            AS LOGICAL
    FIELD l-nf                AS LOGICAL
    FIELD l-titulo            AS LOGICAL
    FIELD l-crm-emitente      AS LOGICAL
    FIELD l-crm-contato       AS LOGICAL
    FIELD l-crm-local-entrega AS LOGICAL
    FIELD l-crm-relac-cliente AS LOGICAL
    field l-cep               as logical
    FIELD l-cidade            AS LOGICAL
    FIELD l-unid-feder        AS LOGICAL
    field l-ocorrencia        as logical
    FIELD l-encerrar-programa AS LOGICAL
    FIELD dt-ini-pedido       AS DATE
    FIELD dt-fim-pedido       AS DATE
    FIELD dt-ini-nota         AS DATE
    FIELD dt-fim-nota         AS DATE
    FIELD automatico          AS LOGICAL.

DEFINE TEMP-TABLE tt-integrationlog NO-UNDO 
    FIELD logId            AS INTEGER
    FIELD origin           AS CHARACTER
    FIELD entity           AS CHARACTER
    FIELD action           AS CHARACTER
    FIELD cMessage         AS CHARACTER
    FIELD messageDate      AS DATETIME
    FIELD cStatus          AS CHARACTER
    FIELD processingDate   AS DATETIME
    FIELD cResult          AS CHARACTER.

DEFINE TEMP-TABLE tt-integrationlogAux NO-UNDO LIKE tt-integrationlog.

DEFINE TEMP-TABLE tt-atributo NO-UNDO
    FIELD r-temp-table AS ROWID
    FIELD nome-campo   AS CHARACTER
    FIELD nome-atrib   AS CHARACTER
    FIELD vl-atrib     AS CHARACTER
    INDEX id-campo AS PRIMARY UNIQUE
        r-temp-table
        nome-campo
        nome-atrib.

DEFINE TEMP-TABLE tt-atributo-entrada NO-UNDO
    FIELD tipo     AS CHARACTER
    FIELD nome     AS CHARACTER
    FIELD nome-pai AS CHARACTER
    FIELD valor AS CHARACTER
    INDEX id_principal AS PRIMARY UNIQUE
        tipo
        nome
        nome-pai.

DEFINE TEMP-TABLE tt-canal-venda NO-UNDO
    FIELD cod-canal-venda LIKE canal-venda.cod-canal-venda
    FIELD descricao       LIKE canal-venda.descricao.

DEFINE TEMP-TABLE tt-cond-pagto NO-UNDO
    FIELD cod-cond-pag     LIKE cond-pagto.cod-cond-pag
    FIELD descricao        LIKE cond-pagto.descricao
    FIELD ind-situacao     LIKE cond-pagto.ind-situacao
    FIELD num-parcelas     LIKE cond-pagto.num-parcelas
    FIELD per-des-pgan     LIKE cond-pagto.per-des-pgan
    FIELD new_suppliercard AS LOGICAL.

DEFINE TEMP-TABLE tt-gr-cli NO-UNDO
    FIELD cod-gr-cli LIKE gr-cli.cod-gr-cli
    FIELD descricao  LIKE gr-cli.descricao.

DEFINE TEMP-TABLE tt-portador NO-UNDO
    FIELD cod-portador LIKE mgcad.portador.cod-portador
    FIELD nome         LIKE mgcad.portador.nome.

DEFINE TEMP-TABLE tt-receita-padrao NO-UNDO
    FIELD tp-codigo LIKE tipo-rec-desp.tp-codigo
    FIELD descricao LIKE tipo-rec-desp.descricao.

DEFINE TEMP-TABLE tt-repres NO-UNDO
    FIELD cod-rep    LIKE repres.cod-rep   
    FIELD nome       LIKE repres.nome      
    FIELD nome-abrev LIKE repres.nome-abrev
    FIELD natureza   LIKE repres.natureza  
    FIELD cep        LIKE repres.cep       
    FIELD endereco   LIKE repres.endereco  
    FIELD bairro     LIKE repres.bairro    
    FIELD cidade     LIKE repres.cidade    
    FIELD estado     LIKE repres.estado    
    FIELD pais       LIKE repres.pais      
    FIELD telefone   LIKE repres.telefone[1]  
    FIELD e-mail     LIKE repres.e-mail    
    FIELD home-page  LIKE repres.home-page 
    FIELD state      LIKE repres.ind-situacao.

DEFINE TEMP-TABLE tt-transportadora NO-UNDO
    FIELD cod-transp LIKE transporte.cod-transp    
    FIELD nome       LIKE transporte.nome          
    FIELD nome-abrev LIKE transporte.nome-abrev.

DEFINE TEMP-TABLE tt-familia-material NO-UNDO
    FIELD fm-codigo LIKE familia.fm-codigo
    FIELD descricao LIKE familia.descricao.

DEFINE TEMP-TABLE tt-familia-comercial NO-UNDO
    FIELD fm-cod-com LIKE fam-comerc.fm-cod-com
    FIELD descricao  LIKE fam-comerc.descricao.

DEFINE TEMP-TABLE tt-new_unidade_familia NO-UNDO
    FIELD codigo AS CHAR
    FIELD descricao   LIKE fam-comerc.descricao.

DEFINE TEMP-TABLE tt-new_segmento NO-UNDO
    FIELD codigo      AS CHAR
    FIELD descricao   LIKE fam-comerc.descricao
    FIELD unidade     AS CHAR.

DEFINE TEMP-TABLE tt-new_familia NO-UNDO
    FIELD codigo       AS CHAR
    FIELD descricao    LIKE fam-comerc.descricao
    FIELD segmento     AS CHAR.

DEFINE TEMP-TABLE tt-new_subfamilia NO-UNDO
    FIELD codigo AS CHAR
    FIELD descricao    LIKE fam-comerc.descricao
    FIELD familia    AS CHAR.

DEFINE TEMP-TABLE tt-new_origem NO-UNDO
    FIELD codigo AS CHAR
    FIELD descricao    LIKE fam-comerc.descricao
    FIELD subfamilia    AS CHAR.


DEFINE TEMP-TABLE tt-grup-estoque NO-UNDO
    FIELD ge-codigo LIKE grup-estoque.ge-codigo
    FIELD descricao LIKE grup-estoque.descricao.

DEFINE TEMP-TABLE tt-item NO-UNDO
    FIELD it-codigo             LIKE item.it-codigo
    FIELD desc-item             LIKE item.desc-item
    FIELD un                    LIKE item.un
    FIELD compr-fabric          LIKE item.compr-fabric
    FIELD ge-codigo             LIKE item.ge-codigo
    FIELD fm-codigo             LIKE item.fm-codigo
    FIELD fm-cod-com            LIKE item.fm-cod-com
    FIELD defaultuomscheduleid  AS CHARACTER
    FIELD cod-obsoleto          LIKE item.cod-obsoleto
    FIELD pricelevelid          AS CHARACTER
    FIELD transactioncurrencyid AS CHARACTER
    FIELD unidade               AS CHARACTER
    FIELD segmento              AS CHARACTER
    FIELD familia               AS CHARACTER
    FIELD subfamilia            AS CHARACTER
    FIELD origem                AS CHARACTER.

DEFINE TEMP-TABLE tt-estrutura NO-UNDO
    FIELD it-codigo                 LIKE estrutura.it-codigo                
    FIELD sequencia                 LIKE estrutura.sequencia                
    FIELD es-codigo                 LIKE estrutura.es-codigo                
    FIELD fantasma                  LIKE estrutura.fantasma                 
    FIELD revisao                   LIKE estrutura.revisao                  
    FIELD serie-inicia              LIKE estrutura.serie-inicia             
    FIELD serie-final               LIKE estrutura.serie-final              
    FIELD op-codigo                 LIKE estrutura.op-codigo                
    FIELD local-montag              LIKE estrutura.local-montag             
    FIELD fator-perda               LIKE estrutura.fator-perda              
    FIELD proporcao                 LIKE estrutura.proporcao                
    FIELD quant-usada               LIKE estrutura.quant-usada              
    FIELD data-inicio               LIKE estrutura.data-inicio              
    FIELD data-termino              LIKE estrutura.data-termino             
    FIELD observacao                LIKE estrutura.observacao               
    FIELD var-propor                LIKE estrutura.var-propor               
    FIELD cod-roteiro               LIKE estrutura.cod-roteiro              
    FIELD conc-max                  LIKE estrutura.conc-max                 
    FIELD conc-min                  LIKE estrutura.conc-min                 
    FIELD concentracao              LIKE estrutura.concentracao             
    FIELD rendimento                LIKE estrutura.rendimento               
    FIELD cod-depos                 LIKE estrutura.cod-depos                
    FIELD reap-desmont              LIKE estrutura.reap-desmont             
    FIELD log-todas-ref-item        LIKE estrutura.log-todas-ref-item       
    FIELD log-ref-estrut-disponivel LIKE estrutura.log-ref-estrut-disponivel
    FIELD qtd-item                  LIKE estrutura.qtd-item                 
    FIELD qtd-compon                LIKE estrutura.qtd-compon               
    FIELD prop-proc                 LIKE estrutura.prop-proc
    FIELD NAME                      AS CHARACTER
    FIELD new_chaveintegracao       AS CHARACTER.

DEFINE TEMP-TABLE tt-productpricelevel NO-UNDO
    FIELD pricelevelid        AS CHARACTER
    FIELD productidname       AS CHARACTER
    FIELD productid           LIKE item.it-codigo
    FIELD uomid               LIKE item.un
    FIELD quantitysellingcode AS INTEGER
    FIELD pricingmethodcode   AS INTEGER
    FIELD amount              AS DECIMAL.

DEFINE TEMP-TABLE tt-productpricelevel-atu NO-UNDO LIKE tt-productpricelevel .

DEFINE TEMP-TABLE tt-tb-preco NO-UNDO
    FIELD nr-tabpre LIKE tb-preco.nr-tabpre
    FIELD descricao LIKE tb-preco.descricao
    FIELD dt-inival LIKE tb-preco.dt-inival
    FIELD dt-fimval LIKE tb-preco.dt-fimval
    FIELD situacao  LIKE tb-preco.situacao
    FIELD mo-codigo LIKE moeda.descricao.

DEFINE TEMP-TABLE tt-preco-item NO-UNDO
    FIELD it-codigo           LIKE preco-item.it-codigo
    FIELD nr-tabpre           LIKE preco-item.nr-tabpre
    FIELD dt-inival           LIKE preco-item.dt-inival
    FIELD quant-min           LIKE preco-item.quant-min
    FIELD preco-venda         LIKE preco-item.preco-venda
    FIELD preco-fob           LIKE preco-item.preco-fob
    FIELD preco-min-cif       LIKE preco-item.preco-min-cif
    FIELD preco-min-fob       LIKE preco-item.preco-min-fob
    FIELD situacao            LIKE preco-item.situacao
    FIELD new_chaveintegracao AS CHARACTER
    FIELD preco-unico         LIKE int-preco-item.preco-unico
    FIELD pma                 LIKE int-preco-item.pma
    FIELD pmd                 LIKE int-preco-item.pmd.

DEFINE TEMP-TABLE tt-rota NO-UNDO
    FIELD cod-rota  LIKE rota.cod-rota
    FIELD descricao LIKE rota.descricao
    FIELD roteiro   LIKE rota.roteiro.

DEFINE TEMP-TABLE tt-estabelec NO-UNDO
    FIELD cod-estabel             LIKE estabelec.cod-estabel
    FIELD nome                    LIKE estabelec.nome
    FIELD id-ativo                AS INTEGER
    FIELD new_razao_social        LIKE estabelec.nome
    FIELD new_cnpj                LIKE estabelec.cgc
    FIELD new_inscricao_estadual  LIKE estabelec.ins-estadual
    FIELD new_endereco            LIKE estabelec.endereco
    FIELD new_cidade              LIKE estabelec.cidade
    FIELD new_cep                 LIKE estabelec.cep
    FIELD new_uf                  LIKE estabelec.estado.

DEFINE TEMP-TABLE tt-cidade NO-UNDO
    FIELD cidade LIKE mgcad.cidade.cidade
    FIELD estado LIKE mgcad.cidade.estado
    FIELD NEW_chave_integracao AS CHAR
    FIELD ibge   AS  INTEGER.

DEFINE TEMP-TABLE tt-unid-feder NO-UNDO
    FIELD estado LIKE unid-feder.estado
    FIELD pais   LIKE unid-feder.pais
    FIELD no-estado LIKE unid-feder.no-estado
    FIELD new_chave_integracao AS CHARACTER.

DEFINE TEMP-TABLE tt-tab-finan NO-UNDO
    FIELD nr-tab-finan LIKE tab-finan.nr-tab-finan
    FIELD dt-ini-val   LIKE tab-finan.dt-ini-val
    FIELD dt-fim-val   LIKE tab-finan.dt-fim-val.

DEFINE TEMP-TABLE tt-ind-tab-finan NO-UNDO
    FIELD nr-tab-finan        LIKE tab-finan.nr-tab-finan
    FIELD nr-ind-finan        AS INTEGER FORMAT ">9":U LABEL "Nr Seq Öndice":U HELP "N£mero do ¡ndice de financiamento":U
    FIELD tab-dia-fin         LIKE tab-finan.tab-dia-fin[1]
    FIELD tab-ind-fin         LIKE tab-finan.tab-ind-fin[1]
    FIELD new_chaveintegracao AS CHARACTER.

DEFINE TEMP-TABLE tt-natur-oper NO-UNDO
    FIELD nat-operacao LIKE natur-oper.nat-operacao
    FIELD tipo         LIKE natur-oper.tipo
    FIELD denominacao  LIKE natur-oper.denominacao
    FIELD nat-ativa    LIKE natur-oper.nat-ativa.

DEFINE TEMP-TABLE tt-mensag-crm NO-UNDO
    FIELD cod-mensagem LIKE mensagem.cod-mensagem
    FIELD descricao    LIKE mensagem.descricao
    FIELD texto-mensag LIKE mensagem.texto-mensag.

DEFINE TEMP-TABLE tt-cliente NO-UNDO
    FIELD cod-emitente             LIKE emitente.cod-emitente
    FIELD nome-emit                LIKE emitente.nome-emit
    FIELD nome-abrev               LIKE emitente.nome-abrev
    FIELD nome-matriz              LIKE emitente.cod-emitente
    FIELD identific                LIKE emitente.identific
    FIELD portador                 LIKE emitente.portador
    FIELD cod-banco                LIKE emitente.cod-banco
    FIELD agencia                  LIKE emitente.agencia
    FIELD conta-corren             LIKE emitente.conta-corren
    FIELD tp-rec-padrao            LIKE emitente.tp-rec-padrao
    FIELD cod-cond-pag             AS CHARACTER
    FIELD emite-bloq               LIKE emitente.emite-bloq
    FIELD gera-ad                  LIKE emitente.gera-ad
    FIELD calcula-multa            LIKE emitente.calcula-multa
    FIELD recebe-inf-sci           LIKE emitente.recebe-inf-sci
    FIELD address1_addresstypecode AS INT
    FIELD address1_name            AS CHAR
    FIELD CEP                      LIKE emitente.CEP
    FIELD endereco                 LIKE emitente.endereco
    FIELD Bairro                   LIKE emitente.Bairro
    FIELD Cidade                   LIKE emitente.Cidade
    FIELD Estado                   LIKE emitente.Estado
    FIELD Pais                     LIKE emitente.Pais
    FIELD address2_addresstypecode AS INT
    FIELD address2_name            AS CHAR
    FIELD cep-cob                  LIKE emitente.cep-cob                   
    FIELD endereco-cob             LIKE emitente.endereco-cob
    FIELD bairro-cob               LIKE emitente.bairro-cob
    FIELD cidade-cob               LIKE emitente.cidade-cob
    FIELD estado-cob               LIKE emitente.estado-cob
    FIELD pais-cob                 LIKE emitente.pais-cob
    FIELD telephone                LIKE emitente.telefone[1]
    FIELD ramal                    LIKE emitente.ramal[1] 
    FIELD telephone2               LIKE emitente.telefone[2]
    FIELD ramal2                   LIKE emitente.ramal[2]
    FIELD fax                      LIKE emitente.telefax  
    FIELD ramalfax                 LIKE emitente.ramal-fax 
    FIELD email                    LIKE emitente.e-mail
    FIELD home-page                LIKE emitente.home-page
    FIELD cod-rep                  LIKE emitente.cod-rep
    FIELD natureza                 LIKE emitente.natureza
    FIELD cgc                      LIKE emitente.cgc
    FIELD ins-estadual             LIKE emitente.ins-estadual
    FIELD ins-municipal            LIKE emitente.ins-municipal
    FIELD cod-gr-cli               LIKE emitente.cod-gr-cli
    FIELD lim-credito              LIKE emitente.lim-credito
    FIELD dt-lim-credito           LIKE emitente.dt-lim-cred
    FIELD modalidade               LIKE emitente.modalidade     
    FIELD contrib-icms             LIKE emitente.contrib-icms   
    FIELD cod-suframa              LIKE emitente.cod-suframa    
    FIELD cod-transp               LIKE emitente.cod-transp     
    FIELD nome-tr-red              LIKE emitente.nome-tr-red
    FIELD cod-canal-venda          LIKE emitente.cod-canal-venda
    FIELD insc-subs-trib           LIKE emitente.insc-subs-trib
    FIELD i-susp-ipi               AS LOGICAL FORMAT "Sim/NÆo":U INITIAL NO
    FIELD agente-retencao          LIKE emitente.agente-retencao
    FIELD i-calc-pis-cofins-unid   AS LOGICAL FORMAT "Sim/NÆo":U INITIAL NO
    FIELD i-recebe-nfe             AS LOGICAL FORMAT "Sim/NÆo":U INITIAL NO
    FIELD ind-forma-tributo        LIKE int-emitente.ind-forma-tributo
    FIELD vl-desconto-cat          LIKE int-emitente.vl-desconto-cat
    FIELD tipo-embalagem           LIKE int-emitente.tipo-embalagem
    FIELD observacao-ped           LIKE int-emitente.observacao-ped
    FIELD dispositivo-legal        LIKE int-emitente.dispositivo-legal
    FIELD dt-vcto-concessao        LIKE int-emitente.dt-vcto-concessao
    FIELD cod-incoterm-exp         LIKE emitente-cex.cod-incoterm-exp
    FIELD local-embarque           LIKE int-emitente-cex.local-embarque
    FIELD embarque-via             LIKE int-emitente-cex.embarque-via
    FIELD new_exporta_erp          AS CHARACTER
    FIELD new_mensagem             AS CHARACTER
    FIELD data-implant             LIKE emitente.data-implant
    FIELD new_status_integracao    AS CHARACTER
    FIELD new_status_cadastro      AS INTEGER
    FIELD id-ativo                 AS INTEGER 
    FIELD new_cpf                  AS CHARACTER
    FIELD new_rg                   AS CHARACTER
    FIELD new_sem_masc_cnpj_cpf    AS CHARACTER
    FIELD ind-vendas-alc           AS LOGICAL INITIAL NO
    FIELD donotsendmm              AS LOGICAL INITIAL NO
    FIELD donotbulkemail           AS LOGICAL INITIAL NO
    FIELD new_numero_endereco_principal AS CHARACTER
    FIELD address1_line2           AS CHARACTER
    FIELD new_numero_endereco_cobranca AS CHARACTER
    FIELD address2_line2           AS CHARACTER
    FIELD ind-participa-canais     AS CHAR
    FIELD nro-passaporte           AS CHAR .

DEFINE TEMP-TABLE tt-cont-emit NO-UNDO
    FIELD cod-emitente        LIKE cont-emit.cod-emitente
    FIELD sequencia           LIKE cont-emit.sequencia
    FIELD nome                LIKE cont-emit.nome
    FIELD cargo               LIKE cont-emit.cargo
    FIELD area                LIKE cont-emit.area
    FIELD telefone            LIKE cont-emit.telefone
    FIELD ramal               LIKE cont-emit.ramal
    FIELD telefax             LIKE cont-emit.telefax
    FIELD ramal-fax           LIKE cont-emit.ramal-fax
    FIELD e-mail              LIKE cont-emit.e-mail
    FIELD observacao          LIKE cont-emit.observacao
    FIELD identific           LIKE cont-emit.identific
    FIELD new_exporta_crm     AS CHAR
    FIELD new_chaveintegracao AS CHAR
    FIELD new_mensagem        AS CHAR
    FIELD new_status_integracao AS CHAR.
       
DEFINE TEMP-TABLE tt-loc-entr NO-UNDO
    FIELD nome-abrev          LIKE emitente.cod-emitente
    FIELD cod-entrega         LIKE loc-entr.cod-entrega
    FIELD endereco            LIKE loc-entr.endereco
    FIELD bairro              LIKE loc-entr.bairro
    FIELD cidade              LIKE loc-entr.cidade
    FIELD estado              LIKE loc-entr.estado
    FIELD cep                 LIKE loc-entr.cep
    FIELD caixa-postal        LIKE loc-entr.caixa-postal
    FIELD pais                LIKE loc-entr.pais
    FIELD cgc                 LIKE loc-entr.cgc
    FIELD ins-estadual        LIKE loc-entr.ins-estadual
    FIELD obs-entrega         LIKE loc-entr.obs-entrega
    FIELD cod-tip-ent         LIKE loc-entr.cod-tip-ent
    FIELD e-mail              LIKE loc-entr.e-mail
    FIELD cod-tax             LIKE loc-entr.cod-tax
    FIELD addresstypecode       AS INT
    FIELD objecttypecode        AS CHAR
    FIELD new_exporta_erp       AS CHAR
    FIELD new_chaveintegracao   AS CHAR
    FIELD new_mensagem          AS CHAR
    field new_status_integracao as char
    FIELD new_numero_endereco   AS CHARACTER
    FIELD line3                 AS CHARACTER.

DEFINE TEMP-TABLE tt-relacionamento-cliente NO-UNDO
    FIELD cod-emitente          LIKE crm-relacionamento-cliente.cod-emitente
    FIELD seq                   LIKE crm-relacionamento-cliente.seq
    FIELD cod-rep               LIKE crm-relacionamento-cliente.cod-rep
    FIELD cd-unid-negoc         AS CHARACTER  /* Descricao da unidade de neg¢cio */
    FIELD cd-categoria          AS INT       
    FIELD dt-vigencia-ini       AS DATE
    FIELD dt-vigencia-fim       AS DATE 
    fIELD new_exporta_ERP       AS CHARACTER
    FIELD new_chaveintegracao   AS CHARACTER
    FIELD new_mensagem          AS CHARACTER
    FIELD new_nome              AS CHARACTER
    FIELD new_status_integracao AS CHARACTER. 
    
DEFINE TEMP-TABLE tt-param-mov NO-UNDO
    field  prog-orig              as char
    FIELD  action                 AS CHAR
    FIELD  tabela-pai             as char 
    field  rw-tabela-pai          as rowid
    FIELD  tabela-filho           AS CHAR 
    field  rw-tabela-filho        as rowid    
    FIELD  iContaLinhasTracePai   AS int
    FIELD  iContaLinhasTraceFilho AS INT
    FIELD  dt-ini-pedido          AS DATE
    FIELD  dt-fim-pedido          AS DATE
    FIELD  dt-ini-nota            AS DATE  
    FIELD  dt-fim-nota            AS DATE
    FIELD  automatico             AS LOGICAL.

DEFINE TEMP-TABLE tt-ped-venda NO-UNDO
    FIELD name            LIKE ped-venda.nr-pedido
    FIELD cod-estabel     LIKE ped-venda.cod-estabel
    FIELD nome-abrev      LIKE ped-venda.nome-abrev
    FIELD nr-pedcli       LIKE ped-venda.nr-pedcli
    FIELD nr-pedido       LIKE ped-venda.nr-pedido
    FIELD nr-pedrep       LIKE ped-venda.nr-pedrep
    FIELD dt-emissao      LIKE ped-venda.dt-emissao
    FIELD dt-implant      LIKE ped-venda.dt-implant
    FIELD dt-entrega      LIKE ped-venda.dt-entrega
    FIELD dt-cancela      LIKE ped-venda.dt-cancela
    FIELD desc-cancela    LIKE ped-venda.desc-cancela
    FIELD dt-minfat       LIKE ped-venda.dt-minfat
    FIELD dt-lim-fat      LIKE ped-venda.dt-lim-fat
    FIELD dt-entorig      LIKE ped-venda.dt-entorig
    FIELD dt-reativ       LIKE ped-venda.dt-reativ
    FIELD nat-operacao    LIKE ped-venda.nat-operacao
    FIELD cod-cond-pag    LIKE ped-venda.cod-cond-pag
    FIELD nr-tabpre       LIKE ped-venda.nr-tabpre
    FIELD nr-tab-finan    LIKE ped-venda.nr-tab-finan
    FIELD tp-pedido       LIKE ped-venda.tp-pedido
    FIELD origem          LIKE ped-venda.origem
    FIELD cod-priori      LIKE ped-venda.cod-priori
    FIELD cod-entrega     LIKE ped-venda.cod-entrega
    FIELD local-entreg    LIKE ped-venda.local-entreg
    FIELD bairro          LIKE ped-venda.bairro
    FIELD cidade          LIKE ped-venda.cidade
    FIELD estado          LIKE ped-venda.estado
    FIELD cep             LIKE ped-venda.cep
    FIELD pais            LIKE ped-venda.pais
    FIELD cgc             LIKE ped-venda.cgc
    FIELD ins-estadual    LIKE ped-venda.ins-estadual
    FIELD cod-sit-ped     LIKE ped-venda.cod-sit-ped
    FIELD perc-desco1     LIKE ped-venda.perc-desco1
    FIELD perc-desco2     LIKE ped-venda.perc-desco2
    FIELD cond-redespa    LIKE ped-venda.cond-redespa
    FIELD cidade-cif      LIKE ped-venda.cidade-cif
    FIELD cod-portador    LIKE ped-venda.cod-portador
    FIELD modalidade      LIKE ped-venda.modalidade
    FIELD cod-mensagem    LIKE ped-venda.cod-mensagem
    FIELD observacoes     LIKE ped-venda.observacoes
    FIELD cond-espec      LIKE ped-venda.cond-espec
    FIELD user-impl       LIKE ped-venda.user-impl
    FIELD dt-userimp      LIKE ped-venda.dt-userimp
    FIELD user-alte       LIKE ped-venda.user-alte
    FIELD dt-useralt      LIKE ped-venda.dt-useralt
    FIELD user-canc       LIKE ped-venda.user-canc
    FIELD dt-usercan      LIKE ped-venda.dt-usercan
    FIELD user-reat       LIKE ped-venda.user-reat
    FIELD dt-userrea      LIKE ped-venda.dt-userrea
    FIELD user-suspen     LIKE ped-venda.user-suspen
    FIELD dt-usersusp     LIKE ped-venda.dt-usersusp
    FIELD ind-aprov       LIKE ped-venda.ind-aprov
    FIELD quem-aprovou    LIKE ped-venda.quem-aprovou
    FIELD dt-apr-cred     LIKE ped-venda.dt-apr-cred
    FIELD cod-des-merc    LIKE ped-venda.cod-des-merc
    FIELD nome-transp     LIKE transporte.cod-transp
    FIELD tp-preco        LIKE ped-venda.tp-preco
    FIELD ind-fat-par     LIKE ped-venda.ind-fat-par
    FIELD mo-codigo       LIKE moeda.descricao
    FIELD cod-rota        LIKE ped-venda.cod-rota
    FIELD vl-tot-ped      LIKE ped-venda.vl-tot-ped
    FIELD vl-liq-ped      LIKE ped-venda.vl-liq-ped
    FIELD vl-liq-abe      LIKE ped-venda.vl-liq-abe
    FIELD nr-ind-finan    AS CHARACTER
    FIELD user-aprov      LIKE ped-venda.user-aprov
    FIELD no-ab-reppri    LIKE repres.cod-rep
    FIELD vl-mer-abe      LIKE ped-venda.vl-mer-abe
    FIELD cod-sit-aval    LIKE ped-venda.cod-sit-aval
    FIELD desc-suspend    LIKE ped-venda.desc-suspend
    FIELD desc-bloq-cr    LIKE ped-venda.desc-bloq-cr
    FIELD desc-forc-cr    LIKE ped-venda.desc-forc-cr
    FIELD cod-emitente    LIKE ped-venda.cod-emitente
    FIELD cod-sit-pre     LIKE ped-venda.cod-sit-pre
    FIELD per-des-icms    LIKE ped-venda.per-des-icms
    FIELD vl-cred-lib     LIKE ped-venda.vl-cred-lib
    FIELD aprov-forcado   LIKE ped-venda.aprov-forcado
    FIELD cod-gr-cli      LIKE ped-venda.cod-gr-cli
    FIELD completo        LIKE ped-venda.completo
    FIELD cod-canal-venda LIKE ped-venda.cod-canal-venda
    FIELD nome-abrev-tri  LIKE emitente.cod-emitente
    FIELD cod-entrega-tri LIKE ped-venda.cod-entrega-tri
    FIELD pricelevelid    AS CHARACTER.

DEFINE TEMP-TABLE tt-ped-item NO-UNDO
    FIELD nome-abrev          LIKE ped-item.nome-abrev
    FIELD nr-pedcli           LIKE ped-item.nr-pedcli
    FIELD nr-sequencia        LIKE ped-item.nr-sequencia
    FIELD it-codigo           LIKE ped-item.it-codigo
    FIELD un                  LIKE item.un
    FIELD dt-entorig          LIKE ped-item.dt-entorig
    FIELD dt-entrega          LIKE ped-item.dt-entrega
    FIELD dt-canseq           LIKE ped-item.dt-canseq
    FIELD desc-cancela        LIKE ped-item.desc-cancela
    FIELD dt-reativ           LIKE ped-item.dt-reativ
    FIELD dt-suspensao        LIKE ped-item.dt-suspensao
    FIELD qt-pedida           LIKE ped-item.qt-pedida
    FIELD qt-atendida         LIKE ped-item.qt-atendida
    FIELD qt-pendente         LIKE ped-item.qt-pendente
    FIELD qt-devolvida        LIKE ped-item.qt-devolvida
    FIELD dt-devolucao        LIKE ped-item.dt-devolucao
    FIELD desc-devol          LIKE ped-item.desc-devol
    FIELD vl-pretab           LIKE ped-item.vl-pretab
    FIELD vl-preori           LIKE ped-item.vl-preori
    FIELD vl-preuni           LIKE ped-item.vl-preuni
    FIELD per-des-item        LIKE ped-item.per-des-item
    FIELD per-minfat          LIKE ped-item.per-minfat
    FIELD cod-sit-item        LIKE ped-item.cod-sit-item
    FIELD user-impl           LIKE ped-item.user-impl
    FIELD dt-userimp          LIKE ped-item.dt-userimp
    FIELD user-alte           LIKE ped-item.user-alte
    FIELD dt-useralt          LIKE ped-item.dt-useralt
    FIELD user-canc           LIKE ped-item.user-canc
    FIELD dt-usercan          LIKE ped-item.dt-usercan
    FIELD user-reat           LIKE ped-item.user-reat
    FIELD dt-userrea          LIKE ped-item.dt-userrea
    FIELD user-devol          LIKE ped-item.user-devol
    FIELD dt-userdev          LIKE ped-item.dt-userdev
    FIELD user-susp           LIKE ped-item.user-susp
    FIELD dt-usersusp         LIKE ped-item.dt-usersusp
    FIELD aliquota-ipi        LIKE ped-item.aliquota-ipi
    FIELD ind-icm-ret         LIKE ped-item.ind-icm-ret
    FIELD vl-merc-abe         LIKE ped-item.vl-merc-abe
    FIELD vl-liq-it           LIKE ped-item.vl-liq-it
    FIELD vl-liq-abe          LIKE ped-item.vl-liq-abe
    FIELD vl-tot-it           LIKE ped-item.vl-tot-it
    FIELD nr-tabpre           LIKE ped-item.nr-tabpre
    FIELD tp-preco            LIKE ped-item.tp-preco
    FIELD per-des-icms        LIKE ped-item.per-des-icms
    FIELD nat-operacao        LIKE ped-item.nat-operacao
    FIELD observacao          LIKE ped-item.observacao
    FIELD desc-txt            LIKE ped-item.desc-txt
    FIELD qt-alocada          LIKE ped-item.qt-alocada
    FIELD cod-sit-pre         LIKE ped-item.cod-sit-pre
    FIELD dt-max-fat          LIKE ped-item.dt-max-fat
    FIELD dt-min-fat          LIKE ped-item.dt-min-fat
    FIELD qt-log-aloca        LIKE ped-item.qt-log-aloca
    FIELD ind-fat-qtfam       LIKE ped-item.ind-fat-qtfam
    FIELD new_chaveintegracao AS CHARACTER
    FIELD nr-pedido           LIKE ped-venda.nr-pedido
    FIELD ispriceoverridden   AS INTEGER.

DEFINE TEMP-TABLE tt-nota-fiscal NO-UNDO
    FIELD cod-estabel           LIKE nota-fiscal.cod-estabel
    FIELD serie                 LIKE nota-fiscal.serie
    FIELD nr-nota-fis           LIKE nota-fiscal.nr-nota-fis
    FIELD nome-ab-cli           LIKE nota-fiscal.nome-ab-cli
    FIELD dt-emis-nota          LIKE nota-fiscal.dt-emis-nota
    FIELD ind-sit-nota          LIKE nota-fiscal.ind-sit-nota
    FIELD dt-confirma           LIKE nota-fiscal.dt-confirma
    FIELD dt-cancela            LIKE nota-fiscal.dt-cancela
    FIELD cod-cond-pag          LIKE nota-fiscal.cod-cond-pag
    FIELD nr-pedcli             LIKE nota-fiscal.nr-pedcli
    FIELD cod-entrega           LIKE nota-fiscal.cod-entrega
    FIELD endereco              LIKE nota-fiscal.endereco
    FIELD bairro                LIKE nota-fiscal.bairro
    FIELD cidade                LIKE nota-fiscal.cidade
    FIELD estado                LIKE nota-fiscal.estado
    FIELD cep                   LIKE nota-fiscal.cep
    FIELD pais                  LIKE nota-fiscal.pais
    FIELD cgc                   LIKE nota-fiscal.cgc
    FIELD ins-estadual          LIKE nota-fiscal.ins-estadual
    FIELD nome-transp           LIKE transporte.cod-transp
    FIELD vl-tot-nota           LIKE nota-fiscal.vl-tot-nota
    FIELD vl-mercad             LIKE nota-fiscal.vl-mercad
    FIELD nat-operacao          LIKE nota-fiscal.nat-operacao
    FIELD peso-liq-tot          LIKE nota-fiscal.peso-liq-tot
    FIELD peso-bru-tot          LIKE nota-fiscal.peso-bru-tot
    FIELD cod-emitente          LIKE nota-fiscal.cod-emitente
    FIELD nr-pedido             LIKE ped-venda.nr-pedido
    FIELD NAME                  AS CHARACTER
    FIELD new_chaveintegracao   AS CHARACTER
    FIELD pricelevelid          AS CHARACTER
    FIELD transactioncurrencyid AS CHARACTER
    FIELD observ-nota           AS CHARACTER
    FIELD dt-saida              LIKE nota-fiscal.dt-saida
    FIELD nr-volumes            LIKE nota-fiscal.nr-volumes
    FIELD cidade-cif            LIKE nota-fiscal.cidade-cif
    FIELD vl-bicms-it           LIKE it-nota-fisc.vl-bicms-it
    FIELD vl-icms-it            LIKE it-nota-fisc.vl-icms-it
    FIELD vl-ipi-it             LIKE it-nota-fisc.vl-ipi-it
    FIELD vl-bsubs-it           LIKE it-nota-fisc.vl-bsubs-it
    FIELD vl-subs-it            LIKE it-nota-fisc.vl-icmsub-it
    FIELD vl-frete              LIKE it-nota-fisc.vl-icms-it.

DEFINE TEMP-TABLE tt-it-nota-fisc NO-UNDO
    FIELD it-codigo                    LIKE it-nota-fisc.it-codigo
    FIELD qt-faturada                  LIKE it-nota-fisc.qt-faturada[1]
    FIELD vl-pretab                    LIKE it-nota-fisc.vl-pretab
    FIELD vl-preori                    LIKE it-nota-fisc.vl-preori
    FIELD vl-preuni                    LIKE it-nota-fisc.vl-preuni
    FIELD vl-merc-tab                  LIKE it-nota-fisc.vl-merc-tab
    FIELD vl-merc-ori                  LIKE it-nota-fisc.vl-merc-ori
    FIELD vl-merc-liq                  LIKE it-nota-fisc.vl-merc-liq
    FIELD vl-tot-item                  LIKE it-nota-fisc.vl-tot-item
    FIELD nat-operacao                 LIKE it-nota-fisc.nat-operacao
    FIELD nota-fiscal                  AS   CHARACTER
    FIELD isproductoverridden          AS   char
    FIELD ispriceoverridden            AS   char
    FIELD un                           LIKE item.un
    FIELD cd-trib-icm                  AS   CHAR
    field vl-bicms-it                  like it-nota-fisc.vl-bicms-it 
    field vl-bsubs-it                  like it-nota-fisc.vl-bsubs-it 
    field aliquota-icm                 like it-nota-fisc.aliquota-icm
    field vl-icms-it                   like it-nota-fisc.vl-icms-it  
    field vl-icmsub-it                 like it-nota-fisc.vl-icmsub-it
    field vl-icmsnt-it                 like it-nota-fisc.vl-icmsnt-it
    field vl-icmsou-it                 like it-nota-fisc.vl-icmsou-it
    field cd-trib-iss                  AS   CHAR
    field cd-trib-ipi                  AS   CHAR
    field vl-biss-it                   like it-nota-fisc.vl-biss-it  
    field vl-bipi-it                   like it-nota-fisc.vl-bipi-it  
    field aliquota-ISS                 like it-nota-fisc.aliquota-ISS
    field aliquota-ipi                 like it-nota-fisc.aliquota-ipi
    field vl-iss-it                    like it-nota-fisc.vl-iss-it   
    field vl-ipi-it                    like it-nota-fisc.vl-ipi-it   
    field vl-issnt-it                  like it-nota-fisc.vl-issnt-it 
    field vl-ipint-it                  like it-nota-fisc.vl-ipint-it 
    field vl-issou-it                  like it-nota-fisc.vl-issou-it 
    field vl-ipiou-it                  like it-nota-fisc.vl-ipiou-it 
    field vl-precon                    like it-nota-fisc.vl-precon
    FIELD new_chaveintegracao          AS CHARACTER.
    
DEFINE TEMP-TABLE tt-ocorrencia NO-UNDO
    FIELD nr-ocorrencia      AS INTEGER FORMAT ">>>>>>9"
    FIELD dt-ocorrencia      AS DATE    FORMAT "99/99/9999" 
    FIELD ds-ocorrencia      AS CHARACTER
    FIELD des-tipo           AS CHAR
    FIELD chave-integracao-nota-fiscal AS CHARACTER
    FIELD chave-integracao-ocorrencia  AS CHARACTER.
    
define temp-table tt-cep no-undo
    field cep                 like cep.cep
    field nome-complto        as char format "x(80)"
    field bairro-ini          like cep.bairro-ini
    field bairro-fin          like cep.bairro-fin
    field localidade          like cep.localidade
    field uf                  like cep.uf
    field new_chaveintegracao as char.

define temp-table tt-crm-categoria no-undo
    field cd-categoria        like crm-categoria.cd-categoria
    field ds-categoria        AS CHAR FORMAT "x(50)".

define temp-table tt-crm-categ-un no-undo
    field cd-categoria        as char
    FIELD cd-unid-negoc       AS CHAR FORMAT "x(50)"
    FIELD NEW_name            AS CHAR  
    field new_chaveintegracao AS CHAR.

DEFINE TEMP-TABLE tt-fat-duplic NO-UNDO
    FIELD nr-fatura             LIKE fat-duplic.nr-fatura
    FIELD dt-venciment          LIKE fat-duplic.dt-venciment
    FIELD vl-parcela            LIKE fat-duplic.vl-parcela
    FIELD name                  AS CHARACTER
    FIELD new_chaveintegracao   AS CHARACTER.
